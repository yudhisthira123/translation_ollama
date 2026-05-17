import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation/providers/translation_provider.dart';

import '../../constants.dart';

class ChatInputWidget extends StatefulWidget {
  TranslationProvider translationProvider;
  bool isHost = true;

  ChatInputWidget({
    super.key,
    required this.translationProvider,
    required this.isHost,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController messageController = TextEditingController();
  late stt.SpeechToText _speech;

  // bool _isListening = false;
  bool get _isListening =>
      widget.translationProvider.activeMic ==
      (widget.isHost ? ActiveMic.host : ActiveMic.guest);

  String _lastWords = "";
  bool _speechEnabled = false;
  late AnimationController _micAnimationController;
  late Animation<double> _micAnimation;
  bool _hasInternet = true;
  Timer? _internetCheckTimer;

  @override
  void initState() {
    super.initState();
    checkInternet();
    _speech = stt.SpeechToText();
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _micAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );

    _speech
        .initialize(
          onStatus: _onSpeechStatus,
          onError: (error) {
            print("Speech error: $error");

            if (error.errorMsg.contains("network")) {
              showError(context, "⚠️ Internet required for speech");
              _stopListening();
              return;
            }

            // 🔁 Restart only for non-network errors
            if (_isListening) _restartListening();
          },
          // onError: (error) {
          //   // print("Speech error: $error");
          //   if (_isListening) _restartListening();
          // },
        )
        .then((enabled) {
          _speechEnabled = enabled;
        });
  }

  void checkInternet() async {
    _hasInternet = await hasInternet();
    setState(() {});
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
          _lastWords = "$_lastWords ${val.recognizedWords}".trim();
        }

        final fullText = val.finalResult
            ? _lastWords
            : "$_lastWords ${val.recognizedWords}".trim();

        setState(() {
          messageController.text = fullText;
          messageController.selection = TextSelection.collapsed(
            offset: text.length,
          );
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
          ? widget.translationProvider.languageCodes[widget
                .translationProvider
                .hostLanguage]
          : widget.translationProvider.languageCodes[widget
                .translationProvider
                .guestLanguage],
    );
  }

  void _startListening() async {
    widget.translationProvider.setSpeechLanguage(widget.isHost);

    // 🔥 STOP TTS (fix crash)
    await widget.translationProvider.stop();
    await Future.delayed(const Duration(milliseconds: 300));

    // 🔴 INTERNET CHECK
    final internet = await hasInternet();

    if (!internet) {
      showError(context, "⚠️ No internet connection");
      return;
    }

    if (!_speech.isAvailable) {
      showError(context, "⚠️ Speech not available");
      return;
    }
    // if (!_speech.isAvailable) {
    //   return;
    // }

    if (!_isListening) {
      _lastWords = messageController.text; // ✅ keep existing text
    }

    // setState(() => _isListening = true);
    _micAnimationController.repeat(reverse: true);
    _speech.listen(
      onResult: (val) {
        if (!_isListening) return;

        final text = val.recognizedWords;

        /// 🔥 ALWAYS SHOW LIVE TEXT
        widget.translationProvider.updateLiveText(text, isHost: widget.isHost);
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
      pauseFor: const Duration(seconds: 5),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
      ),
      localeId: widget.isHost
          ? widget.translationProvider.languageCodes[widget
                .translationProvider
                .hostLanguage]
          : widget.translationProvider.languageCodes[widget
                .translationProvider
                .guestLanguage],
    );

    /// 🔥🔥 ADD TIMER HERE (IMPORTANT)
    _internetCheckTimer?.cancel(); // avoid duplicates

    _internetCheckTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      if (!_isListening) {
        timer.cancel();
        return;
      }

      final internet = await hasInternet();

      if (!internet) {
        showError(context, "⚠️ Internet lost");
        _forceStopMic();
        timer.cancel();
      }
    });
  }

  void _stopListening() {
    // setState(() => _isListening = false);
    _internetCheckTimer?.cancel();
    _micAnimationController.stop();
    _micAnimationController.reset();
    _speech.stop();
  }

  Future<void> _sendMessage() async {
    widget.translationProvider.setSpeechLanguage(widget.isHost);

    final internet = await hasInternet();

    if (!internet) {
      showError(context, "⚠️ No internet. Cannot translate.");
      return;
    }

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
    return Center(child: _buildMicButton(widget.isHost));
  }

  @override
  void dispose() {
    _internetCheckTimer?.cancel();
    _speech.stop();
    _micAnimationController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _forceStopMic() async {
    final provider = widget.translationProvider;

    await _speech.stop();

    _internetCheckTimer?.cancel(); // 🔥 MUST

    provider.stopMic();
    provider.updateLiveText("", isHost: widget.isHost);

    _micAnimationController.stop();
    _micAnimationController.reset();

    setState(() {});
  }

  Widget _buildSendButton() {
    return Container(
      decoration: BoxDecoration(
        // color: const Color(0xFF8E44AD),
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: !_hasInternet
            ? () => showError(context, "No internet")
            : _sendMessage,
      ),
    );
  }

  Widget _buildMicButton(bool isHost) {
    return AnimatedBuilder(
      animation: _micAnimationController,
      builder: (context, child) {
        return Center(
          child: Column(
            children: [
              if (isHost)
                Transform.rotate(
                  angle: 3.1416,
                  child: Text(
                    // "Gastmikrofon eingeschaltet",
                    "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              if (!isHost) SizedBox(height: 20),
              Row(
                children: [
                  Transform.rotate(
                    angle: isHost ? 3.1416 : 0,
                    child: circleButton(
                      50,
                      50,
                      _isListening
                          ? "assets/images/mic_on.gif"
                          : "assets/images/mic_off.svg",
                      onTap: () async {
                        final internet = await hasInternet();

                        if (!internet) {
                          showError(context, "No internet available");
                          return;
                        }

                        final provider = widget.translationProvider;

                        final requestedMic = widget.isHost
                            ? ActiveMic.host
                            : ActiveMic.guest;

                        final isSameMic = provider.activeMic == requestedMic;

                        await provider.stop();
                        await _speech.stop();

                        await Future.delayed(const Duration(milliseconds: 300));

                        if (isSameMic) {
                          provider.stopMic();
                          _stopListening();
                          await _sendMessage();
                        } else {
                          _resetForNewMic();
                          provider.setActiveMic(requestedMic);
                          _startListening();
                        }
                      },
                      // onTap: !_hasInternet
                      //     ? () => showError(context, "No internet available")
                      //     : () async {
                      //   final provider = widget.translationProvider;
                      //
                      //   final requestedMic =
                      //   widget.isHost ? ActiveMic.host : ActiveMic.guest;
                      //
                      //   final isSameMic = provider.activeMic == requestedMic;
                      //
                      //   await provider.stop();
                      //   await _speech.stop();
                      //
                      //   await Future.delayed(const Duration(milliseconds: 300));
                      //
                      //   if (isSameMic) {
                      //     provider.stopMic();
                      //     _stopListening();
                      //     await _sendMessage();
                      //   } else {
                      //     _resetForNewMic();
                      //     provider.setActiveMic(requestedMic);
                      //     _startListening();
                      //   }
                      // },
                    ),
                  ),
                ],
              ),
              if (isHost) SizedBox(height: 20),
              if (!isHost)
                Text(
                  // "Host Mic Off",
                  "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _resetForNewMic() {
    _lastWords = "";

    messageController.clear();

    widget.translationProvider.setInputText("");
    widget.translationProvider.updateLiveText("", isHost: widget.isHost);
  }
}
