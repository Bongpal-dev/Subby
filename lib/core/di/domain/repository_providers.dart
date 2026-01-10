import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/data/datasource_providers.dart';
import 'package:subby/data/repository/auth_repository_impl.dart';
import 'package:subby/data/repository/group_repository_impl.dart';
import 'package:subby/data/repository/pending_change_repository_impl.dart';
import 'package:subby/data/repository/preset_repository_impl.dart';
import 'package:subby/data/repository/subscription_repository_impl.dart';
import 'package:subby/domain/repository/auth_repository.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/repository/pending_change_repository.dart';
import 'package:subby/domain/repository/preset_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);

  return AuthRepositoryImpl(dataSource: dataSource);
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final localDataSource = ref.watch(groupLocalDataSourceProvider);
  final remoteDataSource = ref.watch(groupRemoteDataSourceProvider);

  return GroupRepositoryImpl(localDataSource, remoteDataSource);
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final localDataSource = ref.watch(subscriptionLocalDataSourceProvider);
  final remoteDataSource = ref.watch(subscriptionRemoteDataSourceProvider);

  return SubscriptionRepositoryImpl(localDataSource, remoteDataSource);
});

final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  final remoteDataSource = ref.watch(presetRemoteDataSourceProvider);
  final localDataSource = ref.watch(presetLocalDataSourceProvider);

  return PresetRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final pendingChangeRepositoryProvider = Provider<PendingChangeRepository>((ref) {
  final localDataSource = ref.watch(pendingChangeLocalDataSourceProvider);

  return PendingChangeRepositoryImpl(localDataSource);
});
