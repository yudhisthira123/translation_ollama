import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation/providers/translation_provider.dart';

class ChatInputWidget extends StatefulWidget {
  TranslationProvider translationProvider;

  ChatInputWidget({
    super.key,
     required this.translationProvider
    });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController messageController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = "";
  bool _speechEnabled = false;
  bool _receivedFinalResult = false;


  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

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
    // print("Speech status: $status");

    // if (status == "done" && _isListening) {
    //   _speech.stop(); // important for Android
    //   _restartListening();
    // }
    /// silence pause reached (pauseFor: 3 sec)
    // if (status == "notListening" && _isListening) {
    //   print("Stopped due to silence pause");
    //   _stopListening(); // stop permanently
    //   return;
    // }

    /// Android timeout (~10 sec)
    if (status == "done" && _isListening) {
      // print("Restarting due to Android timeout");
      _restartListening();
    }
  }

  // void _restartListening() async {
  //   if (!_isListening) return;
  //
  //   await _speech.stop();
  //
  //   await Future.delayed(const Duration(milliseconds: 300));
  //
  //   if (_isListening) {
  //     print("Restarting listening...");
  //     _startListening();
  //   }
  // }

  void _restartListening() async {
    if (!_isListening || !_speechEnabled) return;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!_isListening) return;


    _speech.listen(
      onResult: (val) {
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
      localeId: widget.translationProvider.languageCodes[widget.translationProvider.sourceLanguage],
    );
  }

  void _startListening() async {
    if (!_speech.isAvailable) {
      return;
    }

    // _lastWords = "";
    if (!_isListening) {
      _lastWords = messageController.text; // ✅ keep existing text
    }

    setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
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
        localeId: widget.translationProvider.languageCodes[widget.translationProvider.sourceLanguage],
      );
    // }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (_isListening) {
      _stopListening();
    }

    widget.translationProvider.setInputText(text);
    widget.translationProvider.translate();

    messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 550,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 550,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xFF1E1E1E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
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
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textInputAction:
                          TextInputAction.send,
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              _sendMessage();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // send button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF8E44AD),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
                        child: IconButton(
                          icon: Text("Send", style: TextStyle(color: Colors.white)),
                          onPressed: _sendMessage,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // mic button
                      // if(kIsWeb)
                        IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_isListening) {
                              _stopListening();
                            } else {
                              _startListening();
                            }
                          },
                        ),
                    ],
                  ),
                  Container(color: Colors.transparent, height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    messageController.dispose();
    super.dispose();
  }
}
