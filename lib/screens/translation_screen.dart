import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apptheme/apptheme.dart';
import '../apptheme/theme_provider.dart';
import '../providers/translation_provider.dart';
import '../util/widgets/chatInputWidget.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text("Translator",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActiveThemeButton(),
                  const SizedBox(height: 6),

                  /// HOST LANGUAGE
                  _buildTextWidget("Host Language",context),
                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    value: provider.hostLanguage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    iconEnabledColor: Theme.of(context).colorScheme.secondary,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
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
                  _buildTextWidget("Translated Text",context),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 140),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      // color: Colors.grey.shade50,
                      color: Theme.of(context).cardColor,
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
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                              color: Theme.of(context).colorScheme.secondary,
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
                  _buildTextWidget("Guest Language",context),

                  const SizedBox(height: 6),

                  DropdownButtonFormField<String>(
                    value: provider.guestLanguage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    iconEnabledColor: Theme.of(context).colorScheme.secondary,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
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
  Widget _buildTextWidget(String value,BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary
      ),
    );
  }
}

class ActiveThemeButton extends StatelessWidget {
  const ActiveThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentTheme = themeProvider.currentTheme;

    return GestureDetector(
      onTap: () {
        if (currentTheme == AppTheme.dark) {
          themeProvider.setTheme(AppTheme.light);
        }
        else {
          themeProvider.setTheme(AppTheme.dark);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _borderForTheme(currentTheme).withOpacity(0.15),
          border: Border.all(
            color: _borderForTheme(currentTheme),
            width: 1.5,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Icon(
            _iconForTheme(currentTheme),
            key: ValueKey(currentTheme),
            size: 22,
            color: _iconColorForTheme(currentTheme),
          ),
        ),
      ),
    );
  }
}

IconData _iconForTheme(AppTheme theme) {
  switch (theme) {
    case AppTheme.dark:
      return Icons.wb_sunny;
    case AppTheme.light:
      return Icons.brightness_3;
  }
}

Color _borderForTheme(AppTheme theme) {
  switch (theme) {
    case AppTheme.dark:
      return const Color(0xFF2C2C2C);
    case AppTheme.light:
      return const Color(0xFFA3A7AB);
  }
}

Color _iconColorForTheme(AppTheme theme) {
  return const Color(0xFFFFC83D);
}