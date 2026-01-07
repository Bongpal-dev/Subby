import 'dart:convert';
import 'package:subby/data/datasource/preset_local_datasource.dart';
import 'package:subby/data/datasource/preset_remote_datasource.dart';
import 'package:subby/data/database/database.dart';
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
      print('[PresetRepo] Firebase data: ${data?.length ?? 'null'}');
      if (data == null) {
        print('[PresetRepo] Firebase returned null, using cache');
        return getPresetsFromCache();
      }

      final companions = data.entries
          .map((e) => PresetLocalDataSource.mapToCompanion(
              Map<String, dynamic>.from(e.value as Map)))
          .toList();

      await _localDataSource.cachePresets(companions);
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
      // 백그라운드에서 업데이트
      fetchAndCachePresets();
      return cached;
    }

    return fetchAndCachePresets();
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
