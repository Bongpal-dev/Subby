import 'package:subby/domain/repository/onboarding_repository.dart';

class CompleteSetupUseCase {
  final OnboardingRepository _onboardingRepository;

  CompleteSetupUseCase({
    required OnboardingRepository onboardingRepository,
  }) : _onboardingRepository = onboardingRepository;

  Future<void> call() async {
    await _onboardingRepository.completeSetup();
    await _onboardingRepository.setNicknameOnly(false);
  }
}
