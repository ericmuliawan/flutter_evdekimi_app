import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speech = SpeechToText();

  String? _lastError;

  bool get isListening => _speech.isListening;
  String? get lastError => _lastError;

  Future<bool> initialize() async {
    if (_speech.isAvailable) return true;
    return _speech.initialize(
      onError: (error) => _lastError = error.errorMsg,
      onStatus: (_) {},
    );
  }

  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> stop() => _speech.stop();

  Future<void> cancel() => _speech.cancel();
}
