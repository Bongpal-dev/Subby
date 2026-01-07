import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/datasource/preset_local_datasource.dart';
import 'package:subby/data/datasource/preset_remote_datasource.dart';
import 'package:subby/data/repository/preset_repository_impl.dart';
import 'package:subby/data/repository/subscription_repository_impl.dart';
import 'package:subby/domain/repository/preset_repository.dart';
import 'package:subby/domain/repository/subscription_repository.dart';
import 'package:subby/domain/usecase/add_subscription_usecase.dart';
import 'package:subby/domain/usecase/delete_subscription_usecase.dart';
import 'package:subby/domain/usecase/get_presets_usecase.dart';
import 'package:subby/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:subby/domain/usecase/update_subscription_usecase.dart';
import 'package:subby/domain/usecase/watch_subscriptions_usecase.dart';

// Database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// DataSources
final presetRemoteDataSourceProvider = Provider<PresetRemoteDataSource>((ref) {
  return PresetRemoteDataSource();
});

final presetLocalDataSourceProvider = Provider<PresetLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return PresetLocalDataSource(db);
});

// Repositories
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SubscriptionRepositoryImpl(db);
});

final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  final remoteDataSource = ref.watch(presetRemoteDataSourceProvider);
  final localDataSource = ref.watch(presetLocalDataSourceProvider);
  return PresetRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// UseCases
final watchSubscriptionsUseCaseProvider = Provider<WatchSubscriptionsUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return WatchSubscriptionsUseCase(repository);
});

final addSubscriptionUseCaseProvider = Provider<AddSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return AddSubscriptionUseCase(repository);
});

final getSubscriptionByIdUseCaseProvider = Provider<GetSubscriptionByIdUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return GetSubscriptionByIdUseCase(repository);
});

final updateSubscriptionUseCaseProvider = Provider<UpdateSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return UpdateSubscriptionUseCase(repository);
});

final deleteSubscriptionUseCaseProvider = Provider<DeleteSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return DeleteSubscriptionUseCase(repository);
});

final getPresetsUseCaseProvider = Provider<GetPresetsUseCase>((ref) {
  final repository = ref.watch(presetRepositoryProvider);
  return GetPresetsUseCase(repository);
});
