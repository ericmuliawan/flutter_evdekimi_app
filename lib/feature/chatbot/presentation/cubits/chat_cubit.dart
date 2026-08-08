import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:flutter_evdekimi_app/common/local_storage_provider.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/repositories/chat_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/presentation/cubits/chat_state.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required IChatRepository repository,
    required ILocalStorageProvider localStorageProvider,
  }) : _repository = repository,
       _localStorageProvider = localStorageProvider,
       super(const ChatState());

  final IChatRepository _repository;
  final ILocalStorageProvider _localStorageProvider;

  String? _pendingMessage;
  Uint8List? _pendingImageBytes;
  String? _pendingImageMimeType;

  String get _currentUsername {
    final stored = _localStorageProvider.getUserEmail().trim();
    if (stored.isNotEmpty) return stored;
    return state.username ?? 'You';
  }

  @override
  Future<void> close() async {
    await _repository.disposeLlm();
    await super.close();
  }

  Future<void> loadHistory() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    try {
      final username = _currentUsername;
      final messages = await _repository.loadMessages(username);
      final offline = await _repository.isOffline();
      emit(
        state.copyWith(
          username: username,
          messages: messages,
          isLoading: false,
          isOffline: offline,
        ),
      );
    } catch (error) {
      debugPrint('[ChatCubit] Failed to load history: $error');
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> refreshConnectivity() async {
    final offline = await _repository.isOffline();
    if (isClosed) return;
    emit(state.copyWith(isOffline: offline));
  }

  void sendMessage(
    String text, {
    Uint8List? imageBytes,
    String? imageMimeType,
  }) {
    final trimmed = text.trim();
    final hasContent = trimmed.isNotEmpty || (imageBytes != null);
    if (!hasContent ||
        state.isGenerating ||
        state.isLoading ||
        state.isDownloading) {
      return;
    }
    unawaited(
      _prepareAndRoute(
        trimmed,
        imageBytes: imageBytes,
        imageMimeType: imageMimeType,
      ),
    );
  }

  Future<void> _prepareAndRoute(
    String trimmed, {
    Uint8List? imageBytes,
    String? imageMimeType,
  }) async {
    final history = List<ChatMessage>.of(state.messages);
    final offline = await _repository.isOffline();
    if (isClosed) return;
    emit(state.copyWith(isOffline: offline));

    final userMessage = ChatMessage(
      role: ChatRole.user,
      text: trimmed,
      imageBytes: imageBytes,
      imageMimeType: imageMimeType,
    );
    final assistantMessage = ChatMessage(role: ChatRole.assistant, text: '');

    if (offline) {
      final downloaded = await _repository.isModelDownloaded();
      if (isClosed) return;
      if (!downloaded) {
        _pendingMessage = trimmed;
        _pendingImageBytes = imageBytes;
        _pendingImageMimeType = imageMimeType;
        emit(state.copyWith(offlineModelMissing: true));
        return;
      }
    }

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage, assistantMessage],
        isGenerating: true,
        clearErrorMessage: true,
      ),
    );

    _persistAndStream(
      history: history,
      message: trimmed,
      imageBytes: imageBytes,
      imageMimeType: imageMimeType,
      username: _currentUsername,
      userMessage: userMessage,
      assistantMessage: assistantMessage,
      local: offline,
    );
  }

  Future<void> _persistAndStream({
    required List<ChatMessage> history,
    required String message,
    Uint8List? imageBytes,
    String? imageMimeType,
    required String username,
    required ChatMessage userMessage,
    required ChatMessage assistantMessage,
    required bool local,
  }) async {
    int? assistantId;
    try {
      await _repository.saveMessage(userMessage, username);
      final savedAssistant = await _repository.saveMessage(
        assistantMessage,
        username,
      );
      assistantId = savedAssistant.id;
    } catch (error) {
      debugPrint('[ChatCubit] Failed to persist messages: $error');
    }

    final stream = local
        ? _repository.localChatStream(history: history, message: message)
        : _repository.chatStream(
            history: history,
            message: message,
            imageBytes: imageBytes,
            imageMimeType: imageMimeType,
          );

    final buffer = StringBuffer();
    var chunkCount = 0;
    try {
      await for (final chunk in stream) {
        chunkCount++;
        buffer.write(chunk);
        _updateAssistantMessage(buffer.toString());
        if (assistantId != null) {
          unawaited(
            _repository.updateMessageText(assistantId, buffer.toString()),
          );
        }
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

  Future<void> downloadOfflineModel() async {
    if (state.isDownloading) return;

    emit(
      state.copyWith(
        isDownloading: true,
        downloadProgress: 0,
        offlineModelMissing: false,
      ),
    );

    final result = await _repository.downloadModel(
      onProgress: (received, total) {
        if (isClosed) return;
        final progress = total <= 0 ? 0.0 : (received / total).clamp(0.0, 1.0);
        emit(state.copyWith(downloadProgress: progress));
      },
    );

    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(state.copyWith(isDownloading: false, downloadProgress: 1));
        final pending = _pendingMessage;
        final pendingImage = _pendingImageBytes;
        final pendingMime = _pendingImageMimeType;
        _pendingMessage = null;
        _pendingImageBytes = null;
        _pendingImageMimeType = null;
        if ((pending != null && pending.trim().isNotEmpty) ||
            pendingImage != null) {
          sendMessage(
            pending ?? '',
            imageBytes: pendingImage,
            imageMimeType: pendingMime,
          );
        }
      case Error<void>(:final error):
        emit(
          state.copyWith(
            isDownloading: false,
            errorMessage: error.message ?? 'Failed to download the AI model',
          ),
        );
    }
  }

  void dismissOfflinePrompt() {
    _pendingMessage = null;
    _pendingImageBytes = null;
    _pendingImageMimeType = null;
    emit(state.copyWith(offlineModelMissing: false));
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
    unawaited(_repository.clearMessages(_currentUsername));
    emit(const ChatState());
  }
}
