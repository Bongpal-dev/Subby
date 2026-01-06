import 'package:bongpal/domain/model/subscription_preset.dart';
import 'package:bongpal/domain/repository/preset_repository.dart';

class GetPresetsUseCase {
  final PresetRepository _repository;

  GetPresetsUseCase(this._repository);

  Future<List<SubscriptionPreset>> call({bool forceRefresh = false}) =>
      _repository.getPresets(forceRefresh: forceRefresh);
}
