import 'package:drift/drift.dart';

import '../database/database.dart';
import '../dto/exchange_rate_dto.dart';

class ExchangeRateLocalDataSource {
  final AppDatabase _db;

  ExchangeRateLocalDataSource(this._db);

  Future<ExchangeRateDto?> getByDate(String dateKey) async {
    final query = _db.select(_db.fxRatesDaily)
      ..where((t) => t.dateKey.equals(dateKey));

    final row = await query.getSingleOrNull();

    if (row == null) return null;

    return ExchangeRateDto(
      usd: row.usd,
      krw: row.krw,
      eur: row.eur,
      jpy: row.jpy,
      updatedAt: row.fetchedAt,
    );
  }

  Future<void> save(String dateKey, ExchangeRateDto dto, String source) async {
    await _db.into(_db.fxRatesDaily).insertOnConflictUpdate(
          FxRatesDailyCompanion(
            dateKey: Value(dateKey),
            usd: Value(dto.usd),
            krw: Value(dto.krw),
            eur: Value(dto.eur),
            jpy: Value(dto.jpy),
            fetchedAt: Value(dto.updatedAt),
            source: Value(source),
          ),
        );
  }
}
