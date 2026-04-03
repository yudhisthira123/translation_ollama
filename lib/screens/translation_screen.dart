import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../apptheme/apptheme.dart';
import '../apptheme/theme_provider.dart';
import '../providers/translation_provider.dart';
import '../util/widgets/chatInputWidget.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TranslationProvider>().setDefaultLanguageFromDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Translator",
              style: TextStyle(color: Color(0xFF43B786)),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFF66BB6A),
                      Color(0xFFFFFFFF),
                    ],
                    stops: [0.0, 0.5, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 10,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomPaint(
                              size: Size(double.infinity, double.infinity),
                              painter: DiagonalPainter(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ChatInputWidget(translationProvider: provider, isHost: true),
                                Expanded(
                                  flex: 4,
                                  child: Transform.rotate(
                                    angle: 3.1416, // 180 degrees in radians
                                    child: Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        minHeight: 140,
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: SizedBox(
                                        height: 150,
                                        child: Stack(
                                          children: [
                                            // 🧠 Main Content
                                            Positioned.fill(
                                              child: Builder(
                                                builder: (context) {
                                                  // 🔄 LOADING
                                                  if (provider.isLoading) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }

                                                  // ❌ ERROR
                                                  if (provider.hasError) {
                                                    return Center(
                                                      child: Text(
                                                        provider.errorMessage,
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  }

                                                  // ✅ SUCCESS / DEFAULT
                                                  return SingleChildScrollView(
                                                    child: Text(
                                                      provider
                                                              .translatedText
                                                              .isEmpty
                                                          ? "Translated text appears here"
                                                          : provider
                                                                .translatedText,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            // 🔊 SPEAKER BUTTON
                                            // Positioned(
                                            //   right: 0,
                                            //   bottom: 0,
                                            //   child: IconButton(
                                            //     icon: Icon(
                                            //       provider.isSpeaking ? Icons.stop : Icons.volume_up,
                                            //       color: Theme.of(context).colorScheme.secondary,
                                            //     ),
                                            //
                                            //     // 🚨 Disable when loading or error
                                            //     onPressed: (provider.isLoading || provider.hasError)
                                            //         ? null
                                            //         : () async {
                                            //       if (provider.isSpeaking) {
                                            //         await provider.stop();
                                            //       } else {
                                            //         final text = provider.translatedText.isEmpty
                                            //             ? "Translated text appears here"
                                            //             : provider.translatedText;
                                            //
                                            //         await provider.speak(text);
                                            //       }
                                            //     },
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: provider.hostLanguage,
                                          style: TextStyle(color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFE9EDEBA),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(12),
                                            // ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
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
                                      ),
                                      SizedBox(width: 40),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: provider.guestLanguage,
                                          style: TextStyle(color: Colors.black),
                                          dropdownColor: Colors.white,
                                          iconEnabledColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xFFE9EDEBA),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            // border: OutlineInputBorder(
                                            //   borderRadius: BorderRadius.circular(12),
                                            // ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                ),
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
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    width: double.infinity,
                                    constraints: const BoxConstraints(
                                      minHeight: 140,
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: SizedBox(
                                      height: 150,
                                      child: Stack(
                                        children: [
                                          // 🧠 Main Content
                                          Positioned.fill(
                                            child: Builder(
                                              builder: (context) {
                                                // 🔄 LOADING
                                                if (provider.isLoading) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                // ❌ ERROR
                                                if (provider.hasError) {
                                                  return Center(
                                                    child: Text(
                                                      provider.errorMessage,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                }

                                                // ✅ SUCCESS / DEFAULT
                                                return SingleChildScrollView(
                                                  child: Text(
                                                    provider
                                                            .translatedText
                                                            .isEmpty
                                                        ? "Translated text appears here"
                                                        : provider
                                                              .translatedText,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                          // 🔊 SPEAKER BUTTON
                                          // Positioned(
                                          //   right: 0,
                                          //   bottom: 0,
                                          //   child: IconButton(
                                          //     icon: Icon(
                                          //       provider.isSpeaking ? Icons.stop : Icons.volume_up,
                                          //       color: Theme.of(context).colorScheme.secondary,
                                          //     ),
                                          //
                                          //     // 🚨 Disable when loading or error
                                          //     onPressed: (provider.isLoading || provider.hasError)
                                          //         ? null
                                          //         : () async {
                                          //       if (provider.isSpeaking) {
                                          //         await provider.stop();
                                          //       } else {
                                          //         final text = provider.translatedText.isEmpty
                                          //             ? "Translated text appears here"
                                          //             : provider.translatedText;
                                          //
                                          //         await provider.speak(text);
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),

                                    // Stack(
                                    //   children: [
                                    //     SingleChildScrollView(
                                    //       child: Text(
                                    //         provider.translatedText.isEmpty
                                    //             ? "Translated text appears here"
                                    //             : provider.translatedText,
                                    //         style: TextStyle(
                                    //           color: Theme.of(context).colorScheme.secondary,
                                    //           fontSize: 15,
                                    //           height: 1.4,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //
                                    //     Positioned(
                                    //       right: -10,
                                    //       bottom: -10,
                                    //       child: IconButton(
                                    //         icon: Icon(
                                    //           provider.isSpeaking
                                    //               ? Icons.stop
                                    //               : Icons.volume_up,
                                    //           color: Theme.of(context).colorScheme.secondary,
                                    //         ),
                                    //         onPressed: () async {
                                    //           if (provider.isSpeaking) {
                                    //             await provider.stop();
                                    //           } else {
                                    //             final text = provider.translatedText.isEmpty
                                    //                 ? "Translated text appears here"
                                    //                 : provider.translatedText;
                                    //             await provider.speak(text);
                                    //           }
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ),
                                ),

                                // ChatInputWidget(translationProvider: provider, isHost: false),
                              ],
                            ),
                            Positioned(
                              top: -50,
                              left: 0,
                              right: 0,
                              child: Transform.rotate(
                                angle: 3.1416,
                                child: Column(
                                  children: [
                                    Text(
                                      "Gastmikrofon eingeschaltet",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              top: -25,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Transform.rotate(
                                    angle: 3.1416,
                                    child: Center(
                                      // child: _circleButton(30,30,Icons.pause, onTap: () {}),
                                      child: _circleButton(
                                        30,
                                        30,
                                        Icons.pause,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: 3.1416,
                                    child: Center(
                                      child: _circleButton(
                                        50,
                                        50,
                                        Icons.mic,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: 3.1416,
                                    child: Center(
                                      child: _circleButton(
                                        30,
                                        30,
                                        Icons.play_arrow,
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              bottom: -25,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(
                                    child: _circleButton(
                                      30,
                                      30,
                                      Icons.play_arrow,
                                      onTap: () {},
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: _circleButton(
                                          50,
                                          50,
                                          Icons.mic_off,
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: _circleButton(
                                      30,
                                      30,
                                      Icons.pause,
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -50,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Text(
                                    "Host Mic Off",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circleButton(
    double height,
    double width,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildTextWidget(String value, BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
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
        } else {
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
          border: Border.all(color: _borderForTheme(currentTheme), width: 1.5),
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

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final greenPaint = Paint()
      ..color = Colors.green.shade300
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 🔷 GREEN PART (Top side)
    Path greenPath = Path();
    greenPath.moveTo(0, 0);
    greenPath.lineTo(size.width, 0);
    greenPath.lineTo(size.width, size.height * 0.5);
    greenPath.lineTo(0, size.height * 0.5);
    greenPath.close();

    canvas.drawPath(greenPath, greenPaint);

    // ⚪ WHITE PART (Bottom side)
    Path whitePath = Path();
    whitePath.moveTo(0, size.height * 0.5);
    whitePath.lineTo(size.width, size.height * 0.5);
    whitePath.lineTo(size.width, size.height);
    whitePath.lineTo(0, size.height);
    whitePath.close();

    canvas.drawPath(whitePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
