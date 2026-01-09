class FirebaseSyncException implements Exception {
  final dynamic originalError;

  FirebaseSyncException([this.originalError]);

  @override
  String toString() => 'FirebaseSyncException: $originalError';
}
