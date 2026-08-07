import 'package:equatable/equatable.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.isGenerating = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isGenerating;
  final String? errorMessage;

  ChatMessage? get lastAssistantMessage {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (!messages[i].isUser) return messages[i];
    }
    return null;
  }

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [messages, isGenerating, errorMessage];
}
