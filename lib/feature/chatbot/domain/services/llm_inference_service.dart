import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

abstract class ILlmInferenceService {
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  });
  Future<void> dispose();
}
