import 'dart:math';

/// 12자리 영숫자 그룹 코드 생성
class GroupCodeGenerator {
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static final _random = Random.secure();

  /// 12자리 그룹 코드 생성
  static String generate() {
    return List.generate(12, (_) => _chars[_random.nextInt(_chars.length)]).join();
  }
}
