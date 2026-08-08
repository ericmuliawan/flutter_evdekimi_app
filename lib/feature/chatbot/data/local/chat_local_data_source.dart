import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

abstract class IChatLocalDataSource {
  Future<List<ChatMessage>> getMessages(String username);
  Future<ChatMessage> insertMessage(ChatMessage message, String username);
  Future<void> updateMessageText(int id, String text);
  Future<void> clearMessages(String username);
}
