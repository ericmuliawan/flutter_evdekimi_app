import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_evdekimi_app/common/local_storage_provider.dart';
import 'package:flutter_evdekimi_app/common/network/api_header_interceptor.dart';
import 'package:flutter_evdekimi_app/common/network/api_logger_interceptor.dart';
import 'package:flutter_evdekimi_app/common/network/base_provider.dart';
import 'package:flutter_evdekimi_app/common/realtime/reverb_config_provider.dart';
import 'package:flutter_evdekimi_app/common/realtime/reverb_service.dart';
import 'package:flutter_evdekimi_app/data/env/env.dart';
import 'package:flutter_evdekimi_app/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_evdekimi_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/connectivity_service.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/gemini_remote_datasource.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/datasources/llm_model_downloader_factory.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/data/local/chat_local_data_source_factory.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/repositories/chat_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/llm_inference_service_factory.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/speech_to_text_service.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerSingleton<ILocalStorageProvider>(
    LocalStorageProvider(prefs: prefs),
  );

  getIt.registerSingleton<ApiHeaderInterceptor>(
    ApiHeaderInterceptor(
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerSingleton<ApiLoggerInterceptor>(ApiLoggerInterceptor());

  getIt.registerSingleton<BaseProvider>(
    BaseProvider(
      apiHeaderInterceptor: getIt<ApiHeaderInterceptor>(),
      apiLoggerInterceptor: getIt<ApiLoggerInterceptor>(),
    ),
  );

  getIt.registerSingleton<IReverbConfigProvider>(
    ReverbConfigProvider(
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerSingleton<IReverbService>(ReverbService());

  getIt.registerSingleton<IAuthRepository>(
    AuthRepository(
      remoteDataSource: AuthRemoteDataSource(dio: getIt<BaseProvider>().dio),
      localStorageProvider: getIt<ILocalStorageProvider>(),
    ),
  );

  getIt.registerSingleton<LlmModelDownloader>(LlmModelDownloader());

  getIt.registerSingleton<SpeechToTextService>(SpeechToTextService());

  getIt.registerSingleton<IChatRepository>(
    ChatRepository(
      remoteDataSource: GeminiRemoteDataSource(
        apiKey: Env.geminiApiKey,
        model: Env.geminiModel,
      ),
      localDataSource: ChatLocalDataSource(),
      llmDownloader: getIt<LlmModelDownloader>(),
      llmInferenceService: LlmInferenceService(
        downloader: getIt<LlmModelDownloader>(),
      ),
      connectivityService: ConnectivityService(),
    ),
  );
}
