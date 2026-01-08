import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/data/repository/auth_repository_impl.dart';
import 'package:subby/domain/repository/auth_repository.dart';

// DataSource
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource: dataSource);
});

// State
final authStateProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});
