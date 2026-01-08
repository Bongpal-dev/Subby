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

  /// Firestore JSON으로 변환
  /// members는 map 형태로 저장 (Security Rules 활용 용이)
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'ownerId': ownerId,
      'members': {for (var uid in members) uid: true},
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Firestore JSON에서 생성
  factory SubscriptionGroup.fromJson(Map<String, dynamic> json) {
    // members가 map 형태인 경우 key 목록 추출
    List<String> memberList = [];
    if (json['members'] != null) {
      if (json['members'] is Map) {
        memberList = (json['members'] as Map).keys.cast<String>().toList();
      } else if (json['members'] is List) {
        memberList = List<String>.from(json['members']);
      }
    }

    return SubscriptionGroup(
      code: json['code'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      members: memberList,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: json['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int)
          : null,
    );
  }

  /// 그룹장 여부 확인
  bool isOwner(String userId) => ownerId == userId;

  /// 멤버 여부 확인
  bool isMember(String userId) => members.contains(userId);
}
