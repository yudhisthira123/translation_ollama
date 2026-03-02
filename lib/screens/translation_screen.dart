import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/translation_provider.dart';
import '../util/widgets/chatInputWidget.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text("Translator")),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                    
                          Row(
                            children: [
                    
                              /// SOURCE
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: provider.sourceLanguage,
                                  decoration: const InputDecoration(
                                    labelText: "Source Language",
                                    border: OutlineInputBorder(),
                                  ),
                                  items: provider.languages.map((lang) {
                                    bool disabled =
                                        lang == provider.targetLanguage;
                    
                                    return DropdownMenuItem(
                                      value: lang,
                                      enabled: !disabled,
                                      child: Text(
                                        lang,
                                        style: TextStyle(
                                          color: disabled
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      provider.setSourceLanguage(val);
                                    }
                                  },
                                ),
                              ),
                    
                              const SizedBox(width: 12),
                    
                              /// TARGET
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: provider.targetLanguage,
                                  decoration: const InputDecoration(
                                    labelText: "Target Language",
                                    border: OutlineInputBorder(),
                                  ),
                                  items: provider.languages.map((lang) {
                                    bool disabled =
                                        lang == provider.sourceLanguage;
                    
                                    return DropdownMenuItem(
                                      value: lang,
                                      enabled: !disabled,
                                      child: Text(
                                        lang,
                                        style: TextStyle(
                                          color: disabled
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      provider.setTargetLanguage(val);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                    
                          const SizedBox(height: 20),
                          /// SOURCE TEXT BOX (editable)
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: TextEditingController(text: provider.inputText)
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: provider.inputText.length),
                                ),
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: "Enter source text",
                                border: InputBorder.none,
                              ),
                              onChanged: provider.setInputText,
                            ),
                          ),

                          const SizedBox(height: 16),
                    
                          /// TRANSLATED TEXT BOX
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                provider.translatedText.isEmpty
                                    ? "Translated text appears here"
                                    : provider.translatedText,
                              ),
                            ),
                          ),
                    
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// INPUT FIELD
              ChatInputWidget(translationProvider: provider),
            ],
          ),
        );
      },
    );
  }
}
