/// 공유 데이터의 동기화 상태
enum SyncStatus {
  /// 서버와 동기화됨
  synced,

  /// 로컬 변경 대기 중 (서버에 아직 반영 안 됨)
  pending,

  /// 충돌 발생 (로컬과 서버 데이터가 다름)
  conflict,
}
