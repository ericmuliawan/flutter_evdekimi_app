import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  Env._();

  @EnviedField(varName: 'API_ACCESS_KEY')
  static const String apiAccessKey = _Env.apiAccessKey;

  @EnviedField(varName: 'BASE_URL')
  static const String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'BASE_URL_PRODUCTION')
  static const String baseUrlProduction = _Env.baseUrlProduction;

  @EnviedField(varName: 'REVERB_API_KEY', defaultValue: '')
  static const String reverbApiKey = _Env.reverbApiKey;

  @EnviedField(varName: 'REVERB_HOST', defaultValue: '')
  static const String reverbHost = _Env.reverbHost;

  @EnviedField(varName: 'REVERB_PORT', defaultValue: 443)
  static const int reverbPort = _Env.reverbPort;

  @EnviedField(varName: 'REVERB_USE_TLS', defaultValue: true)
  static const bool reverbUseTLS = _Env.reverbUseTLS;

  @EnviedField(varName: 'REVERB_AUTH_ENDPOINT', defaultValue: '')
  static const String reverbAuthEndpoint = _Env.reverbAuthEndpoint;

  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'GEMINI_MODEL')
  static const String geminiModel = _Env.geminiModel;

  // LLM on-device model (Qwen2.5 0.5B Instruct Q4_K_M, ~491 MB)
  @EnviedField(varName: 'LLM_MODEL_URL')
  static const String llmModelUrl = _Env.llmModelUrl;

  @EnviedField(varName: 'LLM_MODEL_FILE_NAME')
  static const String llmModelFileName = _Env.llmModelFileName;

  @EnviedField(varName: 'LLM_MODEL_SIZE_BYTES')
  static const int llmModelSizeBytes = _Env.llmModelSizeBytes;

  @EnviedField(varName: 'LLM_MODEL_MIN_BYTES')
  static const int llmModelMinBytes = _Env.llmModelMinBytes;
}
