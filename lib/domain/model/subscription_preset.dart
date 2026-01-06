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
}
