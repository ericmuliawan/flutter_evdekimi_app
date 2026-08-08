class Env {
  Env._();

  static const String apiAccessKey = 'free_user_3HHA9ETbGTVpnaIusc7oA7KjZZr';
  static const String baseUrl = 'https://reqres.in';
  static const String baseUrlProduction = 'https://reqres.in';

  static const String reverbApiKey = '';
  static const String reverbHost = '';
  static const int reverbPort = 443;
  static const bool reverbUseTLS = true;
  static const String reverbAuthEndpoint = '';

  static const String geminiModel = 'gemini-3.6-flash';

  static const String geminiApiKey =
      'REPLACE_WITH_YOUR_KEY';

  // LLM on-device model (Qwen2.5 0.5B Instruct Q4_K_M, ~491 MB)
  static const String llmModelUrl =
      'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf';
  static const String llmModelFileName = 'qwen2.5-0.5b-instruct-q4_k_m.gguf';
  static const int llmModelSizeBytes = 491400032;
  static const int llmModelMinBytes = 450000000;
}
