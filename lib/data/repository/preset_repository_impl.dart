import 'dart:convert';
import 'package:subby/data/datasource/preset_local_datasource.dart';
import 'package:subby/data/datasource/preset_remote_datasource.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/preset/subscription_presets.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/domain/repository/preset_repository.dart';

class PresetRepositoryImpl implements PresetRepository {
  final PresetRemoteDataSource _remoteDataSource;
  final PresetLocalDataSource _localDataSource;

  PresetRepositoryImpl({
    required PresetRemoteDataSource remoteDataSource,
    required PresetLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<SubscriptionPreset>> getPresetsFromCache() async {
    final rows = await _localDataSource.getAll();
    print('[PresetRepo] Cache count: ${rows.length}');
    return rows.map(_rowToPreset).toList();
  }

  @override
  Future<List<SubscriptionPreset>> fetchAndCachePresets() async {
    try {
      print('[PresetRepo] Fetching from Firebase...');
      final data = await _remoteDataSource.fetchPresets();
      final remoteVersion = await _remoteDataSource.fetchVersion();
      print('[PresetRepo] Firebase data: ${data?.length ?? 'null'}, version: $remoteVersion');
      if (data == null || data.isEmpty) {
        print('[PresetRepo] Firebase returned null/empty, using cache or static');
        final cached = await getPresetsFromCache();
        if (cached.isNotEmpty) {
          return cached;
        }
        return subscriptionPresets;
      }

      final companions = data.entries
          .map((e) => PresetLocalDataSource.mapToCompanion(
              Map<String, dynamic>.from(e.value as Map)))
          .toList();

      await _localDataSource.cachePresets(companions);
      if (remoteVersion != null) {
        await _localDataSource.saveLocalVersion(remoteVersion);
        print('[PresetRepo] Saved version: $remoteVersion');
      }
      print('[PresetRepo] Cached ${companions.length} presets');

      return data.entries
          .map((e) => _jsonToPreset(Map<String, dynamic>.from(e.value as Map)))
          .toList();
    } catch (e) {
      print('[PresetRepo] Error fetching: $e');
      final cached = await getPresetsFromCache();
      if (cached.isNotEmpty) {
        return cached;
      }
      // Firebase 실패 + 캐시 없음 → 정적 프리셋 사용
      print('[PresetRepo] Using static presets as fallback');
      return subscriptionPresets;
    }
  }

  @override
  Future<List<SubscriptionPreset>> getPresets({bool forceRefresh = false}) async {
    if (forceRefresh) {
      return fetchAndCachePresets();
    }

    final cached = await getPresetsFromCache();
    if (cached.isNotEmpty) {
      // 버전 체크 후 필요시에만 업데이트
      _checkAndUpdateIfNeeded();
      return cached;
    }

    return fetchAndCachePresets();
  }

  Future<void> _checkAndUpdateIfNeeded() async {
    try {
      final localVersion = await _localDataSource.getLocalVersion();
      final remoteVersion = await _remoteDataSource.fetchVersion();

      print('[PresetRepo] Version check - local: $localVersion, remote: $remoteVersion');

      if (remoteVersion != null && remoteVersion != localVersion) {
        print('[PresetRepo] Version changed, updating...');
        await fetchAndCachePresets();
      } else {
        print('[PresetRepo] Version unchanged, using cache');
      }
    } catch (e) {
      print('[PresetRepo] Version check failed: $e');
    }
  }

  SubscriptionPreset _rowToPreset(PresetCacheData row) {
    List<String> aliases = [];
    if (row.aliases != null && row.aliases!.isNotEmpty) {
      try {
        aliases = List<String>.from(jsonDecode(row.aliases!));
      } catch (_) {}
    }

    return SubscriptionPreset(
      brandKey: row.brandKey,
      displayNameKo: row.displayNameKo,
      displayNameEn: row.displayNameEn,
      category: PresetCategory.values.firstWhere(
        (e) => e.name == row.category,
        orElse: () => PresetCategory.VIDEO,
      ),
      defaultCurrency: row.defaultCurrency,
      defaultPeriod: row.defaultPeriod,
      aliases: aliases,
      notes: row.notes,
    );
  }

  SubscriptionPreset _jsonToPreset(Map<String, dynamic> json) {
    List<String> aliases = [];
    if (json['aliases'] != null) {
      aliases = List<String>.from(json['aliases']);
    }

    return SubscriptionPreset(
      brandKey: json['brandKey'] ?? '',
      displayNameKo: json['displayNameKo'] ?? '',
      displayNameEn: json['displayNameEn'],
      category: PresetCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => PresetCategory.VIDEO,
      ),
      defaultCurrency: json['defaultCurrency'] ?? 'KRW',
      defaultPeriod: json['defaultPeriod'] ?? 'MONTHLY',
      aliases: aliases,
      notes: json['notes'],
    );
  }
}
