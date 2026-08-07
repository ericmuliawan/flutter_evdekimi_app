import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/gemini_remote_datasource.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

abstract class IChatRepository {
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  });
}

class ChatRepository implements IChatRepository {
  ChatRepository({required IChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final IChatRemoteDataSource _remoteDataSource;

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  }) {
    return _remoteDataSource.chatStream(history: history, message: message);
  }
}
