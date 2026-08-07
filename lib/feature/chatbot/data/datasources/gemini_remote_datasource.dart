import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

abstract class IChatRemoteDataSource {
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  });
}

class GeminiRemoteDataSource implements IChatRemoteDataSource {
  GeminiRemoteDataSource({required String apiKey, required String model}) {
    _model = GenerativeModel(model: model, apiKey: apiKey);
  }

  late final GenerativeModel _model;

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  }) async* {
    final contents = [
      for (final item in history)
        Content(item.isUser ? 'user' : 'model', [TextPart(item.text)]),
      Content.text(message),
    ];

    final stream = _model.generateContentStream(contents);
    await for (final response in stream) {
      final text = response.text;
      if (text != null && text.isNotEmpty) {
        yield text;
      }
    }
  }
}
