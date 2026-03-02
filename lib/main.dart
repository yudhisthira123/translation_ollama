import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/translation_provider.dart';
import 'screens/translation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslationProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TranslationScreen(),
      ),
    );
  }
}
