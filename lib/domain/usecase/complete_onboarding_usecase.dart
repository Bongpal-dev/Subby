import 'package:subby/domain/repository/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository _onboardingRepository;

  CompleteOnboardingUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<void> call() {
    return _onboardingRepository.completeOnboarding();
  }
}
