import 'package:firebase_database/firebase_database.dart';

class PresetRemoteDataSource {
  final DatabaseReference _dbRef;

  PresetRemoteDataSource()
      : _dbRef = FirebaseDatabase.instanceFor(
          app: FirebaseDatabase.instance.app,
          databaseURL: 'https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref();

  // TODO: 마이그레이션 완료 후 presets, version으로 변경
  static const String _presetsPath = 'presets_v2';
  static const String _versionPath = 'version_v2';

  Future<Map<String, dynamic>?> fetchPresets() async {
    final snapshot = await _dbRef.child(_presetsPath).get();
    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  Future<int?> fetchVersion() async {
    final snapshot = await _dbRef.child(_versionPath).get();
    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }
    return snapshot.value as int;
  }
}
