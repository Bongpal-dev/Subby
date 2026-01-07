import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/domain/repository/preset_repository.dart';

class GetPresetsUseCase {
  final PresetRepository _repository;

  GetPresetsUseCase(this._repository);

  Future<List<SubscriptionPreset>> call({bool forceRefresh = false}) =>
      _repository.getPresets(forceRefresh: forceRefresh);
}
