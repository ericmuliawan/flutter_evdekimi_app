import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/connectivity_service.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/gemini_remote_datasource.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service.dart';
import 'package:flutter_evdekimi_app/model/common/api_error.dart';
import 'package:flutter_evdekimi_app/model/common/api_result.dart';

abstract class IChatRepository {
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
    Uint8List? imageBytes,
    String? imageMimeType,
  });
  Stream<String> localChatStream({
    required List<ChatMessage> history,
    required String message,
  });
  Future<bool> isOffline();
  Future<bool> isModelDownloaded();
  Future<ApiResult<void>> downloadModel({
    void Function(int received, int total)? onProgress,
  });
  Future<void> disposeLlm();
  Future<List<ChatMessage>> loadMessages(String username);
  Future<ChatMessage> saveMessage(ChatMessage message, String username);
  Future<void> updateMessageText(int id, String text);
  Future<void> clearMessages(String username);
}

class ChatRepository implements IChatRepository {
  ChatRepository({
    required IChatRemoteDataSource remoteDataSource,
    required IChatLocalDataSource localDataSource,
    required ILlmModelDownloader llmDownloader,
    required ILlmInferenceService llmInferenceService,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _llmDownloader = llmDownloader,
       _llmInferenceService = llmInferenceService,
       _connectivityService = connectivityService;

  final IChatRemoteDataSource _remoteDataSource;
  final IChatLocalDataSource _localDataSource;
  final ILlmModelDownloader _llmDownloader;
  final ILlmInferenceService _llmInferenceService;
  final ConnectivityService _connectivityService;

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
    Uint8List? imageBytes,
    String? imageMimeType,
  }) {
    return _remoteDataSource.chatStream(
      history: history,
      message: message,
      imageBytes: imageBytes,
      imageMimeType: imageMimeType,
    );
  }

  @override
  Stream<String> localChatStream({
    required List<ChatMessage> history,
    required String message,
  }) {
    return _llmInferenceService.chatStream(history: history, message: message);
  }

  @override
  Future<bool> isOffline() => _connectivityService.isOffline();

  @override
  Future<bool> isModelDownloaded() => _llmDownloader.isModelDownloaded();

  @override
  Future<ApiResult<void>> downloadModel({
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      await _llmDownloader.download(onProgress: onProgress);
      return const Success<void>(response: null);
    } on DioException catch (error) {
      return ApiResult.error(
        ApiError(message: error.message ?? 'Download failed'),
      );
    } catch (error) {
      return ApiResult.error(ApiError(message: error.toString()));
    }
  }

  @override
  Future<void> disposeLlm() => _llmInferenceService.dispose();

  @override
  Future<List<ChatMessage>> loadMessages(String username) {
    return _localDataSource.getMessages(username);
  }

  @override
  Future<ChatMessage> saveMessage(ChatMessage message, String username) {
    return _localDataSource.insertMessage(message, username);
  }

  @override
  Future<void> updateMessageText(int id, String text) {
    return _localDataSource.updateMessageText(id, text);
  }

  @override
  Future<void> clearMessages(String username) {
    return _localDataSource.clearMessages(username);
  }
}
