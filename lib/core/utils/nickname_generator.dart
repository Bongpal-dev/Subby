import 'dart:math';

/// 랜덤 닉네임 생성기
/// 형식: {형용사} {색상}색 {동물}
class NicknameGenerator {
  static final _random = Random();

  static const _adjectives = [
    '빠른', '느린', '졸린', '배고픈', '행복한',
    '용감한', '수줍은', '귀여운', '씩씩한', '엉뚱한',
    '반짝이는', '조용한', '부지런한', '게으른', '다정한',
    '든든한', '신나는', '차분한', '똑똑한', '배부른',
  ];

  static const _colors = [
    '빨간', '파란', '노란', '초록', '보라',
    '분홍', '하얀', '까만', '주황', '하늘',
    '민트', '연두', '황금', '은빛', '살구',
    '자주', '청록', '밤', '베이지', '연보라',
  ];

  static const _animals = [
    '고양이', '강아지', '판다', '펭귄', '토끼',
    '여우', '곰', '수달', '코알라', '알파카',
    '햄스터', '부엉이', '돌고래', '다람쥐', '기린',
    '치타', '사자', '호랑이', '레서판다', '물개',
  ];

  /// 랜덤 닉네임 생성
  static String generate() {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final color = _colors[_random.nextInt(_colors.length)];
    final animal = _animals[_random.nextInt(_animals.length)];

    return '$adjective ${color}색 $animal';
  }
}
