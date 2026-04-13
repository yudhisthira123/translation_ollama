import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../util/model/message_model.dart';

enum TranslationStatus { idle, loading, success, error }

class TranslationProvider extends ChangeNotifier {

  /// 🌍 Languages
  final List<String> languages = [
    "English",
    "Hindi",
    "German",
    "Spanish",
    "French",
    "Dutch",
    "Russian",
    "Portuguese",
    "Japanese"
  ];

  final Map<String, String> languageCodes = {
    "English": "en",
    "Hindi": "hi",
    "German": "de",
    "Spanish": "es",
    "French": "fr",
    "Dutch": "nl",
    "Russian": "ru",
    "Portuguese": "pt",
    "Japanese": "ja"
  };

  /// 🔥 NEW STATE (IMPORTANT)
  List<Message> messages = [];
  String liveText = "";
  bool isHostSpeaking = true;

  /// 🔤 Languages
  String _hostLanguage = "German";
  String _guestLanguage = "English";

  String _sourceLanguage = "";
  String _targetLanguage = "";

  String _translatedText = "";
  String _inputText = "";

  String _errorMessage = "";
  TranslationStatus _status = TranslationStatus.idle;

  /// 🔊 TTS
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  double volume = 0.5;
  double pitch = 0.5;
  double rate = 0.5;

  void setVolume(double v) {
    volume = v.clamp(0.1, 1.0);
    volume = v;
    notifyListeners();
  }

  void setPitch(double v) {
    pitch = v;
    notifyListeners();
  }

  void setRate(double v) {
    rate = v;
    notifyListeners();
  }


  TranslationProvider() {
    flutterTts.setCompletionHandler(() {
      isSpeaking = false;
      notifyListeners();
    });

    flutterTts.setCancelHandler(() {
      isSpeaking = false;
      notifyListeners();
    });
  }

  /// GETTERS
  String get hostLanguage => _hostLanguage;
  String get guestLanguage => _guestLanguage;
  String get translatedText => _translatedText;
  String get inputText => _inputText;
  String get errorMessage => _errorMessage;
  TranslationStatus get status => _status;

  bool get isLoading => _status == TranslationStatus.loading;
  bool get hasError => _status == TranslationStatus.error;
  late String _speechLanguage = _guestLanguage;

  String get speechLanguage => _speechLanguage;


  /// 🌍 Default language
  String getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'Hindi';
      case 'en':
        return 'English';
      case 'de':
        return 'German';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'ru':
        return 'Russian';
      case 'pt':
        return 'Portuguese';
      case 'ja':
        return 'Japanese';
      default:
        return 'English';
    }
  }

  void setDefaultLanguageFromDevice() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final lang = getLanguageFromLocale(locale);

    _guestLanguage = lang;
    notifyListeners();
  }

  /// 🔄 Language setters
  void setSourceLanguage(String value) {
    _hostLanguage = value;
    notifyListeners();
  }

  void setTargetLanguage(String value) {
    _guestLanguage = value;
    notifyListeners();
  }

  /// 🔥 IMPORTANT (who is speaking)
  void setSpeechLanguage(bool isHost) {
    _speechLanguage = isHost ? guestLanguage : hostLanguage;

    isHostSpeaking = isHost;

    if (isHost) {
      _sourceLanguage = _hostLanguage;
      _targetLanguage = _guestLanguage;
    } else {
      _sourceLanguage = _guestLanguage;
      _targetLanguage = _hostLanguage;
    }

    notifyListeners();
  }

  /// 🔥 LIVE TEXT (speech)
  void updateLiveText(String text, {required bool isHost}) {
    liveText = text;
    isHostSpeaking = isHost;
    notifyListeners();
  }

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  /// 🚀 TRANSLATE (UPDATED)
  Future<void> translate() async {
    if (_inputText.isEmpty) {
      _errorMessage = "⚠️ Please enter text";
      _status = TranslationStatus.error;
      notifyListeners();
      return;
    }

    _status = TranslationStatus.loading;
    _errorMessage = "";
    notifyListeners();

    final url = Uri.parse(
        "https://simpra.azurewebsites.net/Translation/Translate"
    );

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fromLanguage": languageCodes[_sourceLanguage],
          "toLanguage": languageCodes[_targetLanguage],
          "textToBeTranslate": _inputText,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data is List &&
              data.isNotEmpty &&
              data[0]["translations"] != null) {
            _translatedText =
                data[0]["translations"][0]["text"].toString();

            // /// 🔥 ADD MESSAGE TO HISTORY
            messages.add(
              Message(
                originalText: _inputText,
                translatedText: _translatedText,
                isHost: isHostSpeaking,
              ),
            );

            // Speaking the translated text
            speak(_translatedText);

            /// 🔥 ADD MESSAGE FIRST (IMPORTANT)
            // messages.insert(
            //   0,
            //   Message(
            //     originalText: _inputText,
            //     translatedText: _translatedText,
            //     isHost: isHostSpeaking,
            //   ),
            // );

            /// 🔥 NOW CLEAR LIVE TEXT
            liveText = "";
            /// 🔥 CLEAR LIVE TEXT
            liveText = "";

            _status = TranslationStatus.success;
          } else {
            throw Exception("Invalid response structure");
          }
        } catch (e) {
          _errorMessage = "⚠️ Invalid response from server";
          _status = TranslationStatus.error;
        }
      }

      // ❌ CLIENT ERROR (400–499)
      else if (response.statusCode >= 400 &&
          response.statusCode < 500) {
        _errorMessage =
        "⚠️ Request error (${response.statusCode})";
        _status = TranslationStatus.error;
      }

      // ❌ SERVER ERROR (500+)
      else {
        _errorMessage = "⚠️ Server error. Try again later.";
        _status = TranslationStatus.error;
      }
    }

    // ⏱ TIMEOUT
    on TimeoutException {
      _errorMessage = "⚠️ Request timed out";
      _status = TranslationStatus.error;
    }

    // 🌐 NO INTERNET
    on SocketException {
      _errorMessage = "⚠️ No internet connection";
      _status = TranslationStatus.error;
    }

    // 🌍 FLUTTER WEB (CORS / blocked)
    on http.ClientException catch (e) {
      _errorMessage =
      "⚠️ Network error (CORS / blocked request)";
      _status = TranslationStatus.error;
      print("ClientException: $e");
    }

    // ❌ UNKNOWN ERROR
    catch (e) {
      _errorMessage = "⚠️ Something went wrong";
      _status = TranslationStatus.error;
      print("Unexpected error: $e");
    }

    notifyListeners();
  }

  /// 🔊 SPEAK
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    await flutterTts.setLanguage( languageCodes[_speechLanguage] ?? 'en');

    await flutterTts.setVolume(volume.clamp(0.1, 1.0));
    await flutterTts.setPitch(0.5 + (pitch * 1.5));
    // await flutterTts.setSpeechRate(0.3 + (rate * 0.7));

    double speechRate;
    if (Platform.isIOS) {
      speechRate = 0.2 + (rate * 0.3);
    } else {
      speechRate = 0.3 + (rate * 0.7);
    }

    await flutterTts.setSpeechRate(speechRate);

    if (Platform.isIOS) {
      await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
      );
    }


    isSpeaking = true;
    notifyListeners();

    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();
    isSpeaking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    messages.clear();
    super.dispose();
  }
}