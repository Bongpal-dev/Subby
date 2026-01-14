/// 동기화 이벤트 모델
class SyncEvent {
  final int insertedCount;
  final int updatedCount;
  final int deletedCount;
  final DateTime timestamp;

  const SyncEvent({
    required this.insertedCount,
    required this.updatedCount,
    required this.deletedCount,
    required this.timestamp,
  });

  int get totalCount => insertedCount + updatedCount + deletedCount;

  bool get hasChanges => totalCount > 0;

  String get message => '변동된 항목이 $totalCount개 있습니다';
}
