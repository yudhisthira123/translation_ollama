class Message {
  final String originalText;
  final String translatedText;
  final bool isHost;

  Message({
    required this.originalText,
    required this.translatedText,
    required this.isHost,
  });

  String get speakerLabel => isHost ? "Host" : "Guest";
}