import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/database_provider.dart';
import 'package:subby/data/datasource/preset_local_datasource.dart';
import 'package:subby/data/datasource/preset_remote_datasource.dart';
import 'package:subby/data/repository/preset_repository_impl.dart';
import 'package:subby/domain/repository/preset_repository.dart';
import 'package:subby/domain/usecase/get_presets_usecase.dart';

// DataSources
final presetRemoteDataSourceProvider = Provider<PresetRemoteDataSource>((ref) {
  return PresetRemoteDataSource();
});

final presetLocalDataSourceProvider = Provider<PresetLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return PresetLocalDataSource(db);
});

// Repository
final presetRepositoryProvider = Provider<PresetRepository>((ref) {
  final remoteDataSource = ref.watch(presetRemoteDataSourceProvider);
  final localDataSource = ref.watch(presetLocalDataSourceProvider);
  return PresetRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// UseCases
final getPresetsUseCaseProvider = Provider<GetPresetsUseCase>((ref) {
  final repository = ref.watch(presetRepositoryProvider);
  return GetPresetsUseCase(repository);
});
