/// 필드별 충돌 정보
class FieldConflict {
  final String fieldName;
  final String localValue;
  final String serverValue;

  const FieldConflict({
    required this.fieldName,
    required this.localValue,
    required this.serverValue,
  });
}
