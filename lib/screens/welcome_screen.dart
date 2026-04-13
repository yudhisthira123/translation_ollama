// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:translation/screens/translation_screen.dart';
//
// import '../constants.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   final FlutterTts tts = FlutterTts();
//
//   final Map<String, String> ttsLang = {
//     'en': 'en-US',
//     'hi': 'hi-IN',
//     'de': 'de-DE',
//     'es': 'es-ES',
//     'fr': 'fr-FR',
//     'nl': 'nl-NL',
//     'ru': 'ru-RU',
//     'pt': 'pt-PT',
//     'ja': 'ja-JP',
//   };
//
//   Future speak() async {
//     String lang = Localizations.localeOf(context).languageCode;
//
//     await tts.setLanguage(ttsLang[lang] ?? 'en-US');
//     await tts.speak(AppStrings.get(context, 'welcome'));
//
//     tts.setCompletionHandler(() {
//       goNext();
//     });
//   }
//
//   void goNext() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => TranslationScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final text = AppStrings.get(context, 'welcome');
//
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             onPressed: goNext,
//             child: Text(
//               AppStrings.get(context, 'skip'),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(text, textAlign: TextAlign.center),
//               const SizedBox(height: 20),
//               IconButton(
//                 icon: const Icon(Icons.volume_up, size: 40),
//                 onPressed: speak,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translation/screens/translation_screen.dart';

import '../constants.dart';
import '../responsive/responsive.dart';

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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TranslationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // right → left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => TranslationScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final text = AppStrings.get(context, 'welcome');
    if (Responsive.isMobile(context)) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.get(context, 'translator').toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF43B786),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        body: Stack(
          children: [
            // 🌈 BACKGROUND GRADIENT
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

            // 🌊 WAVE 1 (BACK - LIGHT)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 160,
                child: SvgPicture.asset(
                  "assets/images/wave_light.svg", // your first SVG
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // 🌊 WAVE 2 (FRONT - DARK)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 220,
                child: SvgPicture.asset(
                  "assets/images/wave_dark.svg", // your second SVG
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // 📦 MAIN CONTENT
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // 🖼️ SVG IMAGE
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SvgPicture.asset(
                        "assets/images/welcome_page_image.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✨ TEXT
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // 🚀 BUTTON
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8AD8B7), Color(0xFF0A4F32)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: speak,
                              icon: const Icon(Icons.volume_up, color: Colors
                                  .white),
                              label: Text(
                                AppStrings.get(context, 'translate'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8AD8B7), Color(0xFF0A4F32)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: goNext,
                              label: Text(
                                "Skip",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.get(context, 'translator').toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF43B786),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        body: Stack(
          children: [
            // 🌈 BACKGROUND GRADIENT
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFF66BB6A),
                    // Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // 🌊 WAVE 1 (BACK - LIGHT)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 460,
                child: SvgPicture.asset(
                  "assets/images/wave_light.svg", // your first SVG
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // 🌊 WAVE 2 (FRONT - DARK)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 640,
                child: SvgPicture.asset(
                  "assets/images/wave_dark.svg", // your second SVG
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // 📦 MAIN CONTENT
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // 🖼️ SVG IMAGE
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SvgPicture.asset(
                        "assets/images/welcome_page_image.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ✨ TEXT
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // 🚀 BUTTON
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8AD8B7), Color(0xFF0A4F32)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: speak,
                              icon: const Icon(Icons.volume_up, color: Colors
                                  .white),
                              label: Text(
                                AppStrings.get(context, 'translate'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8AD8B7), Color(0xFF0A4F32)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: goNext,
                              label: Text(
                                "Skip",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
