

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'apptheme/apptheme.dart';
import 'apptheme/theme_provider.dart';

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


class RectangularThumbShape extends SliderComponentShape {
  final double width;
  final double height;

  const RectangularThumbShape({this.width = 12, this.height = 26});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCenter(center: center, width: width, height: height);

    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), paint);
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
      ..color = Color(0xFF8AD8B7)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Color(0xFFF3F3F3)
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