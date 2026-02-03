import 'package:subby/domain/repository/onboarding_repository.dart';

class CheckOnboardingCompletedUseCase {
  final OnboardingRepository _onboardingRepository;

  CheckOnboardingCompletedUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<bool> call() {
    return _onboardingRepository.isOnboardingCompleted();
  }
}
