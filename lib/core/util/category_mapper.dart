import 'package:subby/domain/model/subscription_preset.dart';

/// PresetCategory를 한글 카테고리명으로 변환
String mapPresetCategoryToKorean(PresetCategory category) {
  switch (category) {
    case PresetCategory.VIDEO:
      return '영상';
    case PresetCategory.MUSIC:
      return '음악';
    case PresetCategory.GAME:
      return '게임';
    case PresetCategory.AI:
    case PresetCategory.DEV:
    case PresetCategory.CLOUD:
    case PresetCategory.PRODUCTIVITY:
      return '소프트웨어';
    case PresetCategory.EDUCATION:
      return '교육';
    case PresetCategory.DESIGN:
      return '디자인';
    case PresetCategory.FINANCE:
      return '금융';
    case PresetCategory.MEMBERSHIP:
      return '멤버십';
    case PresetCategory.DELIVERY:
      return '배달';
    case PresetCategory.EBOOK:
      return '전자책';
    case PresetCategory.MOBILITY:
      return '모빌리티';
    case PresetCategory.LIFESTYLE:
      return '라이프스타일';
  }
}
