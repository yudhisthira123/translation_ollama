import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:translation/screens/welcome_screen.dart';
import '../constants.dart';
import '../providers/translation_provider.dart';
import '../responsive/responsive.dart';
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
      context.read<TranslationProvider>().messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TranslationProvider>(
      builder: (context, provider, child) {
        if (Responsive.isMobile(context)) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                AppStrings.get(context, 'translator').toUpperCase(),
                style: TextStyle(color: Color(0xFF43B786)),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WelcomeScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(
                                    -1.0,
                                    0.0,
                                  ); // left → right
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 35,
                        width: 44,
                        child: SvgPicture.asset(
                          "assets/images/close.svg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ],
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                bgColorContainer(true),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Column(
                      children: [
                        Expanded(child: _bodyMobile(context, provider)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                AppStrings.get(context, 'translator').toUpperCase(),
                style: TextStyle(color: Color(0xFF43B786)),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    WelcomeScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(
                                    -1.0,
                                    0.0,
                                  ); // left → right
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                            transitionDuration: Duration(milliseconds: 100),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 35,
                        width: 44,
                        child: SvgPicture.asset(
                          "assets/images/close.svg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ],
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                bgColorContainer(false),
                Center(
                  child: SizedBox(
                    width: 800,
                    height: 800,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Column(
                          children: [
                            Expanded(flex: 1, child: SizedBox()),
                            Expanded(
                              flex: 30,
                              child: _bodyDesktop(context, provider),
                            ),
                            Expanded(flex: 1, child: SizedBox()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

void showSettingsDialog(BuildContext context) {
  final provider = Provider.of<TranslationProvider>(context, listen: false);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Settings",
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              // 🔥 Blur Background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),

              // Dialog UI
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.85
                          : 700,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.get(
                                  context,
                                  'setting',
                                ).toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF424242),
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const CircleAvatar(
                                  radius: 14,
                                  child: Icon(Icons.close, size: 16),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 45),

                          // 🔊 Volume
                          buildSlider(
                            context: context,
                            title: AppStrings.get(
                              context,
                              'volume',
                            ).toUpperCase(),
                            icon: "assets/images/volume_icon.png",
                            value: provider.volume,
                            onChanged: (v) {
                              provider.setVolume(v);
                              setState(() => provider.volume = v);
                            },
                          ),

                          const SizedBox(height: 10),

                          // 🎵 Pitch
                          buildSlider(
                            context: context,
                            title: AppStrings.get(
                              context,
                              'pitch',
                            ).toUpperCase(),
                            icon: "assets/images/pitch_icon.png",
                            value: provider.pitch,
                            onChanged: (v) {
                              provider.setPitch(v);
                              setState(() => provider.pitch = v);
                            },
                          ),

                          const SizedBox(height: 10),

                          // 🎙 Rate
                          buildSlider(
                            context: context,
                            title: AppStrings.get(
                              context,
                              'rateOfVoice',
                            ).toUpperCase(),
                            icon: "assets/images/mic_icon.png",
                            value: provider.rate,
                            onChanged: (v) {
                              provider.setRate(v);
                              setState(() => provider.rate = v);
                            },
                          ),
                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget bgColorContainer(bool isMobile) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFFFFFFFF),
          isMobile
              ? Color(0xFF66BB6A)
              : const Color(0xFF66BB6A).withOpacity(0.2),
          const Color(0xFFFFFFFF),
        ],
        stops: isMobile ? const [0.0, 0.5, 1.0] : const [0.0, 0.4, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}

Widget _bodyMobile(BuildContext context, TranslationProvider provider) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 40, bottom: 45),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: DiagonalPainter(),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Transform.rotate(
                angle: 3.1416, // 180 degrees in radians
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 140),
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
                              if (provider.hasError) {
                                return Center(
                                  child: Text(
                                    provider.errorMessage,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              // ✅ SUCCESS / DEFAULT
                              return SingleChildScrollView(
                                reverse: true,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 14,
                                    right: 14,
                                    top: 10,
                                    bottom: 30,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// 🟢 HISTORY
                                      ...provider.messages.map((msg) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            "${msg.speakerLabel} - ${msg.isHost ? msg.originalText : msg.translatedText}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }),

                                      /// 🔴 LIVE TEXT
                                      if (provider.isHostSpeaking &&
                                          provider.liveText.isNotEmpty)
                                        Text(
                                          "Host - ${provider.liveText}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),

                                      /// 🟢 LOADER (SHOW IN HOST BOX WHEN GUEST IS SPEAKING)
                                      if (!provider.isHostSpeaking &&
                                          provider.isTranslating)
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/dot.gif",
                                              height: 37,
                                              width: 56,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              // flex: 2,
              flex: MediaQuery.of(context).size.height < 500 ? 6 : 2,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      /// 🔵 LEFT 50% SVG
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: constraints.maxWidth * 0.5,
                        child: SvgPicture.asset(
                          "assets/images/green_rectangle.svg",
                          fit: BoxFit.fill,
                        ),
                      ),

                      /// 🟢 RIGHT 50% SVG
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: constraints.maxWidth * 0.5,
                        child: SvgPicture.asset(
                          "assets/images/white_rectangle.svg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 15),
                                      Transform.rotate(
                                        angle: 3.1416,
                                        child: SizedBox(
                                          height: 10,
                                          width: 15,
                                          child: Image.asset(
                                            "assets/images/polygon.png",
                                            fit: BoxFit.fill,
                                            color: Color(0xFFC9DED4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: provider.hostLanguage,
                                  style: TextStyle(color: Colors.black),
                                  iconSize: 0,
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFC9DED4),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  items: provider.languages.reversed.map((
                                    lang,
                                  ) {
                                    return DropdownMenuItem(
                                      value: lang,
                                      child: Transform.rotate(
                                        angle: 3.1416,
                                        child: Row(
                                          children: [
                                            Text(lang),
                                            Icon(Icons.arrow_drop_down),
                                          ],
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
                                Expanded(child: SizedBox()),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                            height: 35,
                            width: 40,
                            child: Image.asset(
                              "assets/images/swap_button.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: SizedBox()),
                                DropdownButtonFormField<String>(
                                  value: provider.guestLanguage,
                                  style: TextStyle(color: Colors.black),
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFC9DED4),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
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
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 15),
                                      SizedBox(
                                        height: 10,
                                        width: 15,
                                        child: Image.asset(
                                          "assets/images/polygon.png",
                                          fit: BoxFit.fill,
                                          color: Color(0xFFC9DED4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 140),
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 10,
                  bottom: 30,
                ),
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
                            if (provider.hasError) {
                              return Center(
                                child: Text(
                                  provider.errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              reverse: true,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...provider.messages.map((msg) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          "${msg.speakerLabel} - ${msg.isHost ? msg.translatedText : msg.originalText}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }),

                                    if (!provider.isHostSpeaking &&
                                        provider.liveText.isNotEmpty)
                                      Text(
                                        "Guest - ${provider.liveText}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),

                                    if (provider.isHostSpeaking &&
                                        provider.isTranslating)
                                      Image.asset(
                                        "assets/images/dot.gif",
                                        height: 37,
                                        width: 56,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatInputWidget(translationProvider: provider, isHost: true),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatInputWidget(translationProvider: provider, isHost: false),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            showSettingsDialog(context);
          },
          child: SizedBox(
            height: 35,
            width: 44,
            child: Image.asset("assets/images/settings.png", fit: BoxFit.fill),
          ),
        ),
      ),
    ],
  );
}

Widget _bodyDesktop(BuildContext context, TranslationProvider provider) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 40, bottom: 60),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: DiagonalPainter(),
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Transform.rotate(
              angle: 3.1416,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 140),
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
                            // ❌ ERROR
                            if (provider.hasError) {
                              return Center(
                                child: Text(
                                  provider.errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            // ✅ SUCCESS / DEFAULT
                            return SingleChildScrollView(
                              reverse: true,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 55.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// 🟢 HISTORY
                                    ...provider.messages.map((msg) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          "${msg.speakerLabel} - ${msg.isHost ? msg.originalText : msg.translatedText}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }),

                                    /// 🔴 LIVE TEXT
                                    if (provider.isHostSpeaking &&
                                        provider.liveText.isNotEmpty)
                                      Text(
                                        "Host - ${provider.liveText}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),

                                    /// 🟢 LOADER (SHOW IN HOST BOX WHEN GUEST IS SPEAKING)
                                    if (!provider.isHostSpeaking &&
                                        provider.isTranslating)
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/dot.gif",
                                            height: 56,
                                            width: 80,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: MediaQuery.of(context).size.height < 500 ? 5 : 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    /// 🔵 LEFT 50% SVG
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: constraints.maxWidth * 0.5,
                      child: SvgPicture.asset(
                        "assets/images/green_rectangle.svg",
                        fit: BoxFit.fill,
                      ),
                    ),

                    /// 🟢 RIGHT 50% SVG
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: constraints.maxWidth * 0.5,
                      child: SvgPicture.asset(
                        "assets/images/white_rectangle.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 15),
                                    Transform.rotate(
                                      angle: 3.1416,
                                      child: SizedBox(
                                        height: 10,
                                        width: 15,
                                        child: Image.asset(
                                          "assets/images/polygon.png",
                                          fit: BoxFit.fill,
                                          color: Color(0xFFC9DED4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: provider.hostLanguage,
                                style: TextStyle(color: Colors.black),
                                iconSize: 0,
                                dropdownColor: Colors.white,
                                iconEnabledColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFC9DED4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                ),
                                items: provider.languages.reversed.map((lang) {
                                  return DropdownMenuItem(
                                    value: lang,
                                    child: Transform.rotate(
                                      angle: 3.1416,
                                      child: Row(
                                        children: [
                                          Text(lang),
                                          Icon(Icons.arrow_drop_down),
                                        ],
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
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          height: 35,
                          width: 40,
                          child: Image.asset(
                            "assets/images/swap_button.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: SizedBox()),
                              DropdownButtonFormField<String>(
                                value: provider.guestLanguage,
                                style: TextStyle(color: Colors.black),
                                dropdownColor: Colors.white,
                                iconEnabledColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFC9DED4),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
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
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 15),
                                    SizedBox(
                                      height: 10,
                                      width: 15,
                                      child: Image.asset(
                                        "assets/images/polygon.png",
                                        fit: BoxFit.fill,
                                        color: Color(0xFFC9DED4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 140),
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
                          // ❌ ERROR
                          if (provider.hasError) {
                            return Center(
                              child: Text(
                                provider.errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          // ✅ SUCCESS / DEFAULT
                          return SingleChildScrollView(
                            reverse: true,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 75.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 🟢 HISTORY
                                  ...provider.messages.map((msg) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        "${msg.speakerLabel} - ${msg.isHost ? msg.translatedText : msg.originalText}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }),

                                  /// 🔴 LIVE TEXT
                                  if (!provider.isHostSpeaking &&
                                      provider.liveText.isNotEmpty)
                                    Text(
                                      "Guest - ${provider.liveText}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                  /// 🟢 LOADER (SHOW IN GUEST BOX WHEN HOST IS SPEAKING)
                                  if (provider.isHostSpeaking &&
                                      provider.isTranslating)
                                    Image.asset(
                                      "assets/images/dot.gif",
                                      height: 56,
                                      width: 80,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatInputWidget(translationProvider: provider, isHost: true),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: SizedBox(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChatInputWidget(translationProvider: provider, isHost: false),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            showSettingsDialog(context);
          },
          child: SizedBox(
            height: 35,
            width: 44,
            child: Image.asset("assets/images/settings.png", fit: BoxFit.fill),
          ),
        ),
      ),
    ],
  );
}

Widget buildSlider({
  required BuildContext context,
  required String title,
  required String icon,
  required double value,
  required Function(double) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: Image.asset(icon, fit: BoxFit.fill),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF424242),
              ),
            ),
          ],
        ),
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: RectangularThumbShape(width: 12, height: 26),
                overlayShape: SliderComponentShape.noOverlay,
                activeTrackColor: Color(0xFFD9D9D9),
                inactiveTrackColor: Color(0xFFD9D9D9),
                thumbColor: Color(0xFF6F7773),
              ),
              child: Slider(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                value: value,
                min: 0,
                max: 1,
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.get(context, 'min'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF424242),
                  ),
                ),
                Text(
                  AppStrings.get(context, 'max'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
