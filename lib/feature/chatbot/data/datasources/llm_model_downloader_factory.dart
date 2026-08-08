import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader_stub.dart'
    if (dart.library.io)
    'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader_io.dart'
    as impl;

class LlmModelDownloader implements ILlmModelDownloader {
  LlmModelDownloader() : _delegate = impl.LlmModelDownloaderImpl();

  final impl.LlmModelDownloaderImpl _delegate;

  @override
  Future<String> get modelFilePath => _delegate.modelFilePath;

  @override
  Future<bool> isModelDownloaded() => _delegate.isModelDownloaded();

  @override
  Future<void> download({
    void Function(int received, int total)? onProgress,
  }) {
    return _delegate.download(onProgress: onProgress);
  }
}
