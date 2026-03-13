import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/translation_provider.dart';
import '../util/widgets/chatInputWidget.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFF0F172A),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text("Translator",style: TextStyle(color: AppColor.textColor),),
            centerTitle: true,
            backgroundColor: Color(0xFF0F172A),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HOST LANGUAGE
                  _buildTextWidget("Host Language"),
                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    value: provider.hostLanguage,
                    style: TextStyle(
                      color: AppColor.textColor,
                    ),
                    dropdownColor: AppColor.cardColor,
                    iconEnabledColor: AppColor.textColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.cardColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.textColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.textColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: provider.languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        provider.setSourceLanguage(val);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  ChatInputWidget(
                    translationProvider: provider,
                    isHost: true,
                  ),

                  const SizedBox(height: 20),

                  /// TRANSLATED TEXT
                  _buildTextWidget("Translated Text"),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // color: Colors.grey.shade50,
                      color: AppColor.cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: [

                        SingleChildScrollView(
                          child: Text(
                            provider.translatedText.isEmpty
                                ? "Translated text appears here"
                                : provider.translatedText,
                            style: const TextStyle(
                              color: AppColor.textColor,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),

                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: IconButton(
                            icon: Icon(
                              provider.isSpeaking
                                  ? Icons.stop
                                  : Icons.volume_up,
                              color: AppColor.textColor,
                            ),
                            onPressed: () async {
                              if (provider.isSpeaking) {
                                await provider.stop();
                              } else {
                                final text = provider.translatedText.isEmpty
                                    ? "Translated text appears here"
                                    : provider.translatedText;
                                await provider.speak(text);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// GUEST LANGUAGE
                  _buildTextWidget("Guest Language"),

                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    value: provider.guestLanguage,
                    style: TextStyle(
                      color: AppColor.textColor,
                    ),
                    dropdownColor: AppColor.cardColor,
                    iconEnabledColor: AppColor.textColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.cardColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.textColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.textColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(12),
                      // ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: provider.languages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        provider.setTargetLanguage(val);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  ChatInputWidget(
                    translationProvider: provider,
                    isHost: false,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildTextWidget(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColor.textColor
      ),
    );
  }
}

