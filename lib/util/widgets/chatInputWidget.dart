import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation/providers/translation_provider.dart';

class ChatInputWidget extends StatefulWidget {
  TranslationProvider translationProvider;
  bool isHost = true;

  ChatInputWidget({
    super.key,
    required this.translationProvider,
    required this.isHost
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";
  bool _speechEnabled = false;
  bool _receivedFinalResult = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micAnimation;


  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _micAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _micAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: (error) {
        // print("Speech error: $error");
        if (_isListening) _restartListening();
      },
    ).then((enabled) {
      _speechEnabled = enabled;
    });
  }

  void _onSpeechStatus(String status) {
    /// Android timeout (~10 sec)
    if (status == "done" && _isListening) {
      // print("Restarting due to Android timeout");
      _restartListening();
    }
  }

  void _restartListening() async {
    widget.translationProvider.setSpeechLanguage(widget.isHost);

    if (!_isListening || !_speechEnabled) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!_isListening) return;


    _speech.listen(
      onResult: (val) {
        if (!_isListening) return;
        final text = val.recognizedWords;

        if (val.finalResult) {
          _receivedFinalResult = true;

          _lastWords = "$_lastWords ${val.recognizedWords}".trim();
        }

        final fullText = val.finalResult
            ? _lastWords
            : "$_lastWords ${val.recognizedWords}".trim();


        setState(() {
          messageController.text = fullText;
          messageController.selection =
              TextSelection.collapsed(offset: text.length);
        });

        widget.translationProvider.setInputText(fullText);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
      ),
      localeId: widget.isHost
          ? widget.translationProvider.languageCodes[widget.translationProvider.hostLanguage]
          : widget.translationProvider.languageCodes[widget.translationProvider.guestLanguage],
    );
  }

  void _startListening() async {

    widget.translationProvider.setSpeechLanguage(widget.isHost);

    if (!_speech.isAvailable) {
      return;
    }

    // _lastWords = "";
    if (!_isListening) {
      _lastWords = messageController.text; // ✅ keep existing text
    }

    setState(() => _isListening = true);
    _micAnimationController.repeat(reverse: true);
    _speech.listen(
      onResult: (val) {
        if (!_isListening) return;
        final text = val.recognizedWords;

        if (val.finalResult) {
          /// append only final confirmed words
          _lastWords = "$_lastWords ${val.recognizedWords}".trim();
        }

        /// show live + previous words
        final fullText = val.finalResult
            ? _lastWords
            : "$_lastWords ${val.recognizedWords}".trim();

        setState(() {
          messageController.text = fullText;
          messageController.selection = TextSelection.fromPosition(
            TextPosition(offset: messageController.text.length),
          );
        });

        widget.translationProvider.setInputText(fullText);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds:5),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
      ),
      localeId: widget.isHost
          ? widget.translationProvider.languageCodes[widget.translationProvider.hostLanguage]
          : widget.translationProvider.languageCodes[widget.translationProvider.guestLanguage],
    );
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _micAnimationController.stop();
    _micAnimationController.reset();
    _speech.stop();
  }

  void _sendMessage() {

    widget.translationProvider.setSpeechLanguage(widget.isHost);

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (_isListening) {
      _stopListening();
    }

    widget.translationProvider.setInputText(text);
    widget.translationProvider.translate();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageController.clear();
      _lastWords = "";
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 550),
        child: Container(
          width: 550,// Given 550 so that it will look good on web also.
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  onChanged: widget.translationProvider.setInputText,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF2C2C2C),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _sendMessage();
                    }
                  },
                ),
              ),
              const SizedBox(width: 5),
              _buildSendButton(), // SEND BUTTON
              const SizedBox(width: 5),
              _buildMicButton(), // MIC BUTTON
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _speech.stop();
    _micAnimationController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget _buildSendButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF8E44AD),
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: _sendMessage,
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: () {
        if (_isListening) {
          _stopListening();
        } else {
          _startListening();
        }
      },
      child: AnimatedBuilder(
        animation: _micAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _micAnimation.value : 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isListening
                    ? const Color(0xFF8E44AD)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

