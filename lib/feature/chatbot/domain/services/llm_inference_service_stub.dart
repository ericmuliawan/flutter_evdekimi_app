import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service.dart';

class LlmInferenceServiceImpl implements ILlmInferenceService {
  LlmInferenceServiceImpl({required dynamic downloader});

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  }) {
    throw UnsupportedError('On-device AI is not supported on this platform');
  }

  @override
  Future<void> dispose() async {}
}
