import 'package:subby/domain/repository/onboarding_repository.dart';

class CompleteTutorialUseCase {
  final OnboardingRepository _onboardingRepository;

  CompleteTutorialUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<void> call() {
    return _onboardingRepository.completeTutorial();
  }
}
