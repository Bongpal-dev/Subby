import 'dart:ui' show Locale;

enum PresetCategory {
  VIDEO,
  MUSIC,
  GAME,
  AI,
  DEV,
  CLOUD,
  PRODUCTIVITY,
  EDUCATION,
  DESIGN,
  FINANCE,
}

class SubscriptionPreset {
  final String brandKey;
  final String displayNameKo;
  final String? displayNameEn;
  final PresetCategory category;
  final String defaultCurrency;
  final String defaultPeriod;
  final List<String> aliases;
  final String? notes;
  final List<String>? includes;

  const SubscriptionPreset({
    required this.brandKey,
    required this.displayNameKo,
    this.displayNameEn,
    required this.category,
    required this.defaultCurrency,
    required this.defaultPeriod,
    this.aliases = const [],
    this.notes,
    this.includes,
  });

  /// Locale에 따라 적절한 이름 반환
  /// - ko: displayNameKo 우선, 없으면 displayNameEn
  /// - 그 외: displayNameEn 우선, 없으면 displayNameKo
  String displayName(Locale locale) {
    if (locale.languageCode == 'ko') {
      return displayNameKo.isNotEmpty ? displayNameKo : (displayNameEn ?? brandKey);
    } else {
      return (displayNameEn?.isNotEmpty == true) ? displayNameEn! : displayNameKo;
    }
  }
}
