import 'package:firebase_database/firebase_database.dart';

class PresetRemoteDataSource {
  final DatabaseReference _dbRef;

  PresetRemoteDataSource()
      : _dbRef = FirebaseDatabase.instanceFor(
          app: FirebaseDatabase.instance.app,
          databaseURL: 'https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref();

  Future<Map<String, dynamic>?> fetchPresets() async {
    final snapshot = await _dbRef.child('presets').get();
    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  Future<int?> fetchVersion() async {
    final snapshot = await _dbRef.child('version').get();
    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }
    return snapshot.value as int;
  }
}
