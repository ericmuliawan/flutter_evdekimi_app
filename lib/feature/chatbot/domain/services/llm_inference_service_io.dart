import 'dart:convert';

import 'package:llama_cpp_dart/llama_cpp_dart.dart' as llama;

import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/models/chat_message.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service.dart';

class LlmInferenceServiceImpl implements ILlmInferenceService {
  LlmInferenceServiceImpl({required ILlmModelDownloader downloader})
    : _downloader = downloader;

  final ILlmModelDownloader _downloader;

  llama.LlamaEngine? _engine;
  llama.EngineChat? _chat;

  static const String _systemPrompt =
      'You are "EVDEKimi AI", a friendly smart home assistant. '
      'Answer concisely and helpfully.';

  Future<void> _ensureLoaded() async {
    if (_engine != null) return;

    final path = await _downloader.modelFilePath;
    _engine = await llama.LlamaEngine.spawnFromProcess(
      modelParams: llama.ModelParams(path: path, gpuLayers: 0),
      contextParams: const llama.ContextParams(
        nCtx: 1024,
        nBatch: 256,
        nUbatch: 256,
      ),
    );
    _chat = await _engine!.createChat();
  }

  @override
  Stream<String> chatStream({
    required List<ChatMessage> history,
    required String message,
  }) async* {
    await _ensureLoaded();

    final chat = _chat!;
    chat.clearHistory();
    chat.addSystem(_systemPrompt);
    for (final item in history) {
      if (item.isUser) {
        chat.addUser(item.text);
      } else {
        chat.addAssistant(item.text);
      }
    }
    chat.addUser(message);

    final bytes = <int>[];
    await for (final event in chat.generate(
      sampler: const llama.SamplerParams(
        temperature: 0.7,
        topK: 40,
        topP: 0.9,
        repeatPenalty: 1.1,
      ),
      maxTokens: 256,
    )) {
      if (event is llama.TokenEvent) {
        bytes.addAll(event.bytes);
        try {
          final decoded = utf8.decode(bytes, allowMalformed: false);
          bytes.clear();
          yield decoded;
        } on FormatException {
          // Incomplete multibyte character; wait for more bytes.
        }
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _chat?.dispose();
    await _engine?.dispose();
    _chat = null;
    _engine = null;
  }
}
