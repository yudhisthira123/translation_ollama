import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:ollama_dart/ollama_dart.dart';

class TranslationProvider extends ChangeNotifier {
  // final List<String> languages = ["English", "Hindi", "German"];
  final List<String> languages = ["English", "Hindi", "German","Spanish",
    "French","Dutch","Russian","Portuguese","Japanese"];
  final Map<String, String> languageCodes = {
    "English": "en",
    "Hindi": "hi-IN",
    "German": "de-DE",
    "Spanish": "es",
    "French": "fr",
    "Dutch": "nl",
    "Russian": "ru",
    "Portuguese": "pt",
    "Japanese": "ja"
  };

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

  // Future<void> translate() async {
  //   print("Translation started for = $_inputText");
  //
  //   final generated = await client.chat.create(
  //       request: ChatRequest(
  //           model: aiModel,
  //           messages: [
  //             ChatMessage.system("You are a translation assistant. You can translate text from one language to another. Do not give explaination of translation. You need to just translate the exact text to required language in casual language."),
  //             ChatMessage.user("Translate from ${_sourceLanguage} to $_targetLanguage: $_inputText")
  //           ]
  //       )
  //   );
  //
  //   _translatedText = generated.message?.content ?? "";
  //   print("translated text = $_translatedText");
  //
  //   notifyListeners();
  // }

  Future<void> translate() async {
    print("Translation started for = $_inputText");

    final String apiKey = "";
    final String region = "GermanyWestCentral";

    // print("Source Language = $_sourceLanguage and code is ${languageCodes[_sourceLanguage]}");
    // print("Target Language = $_targetLanguage and code is ${languageCodes[_targetLanguage]}");
    final url = Uri.parse(
      "https://api.cognitive.microsofttranslator.com/translate"
          "?api-version=3.0"
          "&from=${languageCodes[_sourceLanguage]}"
          "&to=${languageCodes[_targetLanguage]}",
    );
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Ocp-Apim-Subscription-Key": apiKey,
          "Ocp-Apim-Subscription-Region": region,
        },
        body: jsonEncode([
          {"Text": _inputText}
        ]),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _translatedText =
            data[0]["translations"][0]["text"].toString();

        print("translated text = $_translatedText");
      } else {
        print("Error: ${response.statusCode}");
        print("Body: ${response.body}");
      }
    } catch (e) {
      print("Translation error: $e");
    }

    notifyListeners();
  }

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

