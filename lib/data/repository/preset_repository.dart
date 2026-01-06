import 'dart:convert';
import 'package:bongpal/data/datasource/preset_local_datasource.dart';
import 'package:bongpal/data/datasource/preset_remote_datasource.dart';
import 'package:bongpal/data/database/database.dart';
import 'package:bongpal/domain/model/subscription_preset.dart';
import 'package:bongpal/domain/repository/preset_repository.dart';

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
    return rows.map(_rowToPreset).toList();
  }

  @override
  Future<List<SubscriptionPreset>> fetchAndCachePresets() async {
    try {
      final data = await _remoteDataSource.fetchPresets();
      if (data == null) {
        return getPresetsFromCache();
      }

      final companions = data.entries
          .map((e) => PresetLocalDataSource.mapToCompanion(
              Map<String, dynamic>.from(e.value as Map)))
          .toList();

      await _localDataSource.cachePresets(companions);

      return data.entries
          .map((e) => _jsonToPreset(Map<String, dynamic>.from(e.value as Map)))
          .toList();
    } catch (e) {
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
