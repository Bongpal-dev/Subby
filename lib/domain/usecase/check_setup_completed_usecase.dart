import 'package:subby/domain/repository/onboarding_repository.dart';

class CheckSetupCompletedUseCase {
  final OnboardingRepository _onboardingRepository;

  CheckSetupCompletedUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<bool> call() {
    return _onboardingRepository.isSetupCompleted();
  }
}
