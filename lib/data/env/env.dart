import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  Env._();

  @EnviedField(varName: 'API_ACCESS_KEY', obfuscate: true)
  static final String apiAccessKey = _Env.apiAccessKey;

  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'BASE_URL_PRODUCTION', obfuscate: true)
  static final String baseUrlProduction = _Env.baseUrlProduction;

  @EnviedField(varName: 'REVERB_API_KEY', defaultValue: '', obfuscate: true)
  static final String reverbApiKey = _Env.reverbApiKey;

  @EnviedField(varName: 'REVERB_HOST', defaultValue: '', obfuscate: true)
  static final String reverbHost = _Env.reverbHost;

  @EnviedField(varName: 'REVERB_PORT', defaultValue: 443, obfuscate: true)
  static final int reverbPort = _Env.reverbPort;

  @EnviedField(varName: 'REVERB_USE_TLS', defaultValue: true, obfuscate: true)
  static final bool reverbUseTLS = _Env.reverbUseTLS;

  @EnviedField(varName: 'REVERB_AUTH_ENDPOINT', defaultValue: '', obfuscate: true)
  static final String reverbAuthEndpoint = _Env.reverbAuthEndpoint;

  @EnviedField(varName: 'GEMINI_API_KEY', obfuscate: true)
  static final String geminiApiKey = _Env.geminiApiKey;

  @EnviedField(varName: 'GEMINI_MODEL', obfuscate: true)
  static final String geminiModel = _Env.geminiModel;

  // LLM on-device model (Qwen2.5 0.5B Instruct Q4_K_M, ~491 MB)
  @EnviedField(varName: 'LLM_MODEL_URL', obfuscate: true)
  static final String llmModelUrl = _Env.llmModelUrl;

  @EnviedField(varName: 'LLM_MODEL_FILE_NAME', obfuscate: true)
  static final String llmModelFileName = _Env.llmModelFileName;

  @EnviedField(varName: 'LLM_MODEL_SIZE_BYTES', obfuscate: true)
  static final int llmModelSizeBytes = _Env.llmModelSizeBytes;

  @EnviedField(varName: 'LLM_MODEL_MIN_BYTES', obfuscate: true)
  static final int llmModelMinBytes = _Env.llmModelMinBytes;
}
