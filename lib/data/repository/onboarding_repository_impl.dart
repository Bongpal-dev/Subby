import 'package:subby/data/datasource/onboarding_local_datasource.dart';
import 'package:subby/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  OnboardingRepositoryImpl(this._localDataSource);

  @override
  Future<bool> isOnboardingCompleted() {
    return _localDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> completeOnboarding() {
    return _localDataSource.setOnboardingCompleted(true);
  }

  @override
  Future<OnboardingType?> getOnboardingType() async {
    final value = await _localDataSource.getOnboardingType();
    if (value == null) return null;
    return value == 'new' ? OnboardingType.newUser : OnboardingType.returningUser;
  }

  @override
  Future<void> setOnboardingType(OnboardingType type) {
    final value = type == OnboardingType.newUser ? 'new' : 'returning';
    return _localDataSource.setOnboardingType(value);
  }

  @override
  Future<bool> isTutorialCompleted() {
    return _localDataSource.isTutorialCompleted();
  }

  @override
  Future<void> completeTutorial() {
    return _localDataSource.setTutorialCompleted(true);
  }

  @override
  Future<bool> isSetupCompleted() {
    return _localDataSource.isSetupCompleted();
  }

  @override
  Future<void> completeSetup() {
    return _localDataSource.setSetupCompleted(true);
  }
}
