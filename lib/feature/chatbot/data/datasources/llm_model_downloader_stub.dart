import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';

class LlmModelDownloaderImpl implements ILlmModelDownloader {
  @override
  Future<String> get modelFilePath async => '';

  @override
  Future<bool> isModelDownloaded() async => false;

  @override
  Future<void> download({
    void Function(int received, int total)? onProgress,
  }) {
    throw UnsupportedError('On-device AI is not supported on this platform');
  }
}
