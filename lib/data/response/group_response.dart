class GroupResponse {
  final String code;
  final String name;
  final String ownerId;
  final List<String> members;
  final int createdAt;
  final int? updatedAt;

  GroupResponse({
    required this.code,
    required this.name,
    required this.ownerId,
    required this.members,
    required this.createdAt,
    this.updatedAt,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    List<String> memberList = [];

    if (json['members'] != null) {
      if (json['members'] is Map) {
        memberList = (json['members'] as Map).keys.cast<String>().toList();
      } else if (json['members'] is List) {
        memberList = List<String>.from(json['members']);
      }
    }

    return GroupResponse(
      code: json['code'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      members: memberList,
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'ownerId': ownerId,
      'members': {for (var uid in members) uid: true},
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
