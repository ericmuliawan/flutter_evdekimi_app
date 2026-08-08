import 'package:equatable/equatable.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.username,
    this.isLoading = false,
    this.isGenerating = false,
    this.isOffline = false,
    this.offlineModelMissing = false,
    this.isDownloading = false,
    this.downloadProgress = 0,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final String? username;
  final bool isLoading;
  final bool isGenerating;
  final bool isOffline;
  final bool offlineModelMissing;
  final bool isDownloading;
  final double downloadProgress;
  final String? errorMessage;

  ChatMessage? get lastAssistantMessage {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (!messages[i].isUser) return messages[i];
    }
    return null;
  }

  ChatState copyWith({
    List<ChatMessage>? messages,
    String? username,
    bool? isLoading,
    bool? isGenerating,
    bool? isOffline,
    bool? offlineModelMissing,
    bool? isDownloading,
    double? downloadProgress,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      isOffline: isOffline ?? this.isOffline,
      offlineModelMissing: offlineModelMissing ?? this.offlineModelMissing,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    messages,
    username,
    isLoading,
    isGenerating,
    isOffline,
    offlineModelMissing,
    isDownloading,
    downloadProgress,
    errorMessage,
  ];
}
