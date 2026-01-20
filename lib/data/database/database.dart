import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ──────────────────────────────────────────────
// 1) user_subscriptions 테이블
// ──────────────────────────────────────────────
class UserSubscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get groupCode => text()(); // 필수 - 소속 그룹 코드
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
  RealColumn get usd => real()(); // 1.0 (base)
  RealColumn get krw => real()();
  RealColumn get eur => real()();
  RealColumn get jpy => real()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text()();

  @override
  Set<Column> get primaryKey => {dateKey};
}

// ──────────────────────────────────────────────
// 3) preset_cache 테이블
// ──────────────────────────────────────────────
class PresetCache extends Table {
  TextColumn get brandKey => text()();
  TextColumn get displayNameKo => text()();
  TextColumn get displayNameEn => text().nullable()();
  TextColumn get category => text()();
  TextColumn get defaultCurrency => text()();
  TextColumn get defaultPeriod => text()();
  TextColumn get aliases => text().nullable()(); // JSON array string
  TextColumn get notes => text().nullable()();
  TextColumn get plans => text().nullable()(); // JSON array of PlanOption
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {brandKey};
}

// ──────────────────────────────────────────────
// 4) subscription_groups 테이블
// ──────────────────────────────────────────────
class SubscriptionGroups extends Table {
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get ownerId => text()();
  TextColumn get members => text().withDefault(const Constant('[]'))(); // JSON array
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {code};
}

// ──────────────────────────────────────────────
// 5) payment_logs 테이블
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
// 6) pending_changes 테이블 (오프라인 동기화 큐)
// ──────────────────────────────────────────────
class PendingChanges extends Table {
  TextColumn get entityId => text()(); // PK - 대상 엔티티 ID
  TextColumn get entityType => text()(); // 'subscription', 'group'
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  TextColumn get payload => text()(); // JSON 데이터
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {entityId};
}

// ──────────────────────────────────────────────
// AppDatabase
// ──────────────────────────────────────────────
@DriftDatabase(tables: [UserSubscriptions, FxRatesDaily, PresetCache, SubscriptionGroups, PaymentLogs, PendingChanges])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(subscriptionGroups, subscriptionGroups.displayName);
      }
      if (from < 3) {
        await migrator.createTable(pendingChanges);
      }
      if (from < 4) {
        // FxRatesDaily 테이블 재생성 (캐시 데이터이므로 삭제 후 재생성)
        await migrator.deleteTable('fx_rates_daily');
        await migrator.createTable(fxRatesDaily);
      }
      if (from < 5) {
        await migrator.addColumn(subscriptionGroups, subscriptionGroups.members);
      }
      if (from < 6) {
        // PresetCache에 plans 컬럼 추가
        await migrator.addColumn(presetCache, presetCache.plans);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'subby.db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  /// 로그아웃 시 사용자 데이터 삭제 (캐시 제외)
  Future<void> clearUserData() async {
    await delete(userSubscriptions).go();
    await delete(subscriptionGroups).go();
    await delete(pendingChanges).go();
    await delete(paymentLogs).go();
  }
}
