import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service_stub.dart'
    if (dart.library.io)
    'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service_io.dart'
    as impl;

class LlmInferenceService implements ILlmInferenceService {
  LlmInferenceService({required ILlmModelDownloader downloader})
    : _delegate = impl.LlmInferenceServiceImpl(downloader: downloader);

  final impl.LlmInferenceServiceImpl _delegate;

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  }) {
    return _delegate.chatStream(history: history, message: message);
  }

  @override
  Future<void> dispose() => _delegate.dispose();
}
