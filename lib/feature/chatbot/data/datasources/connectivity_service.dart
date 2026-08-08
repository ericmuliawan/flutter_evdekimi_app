import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOffline() async {
    final results = await _connectivity.checkConnectivity();
    return results.every((result) => result == ConnectivityResult.none);
  }
}
