import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translation/screens/login_screen.dart';
import 'apptheme/theme_provider.dart';
import 'constants.dart';
import 'providers/translation_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // runApp(const MyApp());
  runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ChangeNotifierProvider(
      create: (_) => TranslationProvider(),
      child: MaterialApp(
        theme: themeProvider.themeData,
        debugShowCheckedModeBanner: false,
        locale: WidgetsBinding.instance.window.locale,
        supportedLocales: supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // home: const TranslationScreen(),
        home: LoginScreen(),
      ),
    );
  }
}
