import 'package:bongpal/domain/model/subscription_preset.dart';

abstract class PresetRepository {
  Future<List<SubscriptionPreset>> getPresets({bool forceRefresh = false});
  Future<List<SubscriptionPreset>> getPresetsFromCache();
  Future<List<SubscriptionPreset>> fetchAndCachePresets();
}
