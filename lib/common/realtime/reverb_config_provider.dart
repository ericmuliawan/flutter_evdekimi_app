import 'package:flutter_evdekimi_app/common/local_storage_provider.dart';
import 'package:flutter_evdekimi_app/data/env/env.dart';

class ReverbConnectionConfig {
  const ReverbConnectionConfig({
    required this.apiKey,
    required this.host,
    required this.port,
    required this.useTLS,
    required this.authEndpoint,
  });

  final String apiKey;
  final String host;
  final int port;
  final bool useTLS;
  final String authEndpoint;
}

abstract class IReverbConfigProvider {
  ReverbConnectionConfig get connection;
  Map<String, String> buildAuthHeaders();
}

class ReverbConfigProvider implements IReverbConfigProvider {
  ReverbConfigProvider({required ILocalStorageProvider localStorageProvider})
    : _localStorageProvider = localStorageProvider;

  final ILocalStorageProvider _localStorageProvider;

  static final _connection = ReverbConnectionConfig(
    apiKey: Env.reverbApiKey,
    host: Env.reverbHost,
    port: Env.reverbPort,
    useTLS: Env.reverbUseTLS,
    authEndpoint: Env.reverbAuthEndpoint,
  );

  @override
  ReverbConnectionConfig get connection => _connection;

  @override
  Map<String, String> buildAuthHeaders() {
    final token = _localStorageProvider.getAuthToken();

    return {
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }
}
