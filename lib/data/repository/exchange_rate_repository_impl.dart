import 'package:intl/intl.dart';

import '../../domain/model/exchange_rate.dart';
import '../../domain/repository/exchange_rate_repository.dart';
import '../datasource/exchange_rate_local_datasource.dart';
import '../datasource/exchange_rate_remote_datasource.dart';
import '../mapper/exchange_rate_mapper.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateLocalDataSource _localDataSource;
  final ExchangeRateRemoteDataSource _remoteDataSource;

  ExchangeRateRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<ExchangeRate?> getExchangeRate() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. 로컬 캐시 확인
    final cached = await _localDataSource.getByDate(today);

    if (cached != null) {
      return cached.toModel();
    }

    // 2. Remote에서 fetch
    final remote = await _remoteDataSource.fetchExchangeRates();

    if (remote == null) {
      return null;
    }

    // 3. 로컬에 저장
    await _localDataSource.save(today, remote, 'openexchangerates');

    return remote.toModel();
  }
}
