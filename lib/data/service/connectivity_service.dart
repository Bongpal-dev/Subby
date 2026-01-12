import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final _onlineController = StreamController<bool>.broadcast();

  bool _wasOffline = false;

  ConnectivityService(this._connectivity);

  Stream<bool> get onOnlineRestored => _onlineController.stream;

  Future<void> startMonitoring() async {
    final results = await _connectivity.checkConnectivity();
    _wasOffline = !_isOnline(results);

    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(_handleChange);
  }

  void _handleChange(List<ConnectivityResult> results) {
    final isOnline = _isOnline(results);

    if (_wasOffline && isOnline) {
      _onlineController.add(true);
    }

    _wasOffline = !isOnline;
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any(
      (r) => r == ConnectivityResult.wifi || r == ConnectivityResult.mobile || r == ConnectivityResult.ethernet,
    );
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopMonitoring();
    _onlineController.close();
  }
}
