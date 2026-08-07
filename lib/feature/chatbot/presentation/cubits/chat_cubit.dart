import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/repositories/chat_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/presentation/cubits/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required IChatRepository repository})
    : _repository = repository,
      super(const ChatState());

  final IChatRepository _repository;

  void sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isGenerating) return;

    final history = List<ChatMessage>.of(state.messages);
    final userMessage = ChatMessage(role: ChatRole.user, text: trimmed);
    final assistantMessage = ChatMessage(role: ChatRole.assistant, text: '');

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage, assistantMessage],
        isGenerating: true,
        clearErrorMessage: true,
      ),
    );

    _streamReply(history: history, message: trimmed);
  }

  Future<void> _streamReply({
    required List<ChatMessage> history,
    required String message,
  }) async {
    final buffer = StringBuffer();
    var chunkCount = 0;
    try {
      await for (final chunk in _repository.chatStream(
        history: history,
        message: message,
      )) {
        chunkCount++;
        buffer.write(chunk);
        _updateAssistantMessage(buffer.toString());
      }
      debugPrint('[ChatCubit] streamed $chunkCount chunk(s)');
      _finishGenerating();
    } on GenerativeAIException catch (error) {
      debugPrint('[ChatCubit] Gemini error: $error');
      _failReply(error.message);
    } catch (error) {
      debugPrint('[ChatCubit] Unexpected error: $error');
      _failReply(error.toString());
    }
  }

  void _failReply(String detail) {
    if (isClosed) return;
    _updateAssistantMessage(
      'Sorry, something went wrong. Please try again.',
      isGenerating: false,
    );
    final firstLine = detail.split('\n').first.trim();
    emit(state.copyWith(errorMessage: firstLine));
  }

  void _updateAssistantMessage(String text, {bool isGenerating = true}) {
    if (isClosed) return;
    final messages = List<ChatMessage>.of(state.messages);
    final last = messages.isNotEmpty ? messages.last : null;
    if (last != null && !last.isUser) {
      messages[messages.length - 1] = last.copyWith(text: text);
      emit(
        state.copyWith(messages: messages, isGenerating: isGenerating),
      );
    }
  }

  void _finishGenerating() {
    if (isClosed) return;
    emit(state.copyWith(isGenerating: false));
  }

  void clearChat() {
    if (state.isGenerating) return;
    emit(const ChatState());
  }
}
