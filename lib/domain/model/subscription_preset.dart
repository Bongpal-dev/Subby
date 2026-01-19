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
  MEMBERSHIP,   // 쇼핑 멤버십
  DELIVERY,     // 배달
  EBOOK,        // 전자책
  MOBILITY,     // 모빌리티
  LIFESTYLE,    // 라이프스타일
}

/// 요금제 옵션 (서비스 하위의 요금제)
class PlanOption {
  final String planKey;          // "plus", "max"
  final String displayNameKo;    // "플러스"
  final String? displayNameEn;   // "Plus"
  final double price;            // 20.0
  final String currency;         // "USD"
  final String period;           // "MONTHLY"
  final String? notes;           // "GPT-4o 무제한"

  const PlanOption({
    required this.planKey,
    required this.displayNameKo,
    this.displayNameEn,
    required this.price,
    required this.currency,
    required this.period,
    this.notes,
  });

  /// Locale에 따라 적절한 이름 반환
  String displayName(Locale locale) {
    if (locale.languageCode == 'ko') {
      return displayNameKo.isNotEmpty ? displayNameKo : (displayNameEn ?? planKey);
    } else {
      return (displayNameEn?.isNotEmpty == true) ? displayNameEn! : displayNameKo;
    }
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() => {
    'planKey': planKey,
    'displayNameKo': displayNameKo,
    'displayNameEn': displayNameEn,
    'price': price,
    'currency': currency,
    'period': period,
    'notes': notes,
  };

  /// JSON 역직렬화
  factory PlanOption.fromJson(Map<String, dynamic> json) => PlanOption(
    planKey: json['planKey'] ?? '',
    displayNameKo: json['displayNameKo'] ?? '',
    displayNameEn: json['displayNameEn'],
    price: (json['price'] ?? 0).toDouble(),
    currency: json['currency'] ?? 'USD',
    period: json['period'] ?? 'MONTHLY',
    notes: json['notes'],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanOption &&
          runtimeType == other.runtimeType &&
          planKey == other.planKey;

  @override
  int get hashCode => planKey.hashCode;
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
  final List<PlanOption> plans;  // 요금제 목록

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
    this.plans = const [],
  });

  /// plans가 있는지 여부
  bool get hasPlans => plans.isNotEmpty;

  /// plans가 1개인지 여부
  bool get hasSinglePlan => plans.length == 1;

  /// 기본 요금제 (첫 번째 요금제)
  PlanOption? get defaultPlan => plans.isNotEmpty ? plans.first : null;

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
