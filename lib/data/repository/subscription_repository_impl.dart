import 'package:drift/drift.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/domain/model/subscription.dart' as domain;
import 'package:subby/domain/repository/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final AppDatabase _db;

  SubscriptionRepositoryImpl(this._db);

  @override
  Future<List<domain.Subscription>> getAll() async {
    final rows = await _db.select(_db.subscriptions).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<domain.Subscription?> getById(String id) async {
    final row = await (_db.select(_db.subscriptions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _toDomain(row) : null;
  }

  @override
  Future<void> insert(domain.Subscription subscription) async {
    await _db.into(_db.subscriptions).insert(_toCompanion(subscription));
  }

  @override
  Future<void> update(domain.Subscription subscription) async {
    await (_db.update(_db.subscriptions)
          ..where((t) => t.id.equals(subscription.id)))
        .write(_toCompanion(subscription));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.subscriptions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Stream<List<domain.Subscription>> watchAll() {
    return _db.select(_db.subscriptions).watch().map(
          (rows) => rows.map(_toDomain).toList(),
        );
  }

  domain.Subscription _toDomain(Subscription row) {
    return domain.Subscription(
      id: row.id,
      name: row.name,
      amount: row.amount,
      currency: row.currency,
      billingDay: row.billingDay,
      period: row.period,
      category: row.category,
      memo: row.memo,
      feeRatePercent: row.feeRatePercent,
      createdAt: row.createdAt,
    );
  }

  SubscriptionsCompanion _toCompanion(domain.Subscription subscription) {
    return SubscriptionsCompanion.insert(
      id: subscription.id,
      name: subscription.name,
      amount: subscription.amount,
      currency: subscription.currency,
      billingDay: subscription.billingDay,
      period: subscription.period,
      category: Value.absentIfNull(subscription.category),
      memo: Value.absentIfNull(subscription.memo),
      feeRatePercent: Value.absentIfNull(subscription.feeRatePercent),
      createdAt: subscription.createdAt,
    );
  }
}
