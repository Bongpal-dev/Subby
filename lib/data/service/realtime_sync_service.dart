import 'dart:async';

import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/datasource/subscription_remote_datasource.dart';
import 'package:subby/data/dto/subscription_dto.dart';

class RealtimeSyncService {
  final SubscriptionRemoteDataSource _remoteDataSource;
  final SubscriptionLocalDataSource _localDataSource;

  StreamSubscription<List<SubscriptionDto>>? _subscription;

  RealtimeSyncService(this._remoteDataSource, this._localDataSource);

  void startSync(String groupCode) {
    _subscription?.cancel();
    _subscription = _remoteDataSource.watchSubscriptions(groupCode).listen(
      (remoteList) => _syncSubscriptions(remoteList, groupCode),
    );
  }

  Future<void> _syncSubscriptions(
    List<SubscriptionDto> remoteList,
    String groupCode,
  ) async {
    final localList = await _localDataSource.getAll();
    final localFiltered =
        localList.where((e) => e.groupCode == groupCode).toList();

    final remoteIds = remoteList.map((e) => e.id).toSet();
    final localIds = localFiltered.map((e) => e.id).toSet();
    final localMap = {for (final e in localFiltered) e.id: e};

    // #39: 추가 - Remote에만 있는 항목
    final toInsert = remoteList.where((e) => !localIds.contains(e.id));

    for (final dto in toInsert) {
      await _localDataSource.insert(dto);
    }

    // #40: 수정 - 양쪽에 있지만 내용 다른 항목
    final toUpdate = remoteList.where((remote) {
      final local = localMap[remote.id];

      if (local == null) return false;

      return _isDifferent(remote, local);
    });

    for (final dto in toUpdate) {
      await _localDataSource.update(dto);
    }

    // #41: 삭제 - Local에만 있는 항목
    final toDelete = localFiltered.where((e) => !remoteIds.contains(e.id));

    for (final dto in toDelete) {
      await _localDataSource.delete(dto.id);
    }
  }

  bool _isDifferent(SubscriptionDto a, SubscriptionDto b) {
    return a.name != b.name ||
        a.amount != b.amount ||
        a.currency != b.currency ||
        a.billingDay != b.billingDay ||
        a.period != b.period ||
        a.category != b.category ||
        a.memo != b.memo ||
        a.feeRatePercent != b.feeRatePercent;
  }

  void stopSync() {
    _subscription?.cancel();
    _subscription = null;
  }
}
