import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'apptheme/theme_provider.dart';
import 'providers/translation_provider.dart';
import 'screens/translation_screen.dart';

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
        home: const TranslationScreen(),
      ),
    );
  }
}
