import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

class ChatLocalDataSourceImpl implements IChatLocalDataSource {
  final _messagesByUser = <String, List<ChatMessage>>{};
  int _nextId = 1;

  @override
  Future<List<ChatMessage>> getMessages(String username) async {
    return List<ChatMessage>.of(_messagesByUser[username] ?? const []);
  }

  @override
  Future<ChatMessage> insertMessage(ChatMessage message, String username) async {
    final withId = message.copyWith(id: _nextId++);
    _messagesByUser.putIfAbsent(username, () => []).add(withId);
    return withId;
  }

  @override
  Future<void> updateMessageText(int id, String text) async {
    for (final messages in _messagesByUser.values) {
      final index = messages.indexWhere((message) => message.id == id);
      if (index == -1) continue;
      messages[index] = messages[index].copyWith(text: text);
      return;
    }
  }

  @override
  Future<void> clearMessages(String username) async {
    _messagesByUser.remove(username);
  }
}
