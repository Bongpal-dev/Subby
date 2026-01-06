import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ──────────────────────────────────────────────
// 1) subscriptions 테이블
// ──────────────────────────────────────────────
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()(); // KRW, USD
  IntColumn get billingDay => integer()();
  TextColumn get period => text()(); // MONTHLY, YEARLY
  TextColumn get category => text().nullable()();
  TextColumn get memo => text().nullable()();
  RealColumn get feeRatePercent => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ──────────────────────────────────────────────
// 2) fx_rates_daily 테이블
// ──────────────────────────────────────────────
class FxRatesDaily extends Table {
  TextColumn get dateKey => text()(); // YYYY-MM-DD
  RealColumn get usdToKrw => real()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text()();

  @override
  Set<Column> get primaryKey => {dateKey};
}

// ──────────────────────────────────────────────
// 3) payment_logs 테이블
// ──────────────────────────────────────────────
class PaymentLogs extends Table {
  TextColumn get id => text()();
  TextColumn get subscriptionId => text()();
  TextColumn get cycleKey => text()(); // YYYY-MM
  DateTimeColumn get paidAt => dateTime()();
  RealColumn get usdAmount => real().nullable()();
  RealColumn get fxRateApplied => real().nullable()();
  RealColumn get krwFinal => real()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ──────────────────────────────────────────────
// AppDatabase
// ──────────────────────────────────────────────
@DriftDatabase(tables: [Subscriptions, FxRatesDaily, PaymentLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'subby.db');
  }
}
