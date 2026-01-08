import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/auth_providers.dart';
import 'package:subby/core/di/database_provider.dart';
import 'package:subby/data/datasource/group_remote_datasource.dart';
import 'package:subby/data/repository/group_repository_impl.dart';
import 'package:subby/domain/repository/group_repository.dart';
import 'package:subby/domain/usecase/create_group_usecase.dart';
import 'package:subby/domain/usecase/initialize_app_usecase.dart';

final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  return GroupRemoteDataSource();
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final remoteDataSource = ref.watch(groupRemoteDataSourceProvider);
  return GroupRepositoryImpl(db, remoteDataSource);
});

// UseCases
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
  return CreateGroupUseCase(
    authRepository: authRepository,
    groupRepository: groupRepository,
  );
});

// App State
final appInitializedProvider = FutureProvider<String>((ref) async {
  final initializeApp = ref.watch(initializeAppUseCaseProvider);
  return initializeApp();
});

final currentGroupCodeProvider = StateProvider<String?>((ref) {
  final appInit = ref.watch(appInitializedProvider);
  return appInit.valueOrNull;
});

final currentGroupProvider = StreamProvider((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);
  if (groupCode == null) return const Stream.empty();

  final groupRepository = ref.watch(groupRepositoryProvider);
  return groupRepository.watchByCode(groupCode);
});
