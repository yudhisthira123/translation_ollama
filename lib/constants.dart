
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      'welcome': 'Welcome To Your Smarter Translation Experience\nTap Below To Begin',
      'skip': 'Skip',
      'main': 'Main Screen',
      'translator': 'Translator',
      'translate': 'Translate',
      'setting': 'Setting',
      'volume': 'Volume',
      'pitch': 'Pitch',
      'rateOfVoice': 'Rate of Voice',
      'min': 'Min',
      'max': 'Max'
    },

    'hi': {
      'login': 'लॉगिन',
      'userId': 'यूज़र आईडी',
      'password': 'पासवर्ड',
      'invalid': 'अमान्य विवरण',
      'welcome': 'स्मार्ट अनुवाद के आपके अनुभव में आपका स्वागत है!\nशुरू करने के लिए नीचे टैप करें',
      'skip': 'स्किप करें',
      'main': 'मुख्य स्क्रीन',
      'translator': 'अनुवादक',
      'translate': 'अनुवाद करें',
      'setting': 'सेटिंग',
      'volume': 'आवाज़',
      'pitch': 'पिच',
      'rateOfVoice': 'आवाज़ की गति',
      'min': 'न्यूनतम',
      'max': 'अधिकतम'
    },

    'de': {
      'login': 'Anmelden',
      'userId': 'Benutzer-ID',
      'password': 'Passwort',
      'invalid': 'Ungültige Anmeldedaten',
      'welcome': 'Willkommen zu Ihrer intelligenteren Übersetzungserfahrung!\nTippen Sie unten, um zu beginnen',
      'skip': 'Überspringen',
      'main': 'Startbildschirm',
      'translator': 'Übersetzer',
      'translate': 'Übersetzen',
      'setting': 'Einstellungen',
      'volume': 'Lautstärke',
      'pitch': 'Tonhöhe',
      'rateOfVoice': 'Sprechgeschwindigkeit',
      'min': 'Min',
      'max': 'Max'
    },

    'es': {
      'login': 'Iniciar sesión',
      'userId': 'Usuario',
      'password': 'Contraseña',
      'invalid': 'Credenciales inválidas',
      'welcome': 'Bienvenido a tu experiencia de traducción más inteligente\nToca abajo para comenzar',
      'skip': 'Saltar',
      'main': 'Pantalla principal',
      'translator': 'Traductor',
      'translate': 'Traducir',
      'setting': 'Configuración',
      'volume': 'Volumen',
      'pitch': 'Tono',
      'rateOfVoice': 'Velocidad de voz',
      'min': 'Mín',
      'max': 'Máx'
    },

    'fr': {
      'login': 'Connexion',
      'userId': 'Identifiant',
      'password': 'Mot de passe',
      'invalid': 'Identifiants invalides',
      'welcome': 'Bienvenue dans votre expérience de traduction plus intelligente !\nAppuyez ci-dessous pour commencer',
      'skip': 'Passer',
      'main': 'Écran principal','translator': 'Traducteur',
      'translate': 'Traduire',
      'setting': 'Paramètres',
      'volume': 'Volume',
      'pitch': 'Hauteur',
      'rateOfVoice': 'Vitesse de la voix',
      'min': 'Min',
      'max': 'Max'
    },

    'nl': {
      'login': 'Inloggen',
      'userId': 'Gebruikers-ID',
      'password': 'Wachtwoord',
      'invalid': 'Ongeldige gegevens',
      'welcome': 'Welkom bij onze slimme vertaalervaring\nTik hieronder om te starten',
      'skip': 'Overslaan',
      'main': 'Hoofdscherm',
      'translator': 'Vertaler',
      'translate': 'Vertalen',
      'setting': 'Instellingen',
      'volume': 'Volume',
      'pitch': 'Toonhoogte',
      'rateOfVoice': 'Spreeksnelheid',
      'min': 'Min',
      'max': 'Max'
    },

    'ru': {
      'login': 'Войти',
      'userId': 'Имя пользователя',
      'password': 'Пароль',
      'invalid': 'Неверные данные',
      'welcome': 'Добро пожаловать в мир интеллектуального перевода!\nНажмите ниже, чтобы начать',
      'skip': 'Пропустить',
      'main': 'Главный экран',
      'translator': 'Переводчик',
      'translate': 'Перевести',
      'setting': 'Настройки',
      'volume': 'Громкость',
      'pitch': 'Высота тона',
      'rateOfVoice': 'Скорость речи',
      'min': 'Мин',
      'max': 'Макс'
    },

    'pt': {
      'login': 'Entrar',
      'userId': 'Usuário',
      'password': 'Senha',
      'invalid': 'Credenciais inválidas',
      'welcome': 'Bem-vindo à sua experiência de tradução mais inteligente!\nToque abaixo para começar',
      'skip': 'Pular',
      'main': 'Tela principal',
      'translator': 'Tradutor',
      'translate': 'Traduzir',
      'setting': 'Configurações',
      'volume': 'Volume',
      'pitch': 'Tom',
      'rateOfVoice': 'Velocidade da fala',
      'min': 'Mín',
      'max': 'Máx'
    },

    'ja': {
      'login': 'ログイン',
      'userId': 'ユーザーID',
      'password': 'パスワード',
      'invalid': '無効な認証情報',
      'welcome': 'よりスマートな翻訳体験へようこそ\n開始するには以下をタップしてください',
      'skip': 'スキップ',
      'main': 'メイン画面',
      'translator': '翻訳者',
      'translate': '翻訳する',
      'setting': '設定',
      'volume': '音量',
      'pitch': 'ピッチ',
      'rateOfVoice': '話速',
      'min': '最小',
      'max': '最大'
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

// Widget circleButton(
//     double height,
//     double width,
//     String icon, {
//       required VoidCallback onTap,
//     }) {
//   final bool isMicOn = icon == "assets/images/mic_on.gif";
//
//   return GestureDetector(
//     onTap: onTap,
//     child: SizedBox(
//       height: height,
//       width: width,
//       child: Center(
//         child: isMicOn ?
//         Image.asset(
//           "assets/images/mic_on.gif",
//           fit: BoxFit.fill,
//         )
//         //     ? Transform.rotate(
//         //   angle: 3.1416,
//         //   child: SvgPicture.asset(
//         //     icon,
//         //     fit: BoxFit.fill,
//         //   ),
//         // )
//             : SvgPicture.asset(
//           icon,
//           fit: BoxFit.fill,
//         ),
//       ),
//     ),
//   );
// }

Widget circleButton(
    double height,
    double width,
    String icon, {
      required VoidCallback onTap,
    }) {
  final bool isMicOn = icon == "assets/images/mic_on.gif";

  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      padding: isMicOn ? const EdgeInsets.all(8) : null,
      decoration: isMicOn ? BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // optional background
        border: Border.all(
          color: isMicOn ? Colors.green : Colors.grey,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ) : null,
      child: ClipOval(
        child: Center(
          child: isMicOn
              ? Image.asset(
            "assets/images/mic_on.gif",
            fit: BoxFit.contain,
          )
              : SvgPicture.asset(
            icon,
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}