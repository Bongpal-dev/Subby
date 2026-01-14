import 'dart:async';

import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/datasource/subscription_remote_datasource.dart';
import 'package:subby/data/dto/subscription_dto.dart';
import 'package:subby/domain/model/sync_event.dart';

class RealtimeSyncService {
  final SubscriptionRemoteDataSource _remoteDataSource;
  final SubscriptionLocalDataSource _localDataSource;

  StreamSubscription<List<SubscriptionDto>>? _subscription;
  final _syncEventController = StreamController<SyncEvent>.broadcast();

  Stream<SyncEvent> get syncEventStream => _syncEventController.stream;

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

    // 추가 - Remote에만 있는 항목
    final toInsert = remoteList.where((e) => !localIds.contains(e.id)).toList();

    for (final dto in toInsert) {
      await _localDataSource.insert(dto);
    }

    // 수정 - 양쪽에 있지만 내용 다른 항목
    final toUpdate = remoteList.where((remote) {
      final local = localMap[remote.id];

      if (local == null) return false;

      return _isDifferent(remote, local);
    }).toList();

    for (final dto in toUpdate) {
      await _localDataSource.update(dto);
    }

    // 삭제 - Local에만 있는 항목
    final toDelete = localFiltered.where((e) => !remoteIds.contains(e.id)).toList();

    for (final dto in toDelete) {
      await _localDataSource.delete(dto.id);
    }

    // 변경 사항이 있으면 이벤트 발행
    final insertedCount = toInsert.length;
    final updatedCount = toUpdate.length;
    final deletedCount = toDelete.length;

    if (insertedCount > 0 || updatedCount > 0 || deletedCount > 0) {
      _syncEventController.add(SyncEvent(
        insertedCount: insertedCount,
        updatedCount: updatedCount,
        deletedCount: deletedCount,
        timestamp: DateTime.now(),
      ));
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

  void dispose() {
    stopSync();
    _syncEventController.close();
  }
}
