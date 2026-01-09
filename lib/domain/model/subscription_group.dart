/// 구독 그룹 모델
/// 모든 구독은 그룹에 속함 (개인/공유 구분 없음)
class SubscriptionGroup {
  final String code;
  final String name;
  final String? displayName;
  final String ownerId;
  final List<String> members;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SubscriptionGroup({
    required this.code,
    required this.name,
    this.displayName,
    required this.ownerId,
    required this.members,
    required this.createdAt,
    this.updatedAt,
  });

  String get effectiveName => displayName ?? name;

  SubscriptionGroup copyWith({
    String? code,
    String? name,
    String? displayName,
    bool clearDisplayName = false,
    String? ownerId,
    List<String>? members,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionGroup(
      code: code ?? this.code,
      name: name ?? this.name,
      displayName: clearDisplayName ? null : (displayName ?? this.displayName),
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 그룹장 여부 확인
  bool isOwner(String userId) => ownerId == userId;

  /// 멤버 여부 확인
  bool isMember(String userId) => members.contains(userId);
}
