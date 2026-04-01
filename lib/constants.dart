
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color darkBgColor = Color(0xFF0F172A);
  static const Color darkCardColor = Color(0xFF1E293B);
  static const Color darkPriBtnColor = Color(0xFF3B82F6);
  static const Color darkAccentColor = Color(0xFFF8FAFC);
  static const Color darkTextColor = Color(0xFFF8FAFC);
  static const Color darkChatWidgetBgColor = Color(0xFF091123);

  static const Color lightBgColor = Color(0xFFF1F5F9);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightPriBtnColor = Color(0xFF22C55E);
  static const Color lightAccentColor = Color(0xFF4ADE80);
  static const Color lightTextColor = Color(0xFF0F172A);
  static const Color lightChatWidgetBgColor = Color(0xFF087A32);
}

const supportedLocales = [
  Locale('en'), // English
  Locale('hi'), // Hindi
  Locale('de'), // German
  Locale('es'), // Spanish
  Locale('fr'), // French
  Locale('nl'), // Dutch
  Locale('ru'), // Russian
  Locale('pt'), // Portuguese
  Locale('ja'), // Japanese
];

class AppStrings {
  static Map<String, Map<String, String>> localizedValues = {
    'en': {
      'login': 'Login',
      'userId': 'User ID',
      'password': 'Password',
      'invalid': 'Invalid credentials',
      'welcome': 'Welcome to our application.\nWe are glad to have you.\nEnjoy your experience!',
      'skip': 'Skip',
      'main': 'Main Screen',
    },
    'hi': {
      'login': 'लॉगिन',
      'userId': 'यूज़र आईडी',
      'password': 'पासवर्ड',
      'invalid': 'अमान्य विवरण',
      'welcome': 'हमारे एप्लिकेशन में आपका स्वागत है।\nहमें खुशी है कि आप यहाँ हैं।\nअपने अनुभव का आनंद लें!',
      'skip': 'स्किप करें',
      'main': 'मुख्य स्क्रीन',
    },
    'de': {
      'login': 'Anmelden',
      'userId': 'Benutzer-ID',
      'password': 'Passwort',
      'invalid': 'Ungültige Anmeldedaten',
      'welcome': 'Willkommen in unserer Anwendung.\nWir freuen uns, dass Sie hier sind.\nViel Spaß!',
      'skip': 'Überspringen',
      'main': 'Startbildschirm',
    },
    'es': {
      'login': 'Iniciar sesión',
      'userId': 'Usuario',
      'password': 'Contraseña',
      'invalid': 'Credenciales inválidas',
      'welcome': 'Bienvenido a nuestra aplicación.\nNos alegra tenerte aquí.\n¡Disfruta!',
      'skip': 'Saltar',
      'main': 'Pantalla principal',
    },
    'fr': {
      'login': 'Connexion',
      'userId': 'Identifiant',
      'password': 'Mot de passe',
      'invalid': 'Identifiants invalides',
      'welcome': 'Bienvenue dans notre application.\nNous sommes heureux de vous avoir.\nProfitez!',
      'skip': 'Passer',
      'main': 'Écran principal',
    },
    'nl': {
      'login': 'Inloggen',
      'userId': 'Gebruikers-ID',
      'password': 'Wachtwoord',
      'invalid': 'Ongeldige gegevens',
      'welcome': 'Welkom bij onze app.\nFijn dat je er bent.\nVeel plezier!',
      'skip': 'Overslaan',
      'main': 'Hoofdscherm',
    },
    'ru': {
      'login': 'Войти',
      'userId': 'Имя пользователя',
      'password': 'Пароль',
      'invalid': 'Неверные данные',
      'welcome': 'Добро пожаловать в наше приложение.\nМы рады вас видеть.\nНаслаждайтесь!',
      'skip': 'Пропустить',
      'main': 'Главный экран',
    },
    'pt': {
      'login': 'Entrar',
      'userId': 'Usuário',
      'password': 'Senha',
      'invalid': 'Credenciais inválidas',
      'welcome': 'Bem-vindo ao nosso aplicativo.\nEstamos felizes em tê-lo aqui.\nAproveite!',
      'skip': 'Pular',
      'main': 'Tela principal',
    },
    'ja': {
      'login': 'ログイン',
      'userId': 'ユーザーID',
      'password': 'パスワード',
      'invalid': '無効な認証情報',
      'welcome': '私たちのアプリへようこそ。\nご利用いただきありがとうございます。\nお楽しみください！',
      'skip': 'スキップ',
      'main': 'メイン画面',
    },
  };

  static String get(BuildContext context, String key) {
    String lang = Localizations.localeOf(context).languageCode;
    return localizedValues[lang]?[key] ??
        localizedValues['en']![key]!;
  }
}

Future<bool> hasInternet() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}

void showError(BuildContext context,String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}