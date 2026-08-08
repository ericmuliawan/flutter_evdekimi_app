import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source_stub.dart'
    if (dart.library.io)
    'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source_io.dart'
    as impl;
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

class ChatLocalDataSource implements IChatLocalDataSource {
  ChatLocalDataSource() : _delegate = impl.ChatLocalDataSourceImpl();

  final impl.ChatLocalDataSourceImpl _delegate;

  @override
  Future<List<ChatMessage>> getMessages(String username) =>
      _delegate.getMessages(username);

  @override
  Future<ChatMessage> insertMessage(ChatMessage message, String username) =>
      _delegate.insertMessage(message, username);

  @override
  Future<void> updateMessageText(int id, String text) =>
      _delegate.updateMessageText(id, text);

  @override
  Future<void> clearMessages(String username) =>
      _delegate.clearMessages(username);
}
