import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subby/data/database/database.dart';

class PresetLocalDataSource {
  final AppDatabase _db;
  static const _versionKey = 'preset_version';

  PresetLocalDataSource(this._db);

  Future<int?> getLocalVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_versionKey);
  }

  Future<void> saveLocalVersion(int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_versionKey, version);
  }

  Future<List<PresetCacheData>> getAll() async {
    return _db.select(_db.presetCache).get();
  }

  Future<void> cachePresets(List<PresetCacheCompanion> presets) async {
    await _db.batch((batch) {
      batch.deleteAll(_db.presetCache);
      for (final preset in presets) {
        batch.insert(_db.presetCache, preset);
      }
    });
  }

  Future<void> clear() async {
    await _db.delete(_db.presetCache).go();
  }

  /// JSON Map을 PresetCacheCompanion으로 변환
  static PresetCacheCompanion mapToCompanion(Map<String, dynamic> json) {
    List<String>? aliases;
    if (json['aliases'] != null) {
      aliases = List<String>.from(json['aliases']);
    }

    return PresetCacheCompanion.insert(
      brandKey: json['brandKey'] ?? '',
      displayNameKo: json['displayNameKo'] ?? '',
      displayNameEn: Value(json['displayNameEn']),
      category: json['category'] ?? 'VIDEO',
      defaultCurrency: json['defaultCurrency'] ?? 'KRW',
      defaultPeriod: json['defaultPeriod'] ?? 'MONTHLY',
      aliases: Value(aliases != null ? jsonEncode(aliases) : null),
      notes: Value(json['notes']),
      cachedAt: DateTime.now(),
    );
  }
}
