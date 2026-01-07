/// 공유 그룹 모델
class ShareGroup {
  /// 12자리 고유 코드 (PK)
  final String code;

  /// 그룹 이름
  final String name;

  /// 그룹장 UID (Firebase Anonymous Auth)
  final String ownerId;

  /// 멤버 UID 목록
  final List<String> members;

  /// 생성일시
  final DateTime createdAt;

  const ShareGroup({
    required this.code,
    required this.name,
    required this.ownerId,
    required this.members,
    required this.createdAt,
  });

  ShareGroup copyWith({
    String? code,
    String? name,
    String? ownerId,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return ShareGroup(
      code: code ?? this.code,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Firebase Realtime DB JSON으로 변환
  /// members는 map 형태로 저장 (Security Rules 활용 용이)
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'ownerId': ownerId,
      'members': {for (var uid in members) uid: true},
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Firebase Realtime DB JSON에서 생성
  factory ShareGroup.fromJson(Map<String, dynamic> json) {
    // members가 map 형태인 경우 key 목록 추출
    List<String> memberList = [];
    if (json['members'] != null) {
      if (json['members'] is Map) {
        memberList = (json['members'] as Map).keys.cast<String>().toList();
      } else if (json['members'] is List) {
        memberList = List<String>.from(json['members']);
      }
    }

    return ShareGroup(
      code: json['code'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      members: memberList,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  /// 그룹장 여부 확인
  bool isOwner(String userId) => ownerId == userId;

  /// 멤버 여부 확인
  bool isMember(String userId) => members.contains(userId);
}
