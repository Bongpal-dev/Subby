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
    if (rows.isEmpty) {
      print('[PresetRepo] Cache empty, using static presets');
      return subscriptionPresets;
    }
    return rows.map(_rowToPreset).toList();
  }

  @override
  Future<List<SubscriptionPreset>> fetchAndCachePresets() async {
    try {
      print('[PresetRepo] Fetching from Firebase...');
      final data = await _remoteDataSource.fetchPresets();
      final remoteVersion = await _remoteDataSource.fetchVersion();
      print('[PresetRepo] Firebase data: ${data?.length ?? 'null'}, version: $remoteVersion');
      if (data == null) {
        print('[PresetRepo] Firebase returned null, using cache');
        return getPresetsFromCache();
      }

      final companions = <PresetCacheCompanion>[];
      for (final e in data.entries) {
        try {
          if (e.value is! Map) {
            print('[PresetRepo] Skipping ${e.key}: value is ${e.value.runtimeType}');
            continue;
          }
          companions.add(PresetLocalDataSource.mapToCompanion(
              Map<String, dynamic>.from(e.value as Map)));
        } catch (err) {
          print('[PresetRepo] Error parsing ${e.key}: $err');
        }
      }

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
      return getPresetsFromCache();
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

    List<PlanOption> plans = [];
    if (row.plans != null && row.plans!.isNotEmpty) {
      try {
        final plansList = jsonDecode(row.plans!) as List;
        plans = plansList
            .map((p) => PlanOption.fromJson(Map<String, dynamic>.from(p)))
            .toList();
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
      plans: plans,
    );
  }

  SubscriptionPreset _jsonToPreset(Map<String, dynamic> json) {
    List<String> aliases = [];
    if (json['aliases'] != null) {
      aliases = List<String>.from(json['aliases']);
    }

    List<PlanOption> plans = [];
    if (json['plans'] != null && json['plans'] is List) {
      plans = (json['plans'] as List)
          .map((p) => PlanOption.fromJson(Map<String, dynamic>.from(p)))
          .toList();
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
      plans: plans,
    );
  }
}
