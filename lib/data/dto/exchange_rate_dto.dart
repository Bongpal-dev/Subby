class ExchangeRateDto {
  final double usd;
  final double krw;
  final double eur;
  final double jpy;
  final DateTime updatedAt;

  const ExchangeRateDto({
    required this.usd,
    required this.krw,
    required this.eur,
    required this.jpy,
    required this.updatedAt,
  });

  factory ExchangeRateDto.fromJson(Map<String, dynamic> json) {
    return ExchangeRateDto(
      usd: (json['USD'] as num).toDouble(),
      krw: (json['KRW'] as num).toDouble(),
      eur: (json['EUR'] as num).toDouble(),
      jpy: (json['JPY'] as num).toDouble(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
}
