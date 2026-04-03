import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:ollama_dart/ollama_dart.dart';


enum TranslationStatus { idle, loading, success, error }

class TranslationProvider extends ChangeNotifier {
  // final List<String> languages = ["English", "Hindi", "German"];
  final List<String> languages = ["English", "Hindi", "German","Spanish",
    "French","Dutch","Russian","Portuguese","Japanese"];
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

  final client = OllamaClient(
      config: OllamaConfig(
          baseUrl: "http://192.168.2.37:11434"
      )
  );
  // final client = OllamaClient(baseUrl: "http://192.168.0.106:11434/api");
  // final ai_model = "llama3.2";
  final aiModel = "translategemma:latest";

  String _hostLanguage = "German";
  String _guestLanguage = "English";

  String _sourceLanguage = "";
  String _targetLanguage = "";

  late String _speechLanguage = _guestLanguage;

  String _translatedText = "";
  String _inputText = "";

  String get hostLanguage => _hostLanguage;
  String get guestLanguage => _guestLanguage;
  String get speechLanguage => _speechLanguage;
  String get translatedText => _translatedText;
  String get inputText => _inputText;

  String _errorMessage = "";
  TranslationStatus _status = TranslationStatus.idle;

  String get errorMessage => _errorMessage;
  TranslationStatus get status => _status;

  bool get isLoading => _status == TranslationStatus.loading;
  bool get hasError => _status == TranslationStatus.error;



  void setSourceLanguage(String value) {
    _hostLanguage = value;
    notifyListeners();
  }

  void setTargetLanguage(String value) {
    _guestLanguage = value;
    notifyListeners();
  }

  void setSpeechLanguage(bool isHost) {
    _speechLanguage = isHost ? guestLanguage : hostLanguage;

    if(isHost) {
      _sourceLanguage = hostLanguage;
      _targetLanguage = guestLanguage;
    }
    else {
      _sourceLanguage = guestLanguage;
      _targetLanguage = hostLanguage;
    }

    notifyListeners();
  }

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

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
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fromLanguage": languageCodes[_sourceLanguage],
          "toLanguage": languageCodes[_targetLanguage],
          "textToBeTranslate": _inputText,
        }),
      )
          .timeout(const Duration(seconds: 10));

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data is List &&
              data.isNotEmpty &&
              data[0]["translations"] != null) {
            _translatedText =
                data[0]["translations"][0]["text"].toString();

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
  // Future<void> translate() async {
  //   print("Translation started for = $_inputText");
  //
  //   final url = Uri.parse(
  //     "https://simpra.azurewebsites.net/Translation/Translate"
  //   );
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         "fromLanguage": languageCodes[_sourceLanguage],
  //         "toLanguage": languageCodes[_targetLanguage],
  //         "textToBeTranslate": _inputText
  //       },)
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       _translatedText =
  //           data[0]["translations"][0]["text"].toString();
  //
  //       print("translated text = $_translatedText");
  //     } else {
  //       print("Error: ${response.statusCode}");
  //       print("Body: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Translation error: $e");
  //   }
  //
  //   notifyListeners();
  // }

  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

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


  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    await flutterTts.setLanguage( languageCodes[_speechLanguage] ?? 'en'); // change if needed
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    isSpeaking = true;
    notifyListeners();

    await flutterTts.speak(text);
  }

  Future<void> stop() async {
    await flutterTts.stop();

    isSpeaking = false;
    notifyListeners();
  }
}

