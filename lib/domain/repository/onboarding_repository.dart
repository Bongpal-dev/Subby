abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();

  Future<bool> isTutorialCompleted();
  Future<void> completeTutorial();

  Future<bool> isSetupCompleted();
  Future<void> completeSetup();
}
