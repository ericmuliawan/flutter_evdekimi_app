import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_evdekimi_app/data/env/env.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';

class LlmModelDownloaderImpl implements ILlmModelDownloader {
  LlmModelDownloaderImpl({Dio? dio}) : _dio = dio ?? _defaultDio();

  final Dio _dio;

  static Dio _defaultDio() {
    return Dio(
      BaseOptions(
        responseType: ResponseType.bytes,
        followRedirects: true,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 5),
      ),
    );
  }

  @override
  Future<String> get modelFilePath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/${Env.llmModelFileName}';
  }

  @override
  Future<bool> isModelDownloaded() async {
    final file = File(await modelFilePath);
    if (!file.existsSync()) return false;
    return file.lengthSync() >= Env.llmModelMinBytes;
  }

  @override
  Future<void> download({
    void Function(int received, int total)? onProgress,
  }) async {
    final file = File(await modelFilePath);
    file.parent.createSync(recursive: true);

    final tempFile = File('${file.path}.part');
    if (tempFile.existsSync()) tempFile.deleteSync();

    await _dio.download(
      Env.llmModelUrl,
      tempFile.path,
      onReceiveProgress: (received, total) => onProgress?.call(
        received,
        total < received ? received : total,
      ),
    );

    if (tempFile.existsSync()) tempFile.renameSync(file.path);
  }
}
