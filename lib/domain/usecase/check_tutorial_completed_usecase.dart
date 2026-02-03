import 'package:subby/domain/repository/onboarding_repository.dart';

class CheckTutorialCompletedUseCase {
  final OnboardingRepository _onboardingRepository;

  CheckTutorialCompletedUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<bool> call() {
    return _onboardingRepository.isTutorialCompleted();
  }
}
