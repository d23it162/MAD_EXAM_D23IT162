import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
      );
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    if (_isInitialized) {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
          }
        },
        listenMode: ListenMode.confirmation,
        partialResults: true,
        cancelOnError: false,
        listenFor: const Duration(seconds: 30),
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  bool get isListening => _speechToText.isListening;
} 