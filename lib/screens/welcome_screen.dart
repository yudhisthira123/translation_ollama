import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translation/screens/translation_screen.dart';

import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FlutterTts tts = FlutterTts();

  final Map<String, String> ttsLang = {
    'en': 'en-US',
    'hi': 'hi-IN',
    'de': 'de-DE',
    'es': 'es-ES',
    'fr': 'fr-FR',
    'nl': 'nl-NL',
    'ru': 'ru-RU',
    'pt': 'pt-PT',
    'ja': 'ja-JP',
  };

  Future speak() async {
    String lang = Localizations.localeOf(context).languageCode;

    await tts.setLanguage(ttsLang[lang] ?? 'en-US');
    await tts.speak(AppStrings.get(context, 'welcome'));

    tts.setCompletionHandler(() {
      goNext();
    });
  }

  void goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TranslationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppStrings.get(context, 'welcome');

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: goNext,
            child: Text(
              AppStrings.get(context, 'skip'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.volume_up, size: 40),
                onPressed: speak,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
