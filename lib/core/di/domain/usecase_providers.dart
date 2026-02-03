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
import 'package:subby/domain/usecase/get_last_selected_group_usecase.dart';
import 'package:subby/domain/usecase/save_last_selected_group_usecase.dart';
import 'package:subby/domain/usecase/sign_in_anonymously_usecase.dart';
import 'package:subby/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:subby/domain/usecase/sign_out_usecase.dart';
import 'package:subby/domain/usecase/sync_remote_groups_usecase.dart';
import 'package:subby/domain/usecase/sync_user_data_after_login_usecase.dart';
import 'package:subby/domain/usecase/update_group_display_name_usecase.dart';
import 'package:subby/domain/usecase/update_subscription_usecase.dart';
import 'package:subby/domain/usecase/watch_groups_usecase.dart';
import 'package:subby/domain/usecase/watch_subscriptions_usecase.dart';

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

  return SignOutUseCase(
    authRepository: authRepository,
    userRepository: userRepository,
    groupRepository: groupRepository,
    subscriptionRepository: subscriptionRepository,
    pendingChangeRepository: pendingChangeRepository,
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

final getLastSelectedGroupUseCaseProvider =
    Provider<GetLastSelectedGroupUseCase>((ref) {
  return GetLastSelectedGroupUseCase();
});

final saveLastSelectedGroupUseCaseProvider =
    Provider<SaveLastSelectedGroupUseCase>((ref) {
  return SaveLastSelectedGroupUseCase();
});
