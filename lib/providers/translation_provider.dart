import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';

class TranslationProvider extends ChangeNotifier {
  final List<String> languages = ["English", "Hindi", "German"];
  // final client = OllamaClient(baseUrl: "http://192.168.2.37:11434/api");
  final client = OllamaClient(baseUrl: "http://192.168.0.106:11434/api");

  String _sourceLanguage = "English";
  String _targetLanguage = "Hindi";

  String _translatedText = "";
  String _inputText = "";

  String get sourceLanguage => _sourceLanguage;
  String get targetLanguage => _targetLanguage;
  String get translatedText => _translatedText;
  String get inputText => _inputText;

  void setSourceLanguage(String value) {
    _sourceLanguage = value;

    /// auto fix if same
    if (_sourceLanguage == _targetLanguage) {
      _targetLanguage =
          languages.firstWhere((e) => e != _sourceLanguage);
    }

    notifyListeners();
  }

  void setTargetLanguage(String value) {
    _targetLanguage = value;

    /// auto fix if same
    if (_targetLanguage == _sourceLanguage) {
      _sourceLanguage =
          languages.firstWhere((e) => e != _targetLanguage);
    }

    notifyListeners();
  }

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  Future<void> translate() async {

    print("Translation started for = $_inputText");

    final generated = await client.generateCompletion(
      request: GenerateCompletionRequest(
        model: 'llama3.2',
        prompt: "Translate from $sourceLanguage to $targetLanguage: $_inputText",
      ),
    );

    _translatedText = generated.response ?? "Sorry";

    print("translated text = $_translatedText");

    notifyListeners();
  }
}
