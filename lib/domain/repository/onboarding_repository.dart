enum OnboardingType { newUser, returningUser }

abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();

  Future<OnboardingType?> getOnboardingType();
  Future<void> setOnboardingType(OnboardingType type);

  Future<bool> isTutorialCompleted();
  Future<void> completeTutorial();

  Future<bool> isSetupCompleted();
  Future<void> completeSetup();
}
