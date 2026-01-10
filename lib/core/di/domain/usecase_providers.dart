import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/domain/usecase/add_subscription_usecase.dart';
import 'package:subby/domain/usecase/create_group_usecase.dart';
import 'package:subby/domain/usecase/delete_subscription_usecase.dart';
import 'package:subby/domain/usecase/get_presets_usecase.dart';
import 'package:subby/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:subby/domain/usecase/initialize_app_usecase.dart';
import 'package:subby/domain/usecase/leave_group_usecase.dart';
import 'package:subby/domain/usecase/process_pending_changes_usecase.dart';
import 'package:subby/domain/usecase/update_subscription_usecase.dart';
import 'package:subby/domain/usecase/watch_subscriptions_usecase.dart';

final initializeAppUseCaseProvider = Provider<InitializeAppUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);

  return InitializeAppUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
  );
});

final createGroupUseCaseProvider = Provider<CreateGroupUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);

  return CreateGroupUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
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

  return DeleteSubscriptionUseCase(repository);
});

final getPresetsUseCaseProvider = Provider<GetPresetsUseCase>((ref) {
  final repository = ref.watch(presetRepositoryProvider);

  return GetPresetsUseCase(repository);
});

final processPendingChangesUseCaseProvider = Provider<ProcessPendingChangesUseCase>((ref) {
  final pendingChangeRepository = ref.watch(pendingChangeRepositoryProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  final subscriptionRepository = ref.watch(subscriptionRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return ProcessPendingChangesUseCase(
    pendingChangeRepository,
    groupRepository,
    subscriptionRepository,
    authRepository,
  );
});
