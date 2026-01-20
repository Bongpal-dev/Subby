import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/database_provider.dart';
import 'package:subby/data/datasource/exchange_rate_local_datasource.dart';
import 'package:subby/data/datasource/exchange_rate_remote_datasource.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/data/datasource/group_local_datasource.dart';
import 'package:subby/data/datasource/group_remote_datasource.dart';
import 'package:subby/data/datasource/pending_change_local_datasource.dart';
import 'package:subby/data/datasource/preset_local_datasource.dart';
import 'package:subby/data/datasource/preset_remote_datasource.dart';
import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/datasource/subscription_remote_datasource.dart';
import 'package:subby/data/datasource/fcm_token_remote_datasource.dart';

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

/// 현재 사용자가 익명인지 여부를 실시간으로 감지
final isAnonymousProvider = StreamProvider<bool>((ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  return authDataSource.userChanges.map((user) => user?.isAnonymous ?? true);
});

final groupLocalDataSourceProvider = Provider<GroupLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);

  return GroupLocalDataSource(db);
});

final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  return GroupRemoteDataSource();
});

final subscriptionLocalDataSourceProvider = Provider<SubscriptionLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);

  return SubscriptionLocalDataSource(db);
});

final subscriptionRemoteDataSourceProvider = Provider<SubscriptionRemoteDataSource>((ref) {
  return SubscriptionRemoteDataSource();
});

final presetRemoteDataSourceProvider = Provider<PresetRemoteDataSource>((ref) {
  return PresetRemoteDataSource();
});

final presetLocalDataSourceProvider = Provider<PresetLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);

  return PresetLocalDataSource(db);
});

final pendingChangeLocalDataSourceProvider = Provider<PendingChangeLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);

  return PendingChangeLocalDataSource(db);
});

final exchangeRateLocalDataSourceProvider = Provider<ExchangeRateLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);

  return ExchangeRateLocalDataSource(db);
});

final exchangeRateRemoteDataSourceProvider = Provider<ExchangeRateRemoteDataSource>((ref) {
  return ExchangeRateRemoteDataSource();
});

final fcmTokenRemoteDataSourceProvider = Provider<FcmTokenRemoteDataSource>((ref) {
  return FcmTokenRemoteDataSource();
});
