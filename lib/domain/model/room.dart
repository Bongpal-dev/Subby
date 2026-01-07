/// 공유방 모델
class Room {
  /// 12자리 고유 코드 (PK)
  final String code;

  /// 방 이름
  final String name;

  /// 방장 UID (Firebase Anonymous Auth)
  final String ownerId;

  /// 멤버 UID 목록
  final List<String> members;

  /// 생성일시
  final DateTime createdAt;

  const Room({
    required this.code,
    required this.name,
    required this.ownerId,
    required this.members,
    required this.createdAt,
  });

  Room copyWith({
    String? code,
    String? name,
    String? ownerId,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return Room(
      code: code ?? this.code,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Firebase Realtime DB JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'ownerId': ownerId,
      'members': members,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Firebase Realtime DB JSON에서 생성
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      code: json['code'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      members: List<String>.from(json['members'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  /// 방장 여부 확인
  bool isOwner(String userId) => ownerId == userId;

  /// 멤버 여부 확인
  bool isMember(String userId) => members.contains(userId);
}
