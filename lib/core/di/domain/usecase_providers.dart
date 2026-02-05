import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/domain/usecase/add_subscription_usecase.dart';
import 'package:subby/domain/usecase/create_group_usecase.dart';
import 'package:subby/domain/usecase/delete_subscription_usecase.dart';
import 'package:subby/domain/usecase/get_presets_usecase.dart';
import 'package:subby/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:subby/domain/usecase/join_group_usecase.dart';
import 'package:subby/domain/usecase/leave_group_usecase.dart';
import 'package:subby/domain/usecase/detect_subscription_conflict_usecase.dart';
import 'package:subby/domain/usecase/process_pending_changes_usecase.dart';
import 'package:subby/domain/usecase/save_user_info_usecase.dart';
import 'package:subby/domain/usecase/fetch_user_info_usecase.dart';
import 'package:subby/domain/usecase/check_auth_state_usecase.dart';
import 'package:subby/domain/usecase/sign_in_anonymously_usecase.dart';
import 'package:subby/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:subby/domain/usecase/sign_out_usecase.dart';
import 'package:subby/domain/usecase/sync_remote_groups_usecase.dart';
import 'package:subby/domain/usecase/sync_user_data_after_login_usecase.dart';
import 'package:subby/domain/usecase/update_group_display_name_usecase.dart';
import 'package:subby/domain/usecase/update_subscription_usecase.dart';
import 'package:subby/domain/usecase/watch_groups_usecase.dart';
import 'package:subby/domain/usecase/watch_subscriptions_usecase.dart';
import 'package:subby/domain/usecase/watch_group_by_code_usecase.dart';
import 'package:subby/domain/usecase/watch_auth_state_usecase.dart';
import 'package:subby/domain/usecase/check_onboarding_completed_usecase.dart';
import 'package:subby/domain/usecase/complete_onboarding_usecase.dart';
import 'package:subby/domain/usecase/check_tutorial_completed_usecase.dart';
import 'package:subby/domain/usecase/complete_tutorial_usecase.dart';
import 'package:subby/domain/usecase/check_setup_completed_usecase.dart';
import 'package:subby/domain/usecase/complete_setup_usecase.dart';
import 'package:subby/domain/usecase/get_last_selected_group_code_usecase.dart';
import 'package:subby/domain/usecase/save_last_selected_group_code_usecase.dart';
import 'package:subby/domain/usecase/get_theme_mode_usecase.dart';
import 'package:subby/domain/usecase/set_theme_mode_usecase.dart';
import 'package:subby/domain/usecase/get_default_currency_usecase.dart';
import 'package:subby/domain/usecase/set_default_currency_usecase.dart';
import 'package:subby/domain/usecase/check_notification_enabled_usecase.dart';
import 'package:subby/domain/usecase/set_notification_enabled_usecase.dart';
import 'package:subby/domain/usecase/get_exchange_rate_usecase.dart';
import 'package:subby/domain/usecase/watch_is_anonymous_usecase.dart';
import 'package:subby/domain/usecase/get_current_nickname_usecase.dart';
import 'package:subby/domain/usecase/restart_subscription_sync_usecase.dart';

final createGroupUseCaseProvider = Provider<CreateGroupUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return CreateGroupUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
    userRepository: userRepository,
    pendingChangeRepository: pendingChangeRepository,
  );
});

final leaveGroupUseCaseProvider = Provider<LeaveGroupUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return LeaveGroupUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
    subscriptionRepository: subscriptionRepository,
    pendingChangeRepository: pendingChangeRepository,
  );
});

final joinGroupUseCaseProvider = Provider<JoinGroupUseCase>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return JoinGroupUseCase(
    groupRepository: groupRepository,
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

final watchSubscriptionsUseCaseProvider = Provider<WatchSubscriptionsUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);

  return WatchSubscriptionsUseCase(repository);
});

final addSubscriptionUseCaseProvider = Provider<AddSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return AddSubscriptionUseCase(repository, pendingChangeRepository);
});

final getSubscriptionByIdUseCaseProvider = Provider<GetSubscriptionByIdUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);

  return GetSubscriptionByIdUseCase(repository);
});

final updateSubscriptionUseCaseProvider = Provider<UpdateSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return UpdateSubscriptionUseCase(repository, pendingChangeRepository);
});

final deleteSubscriptionUseCaseProvider = Provider<DeleteSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return DeleteSubscriptionUseCase(repository, pendingChangeRepository);
});

final getPresetsUseCaseProvider = Provider<GetPresetsUseCase>((ref) {
  final repository = ref.watch(presetRepositoryProvider);

  return GetPresetsUseCase(repository);
});

final detectSubscriptionConflictUseCaseProvider =
    Provider<DetectSubscriptionConflictUseCase>((ref) {
  return DetectSubscriptionConflictUseCase();
});

final processPendingChangesUseCaseProvider =
    Provider<ProcessPendingChangesUseCase>((ref) {
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final detectConflict = ref.watch(detectSubscriptionConflictUseCaseProvider);

  return ProcessPendingChangesUseCase(
    pendingChangeRepository,
    groupRepository,
    subscriptionRepository,
    authRepository,
    detectConflict,
  );
});

final fetchUserInfoUseCaseProvider = Provider<FetchUserInfoUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return FetchUserInfoUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

final saveUserInfoUseCaseProvider = Provider<SaveUserInfoUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);

  return SaveUserInfoUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
    groupRepository: groupRepository,
  );
});

final checkAuthStateUseCaseProvider = Provider<CheckAuthStateUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return CheckAuthStateUseCase(authRepository: authRepository);
});

final signInAnonymouslyUseCaseProvider =
    Provider<SignInAnonymouslyUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return SignInAnonymouslyUseCase(authRepository: authRepository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);

  return SignOutUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
    groupRepository: groupRepository,
    subscriptionRepository: subscriptionRepository,
    pendingChangeRepository: pendingChangeRepository,
    onboardingRepository: onboardingRepository,
  );
});

final updateGroupDisplayNameUseCaseProvider =
    Provider<UpdateGroupDisplayNameUseCase>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);

  return UpdateGroupDisplayNameUseCase(groupRepository: groupRepository);
});

final watchGroupsUseCaseProvider = Provider<WatchGroupsUseCase>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);

  return WatchGroupsUseCase(groupRepository: groupRepository);
});

final syncRemoteGroupsUseCaseProvider =
    Provider<SyncRemoteGroupsUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);

  return SyncRemoteGroupsUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
  );
});

final syncUserDataAfterLoginUseCaseProvider =
    Provider<SyncUserDataAfterLoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  return SyncUserDataAfterLoginUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
    userRepository: userRepository,
  );
});

final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return SignInWithGoogleUseCase(authRepository: authRepository);
});

final watchGroupByCodeUseCaseProvider = Provider<WatchGroupByCodeUseCase>((ref) {
  final groupRepository = ref.watch(groupRepositoryProvider);
  return WatchGroupByCodeUseCase(groupRepository: groupRepository);
});

// Auth UseCase
final watchAuthStateUseCaseProvider = Provider<WatchAuthStateUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return WatchAuthStateUseCase(authRepository: authRepository);
});

// Onboarding UseCase
final checkOnboardingCompletedUseCaseProvider =
    Provider<CheckOnboardingCompletedUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CheckOnboardingCompletedUseCase(
      onboardingRepository: onboardingRepository);
});

final completeOnboardingUseCaseProvider =
    Provider<CompleteOnboardingUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CompleteOnboardingUseCase(onboardingRepository: onboardingRepository);
});

final checkTutorialCompletedUseCaseProvider =
    Provider<CheckTutorialCompletedUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CheckTutorialCompletedUseCase(
      onboardingRepository: onboardingRepository);
});

final completeTutorialUseCaseProvider =
    Provider<CompleteTutorialUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CompleteTutorialUseCase(onboardingRepository: onboardingRepository);
});

final checkSetupCompletedUseCaseProvider =
    Provider<CheckSetupCompletedUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CheckSetupCompletedUseCase(onboardingRepository: onboardingRepository);
});

final completeSetupUseCaseProvider = Provider<CompleteSetupUseCase>((ref) {
  final onboardingRepository = ref.watch(onboardingRepositoryProvider);
  return CompleteSetupUseCase(onboardingRepository: onboardingRepository);
});

// Settings UseCase
final getLastSelectedGroupCodeUseCaseProvider =
    Provider<GetLastSelectedGroupCodeUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return GetLastSelectedGroupCodeUseCase(settingsRepository: settingsRepository);
});

final saveLastSelectedGroupCodeUseCaseProvider =
    Provider<SaveLastSelectedGroupCodeUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SaveLastSelectedGroupCodeUseCase(
      settingsRepository: settingsRepository);
});

final getThemeModeUseCaseProvider = Provider<GetThemeModeUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return GetThemeModeUseCase(settingsRepository: settingsRepository);
});

final setThemeModeUseCaseProvider = Provider<SetThemeModeUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SetThemeModeUseCase(settingsRepository: settingsRepository);
});

final getDefaultCurrencyUseCaseProvider =
    Provider<GetDefaultCurrencyUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return GetDefaultCurrencyUseCase(settingsRepository: settingsRepository);
});

final setDefaultCurrencyUseCaseProvider =
    Provider<SetDefaultCurrencyUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SetDefaultCurrencyUseCase(settingsRepository: settingsRepository);
});

final checkNotificationEnabledUseCaseProvider =
    Provider<CheckNotificationEnabledUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return CheckNotificationEnabledUseCase(settingsRepository: settingsRepository);
});

final setNotificationEnabledUseCaseProvider =
    Provider<SetNotificationEnabledUseCase>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SetNotificationEnabledUseCase(settingsRepository: settingsRepository);
});

// ExchangeRate UseCase
final getExchangeRateUseCaseProvider = Provider<GetExchangeRateUseCase>((ref) {
  final exchangeRateRepository = ref.watch(exchangeRateRepositoryProvider);
  return GetExchangeRateUseCase(exchangeRateRepository: exchangeRateRepository);
});

// Anonymous/Nickname UseCase
final watchIsAnonymousUseCaseProvider = Provider<WatchIsAnonymousUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return WatchIsAnonymousUseCase(authRepository: authRepository);
});

final getCurrentNicknameUseCaseProvider = Provider<GetCurrentNicknameUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return GetCurrentNicknameUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
  );
});

// Subscription Sync UseCase
final restartSubscriptionSyncUseCaseProvider = Provider<RestartSubscriptionSyncUseCase>((ref) {
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  return RestartSubscriptionSyncUseCase(subscriptionRepository: subscriptionRepository);
});
