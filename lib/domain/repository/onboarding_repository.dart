abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();

  Future<bool> isTutorialCompleted();
  Future<void> completeTutorial();

  Future<bool> isSetupCompleted();
  Future<void> completeSetup();
  Future<void> resetSetup();

  Future<bool> isNicknameOnly();
  Future<void> setNicknameOnly(bool value);
}
