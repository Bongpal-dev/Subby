import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subby/data/database/database.dart';
import 'package:subby/data/datasource/subscription_local_datasource.dart';
import 'package:subby/data/dto/subscription_dto.dart';

void main() {
  late AppDatabase db;
  late SubscriptionLocalDataSource dataSource;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dataSource = SubscriptionLocalDataSource(db);
  });

  tearDown(() async {
    await db.close();
  });

  SubscriptionDto _createDto({
    String id = 'test-1',
    String name = 'Netflix',
    double amount = 13500,
    String currency = 'KRW',
    int billingDay = 15,
    int? billingMonth,
    String period = 'MONTHLY',
  }) {
    return SubscriptionDto(
      id: id,
      groupCode: 'group-1',
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      billingMonth: billingMonth,
      period: period,
      createdAt: DateTime(2025, 1, 1),
    );
  }

  group('insert & getById', () {
    test('저장 후 조회 시 모든 필드 일치', () async {
      final dto = _createDto(
        amount: 9.99,
        currency: 'USD',
        billingMonth: 3,
        period: 'YEARLY',
      );

      await dataSource.insert(dto);
      final result = await dataSource.getById('test-1');

      expect(result, isNotNull);
      expect(result!.id, dto.id);
      expect(result.name, dto.name);
      expect(result.amount, dto.amount);
      expect(result.currency, dto.currency);
      expect(result.billingDay, dto.billingDay);
      expect(result.billingMonth, dto.billingMonth);
      expect(result.period, dto.period);
    });

    test('billingMonth null 저장 (월간 결제)', () async {
      final dto = _createDto(billingMonth: null, period: 'MONTHLY');

      await dataSource.insert(dto);
      final result = await dataSource.getById('test-1');

      expect(result!.billingMonth, isNull);
    });
  });

  group('getAll', () {
    test('여러 건 저장 후 전체 조회', () async {
      await dataSource.insert(_createDto(id: 'a'));
      await dataSource.insert(_createDto(id: 'b'));
      await dataSource.insert(_createDto(id: 'c'));

      final result = await dataSource.getAll();
      expect(result.length, 3);
    });
  });

  group('update', () {
    test('금액 수정 후 반영 확인', () async {
      await dataSource.insert(_createDto(amount: 13500));

      final updated = _createDto(amount: 17000);
      await dataSource.update(updated);

      final result = await dataSource.getById('test-1');
      expect(result!.amount, 17000);
    });

    test('수정하지 않은 필드 유지', () async {
      await dataSource.insert(_createDto(name: 'Netflix', currency: 'KRW'));

      final updated = _createDto(name: 'Netflix Premium', currency: 'KRW');
      await dataSource.update(updated);

      final result = await dataSource.getById('test-1');
      expect(result!.name, 'Netflix Premium');
      expect(result.currency, 'KRW'); // 변경 안 함
    });
  });

  group('delete', () {
    test('삭제 후 조회 시 null', () async {
      await dataSource.insert(_createDto());

      await dataSource.delete('test-1');
      final result = await dataSource.getById('test-1');

      expect(result, isNull);
    });

    test('deleteByGroupCode: 해당 그룹만 삭제', () async {
      await dataSource.insert(_createDto(id: 'a'));
      await dataSource.insert(SubscriptionDto(
        id: 'b',
        groupCode: 'group-2',
        name: 'Spotify',
        amount: 10900,
        currency: 'KRW',
        billingDay: 1,
        period: 'MONTHLY',
        createdAt: DateTime(2025, 1, 1),
      ));

      await dataSource.deleteByGroupCode('group-1');

      final all = await dataSource.getAll();
      expect(all.length, 1);
      expect(all.first.groupCode, 'group-2');
    });
  });

  group('소수점 정밀도', () {
    test('9.99 저장 → 9.99 조회', () async {
      await dataSource.insert(_createDto(amount: 9.99, currency: 'USD'));

      final result = await dataSource.getById('test-1');
      expect(result!.amount, 9.99);
    });
  });
}
