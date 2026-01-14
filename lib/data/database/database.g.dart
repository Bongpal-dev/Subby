// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserSubscriptionsTable extends UserSubscriptions
    with TableInfo<$UserSubscriptionsTable, UserSubscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupCodeMeta = const VerificationMeta(
    'groupCode',
  );
  @override
  late final GeneratedColumn<String> groupCode = GeneratedColumn<String>(
    'group_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingDayMeta = const VerificationMeta(
    'billingDay',
  );
  @override
  late final GeneratedColumn<int> billingDay = GeneratedColumn<int>(
    'billing_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feeRatePercentMeta = const VerificationMeta(
    'feeRatePercent',
  );
  @override
  late final GeneratedColumn<double> feeRatePercent = GeneratedColumn<double>(
    'fee_rate_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupCode,
    name,
    amount,
    currency,
    billingDay,
    period,
    category,
    memo,
    feeRatePercent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSubscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_code')) {
      context.handle(
        _groupCodeMeta,
        groupCode.isAcceptableOrUnknown(data['group_code']!, _groupCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_groupCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('billing_day')) {
      context.handle(
        _billingDayMeta,
        billingDay.isAcceptableOrUnknown(data['billing_day']!, _billingDayMeta),
      );
    } else if (isInserting) {
      context.missing(_billingDayMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('fee_rate_percent')) {
      context.handle(
        _feeRatePercentMeta,
        feeRatePercent.isAcceptableOrUnknown(
          data['fee_rate_percent']!,
          _feeRatePercentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSubscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSubscription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      billingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_day'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      feeRatePercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fee_rate_percent'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserSubscriptionsTable createAlias(String alias) {
    return $UserSubscriptionsTable(attachedDatabase, alias);
  }
}

class UserSubscription extends DataClass
    implements Insertable<UserSubscription> {
  final String id;
  final String groupCode;
  final String name;
  final double amount;
  final String currency;
  final int billingDay;
  final String period;
  final String? category;
  final String? memo;
  final double? feeRatePercent;
  final DateTime createdAt;
  const UserSubscription({
    required this.id,
    required this.groupCode,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingDay,
    required this.period,
    this.category,
    this.memo,
    this.feeRatePercent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_code'] = Variable<String>(groupCode);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['billing_day'] = Variable<int>(billingDay);
    map['period'] = Variable<String>(period);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || feeRatePercent != null) {
      map['fee_rate_percent'] = Variable<double>(feeRatePercent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return UserSubscriptionsCompanion(
      id: Value(id),
      groupCode: Value(groupCode),
      name: Value(name),
      amount: Value(amount),
      currency: Value(currency),
      billingDay: Value(billingDay),
      period: Value(period),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      feeRatePercent: feeRatePercent == null && nullToAbsent
          ? const Value.absent()
          : Value(feeRatePercent),
      createdAt: Value(createdAt),
    );
  }

  factory UserSubscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSubscription(
      id: serializer.fromJson<String>(json['id']),
      groupCode: serializer.fromJson<String>(json['groupCode']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      billingDay: serializer.fromJson<int>(json['billingDay']),
      period: serializer.fromJson<String>(json['period']),
      category: serializer.fromJson<String?>(json['category']),
      memo: serializer.fromJson<String?>(json['memo']),
      feeRatePercent: serializer.fromJson<double?>(json['feeRatePercent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupCode': serializer.toJson<String>(groupCode),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'billingDay': serializer.toJson<int>(billingDay),
      'period': serializer.toJson<String>(period),
      'category': serializer.toJson<String?>(category),
      'memo': serializer.toJson<String?>(memo),
      'feeRatePercent': serializer.toJson<double?>(feeRatePercent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserSubscription copyWith({
    String? id,
    String? groupCode,
    String? name,
    double? amount,
    String? currency,
    int? billingDay,
    String? period,
    Value<String?> category = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<double?> feeRatePercent = const Value.absent(),
    DateTime? createdAt,
  }) => UserSubscription(
    id: id ?? this.id,
    groupCode: groupCode ?? this.groupCode,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    billingDay: billingDay ?? this.billingDay,
    period: period ?? this.period,
    category: category.present ? category.value : this.category,
    memo: memo.present ? memo.value : this.memo,
    feeRatePercent: feeRatePercent.present
        ? feeRatePercent.value
        : this.feeRatePercent,
    createdAt: createdAt ?? this.createdAt,
  );
  UserSubscription copyWithCompanion(UserSubscriptionsCompanion data) {
    return UserSubscription(
      id: data.id.present ? data.id.value : this.id,
      groupCode: data.groupCode.present ? data.groupCode.value : this.groupCode,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingDay: data.billingDay.present
          ? data.billingDay.value
          : this.billingDay,
      period: data.period.present ? data.period.value : this.period,
      category: data.category.present ? data.category.value : this.category,
      memo: data.memo.present ? data.memo.value : this.memo,
      feeRatePercent: data.feeRatePercent.present
          ? data.feeRatePercent.value
          : this.feeRatePercent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSubscription(')
          ..write('id: $id, ')
          ..write('groupCode: $groupCode, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('billingDay: $billingDay, ')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('feeRatePercent: $feeRatePercent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupCode,
    name,
    amount,
    currency,
    billingDay,
    period,
    category,
    memo,
    feeRatePercent,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSubscription &&
          other.id == this.id &&
          other.groupCode == this.groupCode &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.billingDay == this.billingDay &&
          other.period == this.period &&
          other.category == this.category &&
          other.memo == this.memo &&
          other.feeRatePercent == this.feeRatePercent &&
          other.createdAt == this.createdAt);
}

class UserSubscriptionsCompanion extends UpdateCompanion<UserSubscription> {
  final Value<String> id;
  final Value<String> groupCode;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> currency;
  final Value<int> billingDay;
  final Value<String> period;
  final Value<String?> category;
  final Value<String?> memo;
  final Value<double?> feeRatePercent;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserSubscriptionsCompanion({
    this.id = const Value.absent(),
    this.groupCode = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingDay = const Value.absent(),
    this.period = const Value.absent(),
    this.category = const Value.absent(),
    this.memo = const Value.absent(),
    this.feeRatePercent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSubscriptionsCompanion.insert({
    required String id,
    required String groupCode,
    required String name,
    required double amount,
    required String currency,
    required int billingDay,
    required String period,
    this.category = const Value.absent(),
    this.memo = const Value.absent(),
    this.feeRatePercent = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupCode = Value(groupCode),
       name = Value(name),
       amount = Value(amount),
       currency = Value(currency),
       billingDay = Value(billingDay),
       period = Value(period),
       createdAt = Value(createdAt);
  static Insertable<UserSubscription> custom({
    Expression<String>? id,
    Expression<String>? groupCode,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<int>? billingDay,
    Expression<String>? period,
    Expression<String>? category,
    Expression<String>? memo,
    Expression<double>? feeRatePercent,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupCode != null) 'group_code': groupCode,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (billingDay != null) 'billing_day': billingDay,
      if (period != null) 'period': period,
      if (category != null) 'category': category,
      if (memo != null) 'memo': memo,
      if (feeRatePercent != null) 'fee_rate_percent': feeRatePercent,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSubscriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupCode,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? currency,
    Value<int>? billingDay,
    Value<String>? period,
    Value<String?>? category,
    Value<String?>? memo,
    Value<double?>? feeRatePercent,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserSubscriptionsCompanion(
      id: id ?? this.id,
      groupCode: groupCode ?? this.groupCode,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      billingDay: billingDay ?? this.billingDay,
      period: period ?? this.period,
      category: category ?? this.category,
      memo: memo ?? this.memo,
      feeRatePercent: feeRatePercent ?? this.feeRatePercent,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupCode.present) {
      map['group_code'] = Variable<String>(groupCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingDay.present) {
      map['billing_day'] = Variable<int>(billingDay.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (feeRatePercent.present) {
      map['fee_rate_percent'] = Variable<double>(feeRatePercent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('groupCode: $groupCode, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('billingDay: $billingDay, ')
          ..write('period: $period, ')
          ..write('category: $category, ')
          ..write('memo: $memo, ')
          ..write('feeRatePercent: $feeRatePercent, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FxRatesDailyTable extends FxRatesDaily
    with TableInfo<$FxRatesDailyTable, FxRatesDailyData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FxRatesDailyTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usdMeta = const VerificationMeta('usd');
  @override
  late final GeneratedColumn<double> usd = GeneratedColumn<double>(
    'usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _krwMeta = const VerificationMeta('krw');
  @override
  late final GeneratedColumn<double> krw = GeneratedColumn<double>(
    'krw',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eurMeta = const VerificationMeta('eur');
  @override
  late final GeneratedColumn<double> eur = GeneratedColumn<double>(
    'eur',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jpyMeta = const VerificationMeta('jpy');
  @override
  late final GeneratedColumn<double> jpy = GeneratedColumn<double>(
    'jpy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    usd,
    krw,
    eur,
    jpy,
    fetchedAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fx_rates_daily';
  @override
  VerificationContext validateIntegrity(
    Insertable<FxRatesDailyData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('usd')) {
      context.handle(
        _usdMeta,
        usd.isAcceptableOrUnknown(data['usd']!, _usdMeta),
      );
    } else if (isInserting) {
      context.missing(_usdMeta);
    }
    if (data.containsKey('krw')) {
      context.handle(
        _krwMeta,
        krw.isAcceptableOrUnknown(data['krw']!, _krwMeta),
      );
    } else if (isInserting) {
      context.missing(_krwMeta);
    }
    if (data.containsKey('eur')) {
      context.handle(
        _eurMeta,
        eur.isAcceptableOrUnknown(data['eur']!, _eurMeta),
      );
    } else if (isInserting) {
      context.missing(_eurMeta);
    }
    if (data.containsKey('jpy')) {
      context.handle(
        _jpyMeta,
        jpy.isAcceptableOrUnknown(data['jpy']!, _jpyMeta),
      );
    } else if (isInserting) {
      context.missing(_jpyMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  FxRatesDailyData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FxRatesDailyData(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      usd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd'],
      )!,
      krw: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}krw'],
      )!,
      eur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}eur'],
      )!,
      jpy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jpy'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $FxRatesDailyTable createAlias(String alias) {
    return $FxRatesDailyTable(attachedDatabase, alias);
  }
}

class FxRatesDailyData extends DataClass
    implements Insertable<FxRatesDailyData> {
  final String dateKey;
  final double usd;
  final double krw;
  final double eur;
  final double jpy;
  final DateTime fetchedAt;
  final String source;
  const FxRatesDailyData({
    required this.dateKey,
    required this.usd,
    required this.krw,
    required this.eur,
    required this.jpy,
    required this.fetchedAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['usd'] = Variable<double>(usd);
    map['krw'] = Variable<double>(krw);
    map['eur'] = Variable<double>(eur);
    map['jpy'] = Variable<double>(jpy);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  FxRatesDailyCompanion toCompanion(bool nullToAbsent) {
    return FxRatesDailyCompanion(
      dateKey: Value(dateKey),
      usd: Value(usd),
      krw: Value(krw),
      eur: Value(eur),
      jpy: Value(jpy),
      fetchedAt: Value(fetchedAt),
      source: Value(source),
    );
  }

  factory FxRatesDailyData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FxRatesDailyData(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      usd: serializer.fromJson<double>(json['usd']),
      krw: serializer.fromJson<double>(json['krw']),
      eur: serializer.fromJson<double>(json['eur']),
      jpy: serializer.fromJson<double>(json['jpy']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'usd': serializer.toJson<double>(usd),
      'krw': serializer.toJson<double>(krw),
      'eur': serializer.toJson<double>(eur),
      'jpy': serializer.toJson<double>(jpy),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  FxRatesDailyData copyWith({
    String? dateKey,
    double? usd,
    double? krw,
    double? eur,
    double? jpy,
    DateTime? fetchedAt,
    String? source,
  }) => FxRatesDailyData(
    dateKey: dateKey ?? this.dateKey,
    usd: usd ?? this.usd,
    krw: krw ?? this.krw,
    eur: eur ?? this.eur,
    jpy: jpy ?? this.jpy,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    source: source ?? this.source,
  );
  FxRatesDailyData copyWithCompanion(FxRatesDailyCompanion data) {
    return FxRatesDailyData(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      usd: data.usd.present ? data.usd.value : this.usd,
      krw: data.krw.present ? data.krw.value : this.krw,
      eur: data.eur.present ? data.eur.value : this.eur,
      jpy: data.jpy.present ? data.jpy.value : this.jpy,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FxRatesDailyData(')
          ..write('dateKey: $dateKey, ')
          ..write('usd: $usd, ')
          ..write('krw: $krw, ')
          ..write('eur: $eur, ')
          ..write('jpy: $jpy, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(dateKey, usd, krw, eur, jpy, fetchedAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FxRatesDailyData &&
          other.dateKey == this.dateKey &&
          other.usd == this.usd &&
          other.krw == this.krw &&
          other.eur == this.eur &&
          other.jpy == this.jpy &&
          other.fetchedAt == this.fetchedAt &&
          other.source == this.source);
}

class FxRatesDailyCompanion extends UpdateCompanion<FxRatesDailyData> {
  final Value<String> dateKey;
  final Value<double> usd;
  final Value<double> krw;
  final Value<double> eur;
  final Value<double> jpy;
  final Value<DateTime> fetchedAt;
  final Value<String> source;
  final Value<int> rowid;
  const FxRatesDailyCompanion({
    this.dateKey = const Value.absent(),
    this.usd = const Value.absent(),
    this.krw = const Value.absent(),
    this.eur = const Value.absent(),
    this.jpy = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FxRatesDailyCompanion.insert({
    required String dateKey,
    required double usd,
    required double krw,
    required double eur,
    required double jpy,
    required DateTime fetchedAt,
    required String source,
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       usd = Value(usd),
       krw = Value(krw),
       eur = Value(eur),
       jpy = Value(jpy),
       fetchedAt = Value(fetchedAt),
       source = Value(source);
  static Insertable<FxRatesDailyData> custom({
    Expression<String>? dateKey,
    Expression<double>? usd,
    Expression<double>? krw,
    Expression<double>? eur,
    Expression<double>? jpy,
    Expression<DateTime>? fetchedAt,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (usd != null) 'usd': usd,
      if (krw != null) 'krw': krw,
      if (eur != null) 'eur': eur,
      if (jpy != null) 'jpy': jpy,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FxRatesDailyCompanion copyWith({
    Value<String>? dateKey,
    Value<double>? usd,
    Value<double>? krw,
    Value<double>? eur,
    Value<double>? jpy,
    Value<DateTime>? fetchedAt,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return FxRatesDailyCompanion(
      dateKey: dateKey ?? this.dateKey,
      usd: usd ?? this.usd,
      krw: krw ?? this.krw,
      eur: eur ?? this.eur,
      jpy: jpy ?? this.jpy,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (usd.present) {
      map['usd'] = Variable<double>(usd.value);
    }
    if (krw.present) {
      map['krw'] = Variable<double>(krw.value);
    }
    if (eur.present) {
      map['eur'] = Variable<double>(eur.value);
    }
    if (jpy.present) {
      map['jpy'] = Variable<double>(jpy.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FxRatesDailyCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('usd: $usd, ')
          ..write('krw: $krw, ')
          ..write('eur: $eur, ')
          ..write('jpy: $jpy, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresetCacheTable extends PresetCache
    with TableInfo<$PresetCacheTable, PresetCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _brandKeyMeta = const VerificationMeta(
    'brandKey',
  );
  @override
  late final GeneratedColumn<String> brandKey = GeneratedColumn<String>(
    'brand_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameKoMeta = const VerificationMeta(
    'displayNameKo',
  );
  @override
  late final GeneratedColumn<String> displayNameKo = GeneratedColumn<String>(
    'display_name_ko',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameEnMeta = const VerificationMeta(
    'displayNameEn',
  );
  @override
  late final GeneratedColumn<String> displayNameEn = GeneratedColumn<String>(
    'display_name_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultCurrencyMeta = const VerificationMeta(
    'defaultCurrency',
  );
  @override
  late final GeneratedColumn<String> defaultCurrency = GeneratedColumn<String>(
    'default_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultPeriodMeta = const VerificationMeta(
    'defaultPeriod',
  );
  @override
  late final GeneratedColumn<String> defaultPeriod = GeneratedColumn<String>(
    'default_period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasesMeta = const VerificationMeta(
    'aliases',
  );
  @override
  late final GeneratedColumn<String> aliases = GeneratedColumn<String>(
    'aliases',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    brandKey,
    displayNameKo,
    displayNameEn,
    category,
    defaultCurrency,
    defaultPeriod,
    aliases,
    notes,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preset_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PresetCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('brand_key')) {
      context.handle(
        _brandKeyMeta,
        brandKey.isAcceptableOrUnknown(data['brand_key']!, _brandKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_brandKeyMeta);
    }
    if (data.containsKey('display_name_ko')) {
      context.handle(
        _displayNameKoMeta,
        displayNameKo.isAcceptableOrUnknown(
          data['display_name_ko']!,
          _displayNameKoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameKoMeta);
    }
    if (data.containsKey('display_name_en')) {
      context.handle(
        _displayNameEnMeta,
        displayNameEn.isAcceptableOrUnknown(
          data['display_name_en']!,
          _displayNameEnMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_currency')) {
      context.handle(
        _defaultCurrencyMeta,
        defaultCurrency.isAcceptableOrUnknown(
          data['default_currency']!,
          _defaultCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultCurrencyMeta);
    }
    if (data.containsKey('default_period')) {
      context.handle(
        _defaultPeriodMeta,
        defaultPeriod.isAcceptableOrUnknown(
          data['default_period']!,
          _defaultPeriodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defaultPeriodMeta);
    }
    if (data.containsKey('aliases')) {
      context.handle(
        _aliasesMeta,
        aliases.isAcceptableOrUnknown(data['aliases']!, _aliasesMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {brandKey};
  @override
  PresetCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PresetCacheData(
      brandKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_key'],
      )!,
      displayNameKo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name_ko'],
      )!,
      displayNameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name_en'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      defaultCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_currency'],
      )!,
      defaultPeriod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_period'],
      )!,
      aliases: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aliases'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PresetCacheTable createAlias(String alias) {
    return $PresetCacheTable(attachedDatabase, alias);
  }
}

class PresetCacheData extends DataClass implements Insertable<PresetCacheData> {
  final String brandKey;
  final String displayNameKo;
  final String? displayNameEn;
  final String category;
  final String defaultCurrency;
  final String defaultPeriod;
  final String? aliases;
  final String? notes;
  final DateTime cachedAt;
  const PresetCacheData({
    required this.brandKey,
    required this.displayNameKo,
    this.displayNameEn,
    required this.category,
    required this.defaultCurrency,
    required this.defaultPeriod,
    this.aliases,
    this.notes,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['brand_key'] = Variable<String>(brandKey);
    map['display_name_ko'] = Variable<String>(displayNameKo);
    if (!nullToAbsent || displayNameEn != null) {
      map['display_name_en'] = Variable<String>(displayNameEn);
    }
    map['category'] = Variable<String>(category);
    map['default_currency'] = Variable<String>(defaultCurrency);
    map['default_period'] = Variable<String>(defaultPeriod);
    if (!nullToAbsent || aliases != null) {
      map['aliases'] = Variable<String>(aliases);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PresetCacheCompanion toCompanion(bool nullToAbsent) {
    return PresetCacheCompanion(
      brandKey: Value(brandKey),
      displayNameKo: Value(displayNameKo),
      displayNameEn: displayNameEn == null && nullToAbsent
          ? const Value.absent()
          : Value(displayNameEn),
      category: Value(category),
      defaultCurrency: Value(defaultCurrency),
      defaultPeriod: Value(defaultPeriod),
      aliases: aliases == null && nullToAbsent
          ? const Value.absent()
          : Value(aliases),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      cachedAt: Value(cachedAt),
    );
  }

  factory PresetCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PresetCacheData(
      brandKey: serializer.fromJson<String>(json['brandKey']),
      displayNameKo: serializer.fromJson<String>(json['displayNameKo']),
      displayNameEn: serializer.fromJson<String?>(json['displayNameEn']),
      category: serializer.fromJson<String>(json['category']),
      defaultCurrency: serializer.fromJson<String>(json['defaultCurrency']),
      defaultPeriod: serializer.fromJson<String>(json['defaultPeriod']),
      aliases: serializer.fromJson<String?>(json['aliases']),
      notes: serializer.fromJson<String?>(json['notes']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'brandKey': serializer.toJson<String>(brandKey),
      'displayNameKo': serializer.toJson<String>(displayNameKo),
      'displayNameEn': serializer.toJson<String?>(displayNameEn),
      'category': serializer.toJson<String>(category),
      'defaultCurrency': serializer.toJson<String>(defaultCurrency),
      'defaultPeriod': serializer.toJson<String>(defaultPeriod),
      'aliases': serializer.toJson<String?>(aliases),
      'notes': serializer.toJson<String?>(notes),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PresetCacheData copyWith({
    String? brandKey,
    String? displayNameKo,
    Value<String?> displayNameEn = const Value.absent(),
    String? category,
    String? defaultCurrency,
    String? defaultPeriod,
    Value<String?> aliases = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? cachedAt,
  }) => PresetCacheData(
    brandKey: brandKey ?? this.brandKey,
    displayNameKo: displayNameKo ?? this.displayNameKo,
    displayNameEn: displayNameEn.present
        ? displayNameEn.value
        : this.displayNameEn,
    category: category ?? this.category,
    defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    defaultPeriod: defaultPeriod ?? this.defaultPeriod,
    aliases: aliases.present ? aliases.value : this.aliases,
    notes: notes.present ? notes.value : this.notes,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PresetCacheData copyWithCompanion(PresetCacheCompanion data) {
    return PresetCacheData(
      brandKey: data.brandKey.present ? data.brandKey.value : this.brandKey,
      displayNameKo: data.displayNameKo.present
          ? data.displayNameKo.value
          : this.displayNameKo,
      displayNameEn: data.displayNameEn.present
          ? data.displayNameEn.value
          : this.displayNameEn,
      category: data.category.present ? data.category.value : this.category,
      defaultCurrency: data.defaultCurrency.present
          ? data.defaultCurrency.value
          : this.defaultCurrency,
      defaultPeriod: data.defaultPeriod.present
          ? data.defaultPeriod.value
          : this.defaultPeriod,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      notes: data.notes.present ? data.notes.value : this.notes,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PresetCacheData(')
          ..write('brandKey: $brandKey, ')
          ..write('displayNameKo: $displayNameKo, ')
          ..write('displayNameEn: $displayNameEn, ')
          ..write('category: $category, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('defaultPeriod: $defaultPeriod, ')
          ..write('aliases: $aliases, ')
          ..write('notes: $notes, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    brandKey,
    displayNameKo,
    displayNameEn,
    category,
    defaultCurrency,
    defaultPeriod,
    aliases,
    notes,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PresetCacheData &&
          other.brandKey == this.brandKey &&
          other.displayNameKo == this.displayNameKo &&
          other.displayNameEn == this.displayNameEn &&
          other.category == this.category &&
          other.defaultCurrency == this.defaultCurrency &&
          other.defaultPeriod == this.defaultPeriod &&
          other.aliases == this.aliases &&
          other.notes == this.notes &&
          other.cachedAt == this.cachedAt);
}

class PresetCacheCompanion extends UpdateCompanion<PresetCacheData> {
  final Value<String> brandKey;
  final Value<String> displayNameKo;
  final Value<String?> displayNameEn;
  final Value<String> category;
  final Value<String> defaultCurrency;
  final Value<String> defaultPeriod;
  final Value<String?> aliases;
  final Value<String?> notes;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PresetCacheCompanion({
    this.brandKey = const Value.absent(),
    this.displayNameKo = const Value.absent(),
    this.displayNameEn = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultCurrency = const Value.absent(),
    this.defaultPeriod = const Value.absent(),
    this.aliases = const Value.absent(),
    this.notes = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresetCacheCompanion.insert({
    required String brandKey,
    required String displayNameKo,
    this.displayNameEn = const Value.absent(),
    required String category,
    required String defaultCurrency,
    required String defaultPeriod,
    this.aliases = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : brandKey = Value(brandKey),
       displayNameKo = Value(displayNameKo),
       category = Value(category),
       defaultCurrency = Value(defaultCurrency),
       defaultPeriod = Value(defaultPeriod),
       cachedAt = Value(cachedAt);
  static Insertable<PresetCacheData> custom({
    Expression<String>? brandKey,
    Expression<String>? displayNameKo,
    Expression<String>? displayNameEn,
    Expression<String>? category,
    Expression<String>? defaultCurrency,
    Expression<String>? defaultPeriod,
    Expression<String>? aliases,
    Expression<String>? notes,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (brandKey != null) 'brand_key': brandKey,
      if (displayNameKo != null) 'display_name_ko': displayNameKo,
      if (displayNameEn != null) 'display_name_en': displayNameEn,
      if (category != null) 'category': category,
      if (defaultCurrency != null) 'default_currency': defaultCurrency,
      if (defaultPeriod != null) 'default_period': defaultPeriod,
      if (aliases != null) 'aliases': aliases,
      if (notes != null) 'notes': notes,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresetCacheCompanion copyWith({
    Value<String>? brandKey,
    Value<String>? displayNameKo,
    Value<String?>? displayNameEn,
    Value<String>? category,
    Value<String>? defaultCurrency,
    Value<String>? defaultPeriod,
    Value<String?>? aliases,
    Value<String?>? notes,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return PresetCacheCompanion(
      brandKey: brandKey ?? this.brandKey,
      displayNameKo: displayNameKo ?? this.displayNameKo,
      displayNameEn: displayNameEn ?? this.displayNameEn,
      category: category ?? this.category,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      defaultPeriod: defaultPeriod ?? this.defaultPeriod,
      aliases: aliases ?? this.aliases,
      notes: notes ?? this.notes,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (brandKey.present) {
      map['brand_key'] = Variable<String>(brandKey.value);
    }
    if (displayNameKo.present) {
      map['display_name_ko'] = Variable<String>(displayNameKo.value);
    }
    if (displayNameEn.present) {
      map['display_name_en'] = Variable<String>(displayNameEn.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultCurrency.present) {
      map['default_currency'] = Variable<String>(defaultCurrency.value);
    }
    if (defaultPeriod.present) {
      map['default_period'] = Variable<String>(defaultPeriod.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(aliases.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetCacheCompanion(')
          ..write('brandKey: $brandKey, ')
          ..write('displayNameKo: $displayNameKo, ')
          ..write('displayNameEn: $displayNameEn, ')
          ..write('category: $category, ')
          ..write('defaultCurrency: $defaultCurrency, ')
          ..write('defaultPeriod: $defaultPeriod, ')
          ..write('aliases: $aliases, ')
          ..write('notes: $notes, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionGroupsTable extends SubscriptionGroups
    with TableInfo<$SubscriptionGroupsTable, SubscriptionGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _membersMeta = const VerificationMeta(
    'members',
  );
  @override
  late final GeneratedColumn<String> members = GeneratedColumn<String>(
    'members',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    code,
    name,
    displayName,
    ownerId,
    members,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscription_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('members')) {
      context.handle(
        _membersMeta,
        members.isAcceptableOrUnknown(data['members']!, _membersMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  SubscriptionGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionGroup(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      members: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}members'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $SubscriptionGroupsTable createAlias(String alias) {
    return $SubscriptionGroupsTable(attachedDatabase, alias);
  }
}

class SubscriptionGroup extends DataClass
    implements Insertable<SubscriptionGroup> {
  final String code;
  final String name;
  final String? displayName;
  final String ownerId;
  final String members;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const SubscriptionGroup({
    required this.code,
    required this.name,
    this.displayName,
    required this.ownerId,
    required this.members,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['owner_id'] = Variable<String>(ownerId);
    map['members'] = Variable<String>(members);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SubscriptionGroupsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionGroupsCompanion(
      code: Value(code),
      name: Value(name),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      ownerId: Value(ownerId),
      members: Value(members),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SubscriptionGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionGroup(
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      members: serializer.fromJson<String>(json['members']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String?>(displayName),
      'ownerId': serializer.toJson<String>(ownerId),
      'members': serializer.toJson<String>(members),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SubscriptionGroup copyWith({
    String? code,
    String? name,
    Value<String?> displayName = const Value.absent(),
    String? ownerId,
    String? members,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => SubscriptionGroup(
    code: code ?? this.code,
    name: name ?? this.name,
    displayName: displayName.present ? displayName.value : this.displayName,
    ownerId: ownerId ?? this.ownerId,
    members: members ?? this.members,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  SubscriptionGroup copyWithCompanion(SubscriptionGroupsCompanion data) {
    return SubscriptionGroup(
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      members: data.members.present ? data.members.value : this.members,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionGroup(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('ownerId: $ownerId, ')
          ..write('members: $members, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    code,
    name,
    displayName,
    ownerId,
    members,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionGroup &&
          other.code == this.code &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.ownerId == this.ownerId &&
          other.members == this.members &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionGroupsCompanion extends UpdateCompanion<SubscriptionGroup> {
  final Value<String> code;
  final Value<String> name;
  final Value<String?> displayName;
  final Value<String> ownerId;
  final Value<String> members;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const SubscriptionGroupsCompanion({
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.members = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionGroupsCompanion.insert({
    required String code,
    required String name,
    this.displayName = const Value.absent(),
    required String ownerId,
    this.members = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt);
  static Insertable<SubscriptionGroup> custom({
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? ownerId,
    Expression<String>? members,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (ownerId != null) 'owner_id': ownerId,
      if (members != null) 'members': members,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionGroupsCompanion copyWith({
    Value<String>? code,
    Value<String>? name,
    Value<String?>? displayName,
    Value<String>? ownerId,
    Value<String>? members,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubscriptionGroupsCompanion(
      code: code ?? this.code,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      ownerId: ownerId ?? this.ownerId,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (members.present) {
      map['members'] = Variable<String>(members.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionGroupsCompanion(')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('ownerId: $ownerId, ')
          ..write('members: $members, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentLogsTable extends PaymentLogs
    with TableInfo<$PaymentLogsTable, PaymentLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subscriptionIdMeta = const VerificationMeta(
    'subscriptionId',
  );
  @override
  late final GeneratedColumn<String> subscriptionId = GeneratedColumn<String>(
    'subscription_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleKeyMeta = const VerificationMeta(
    'cycleKey',
  );
  @override
  late final GeneratedColumn<String> cycleKey = GeneratedColumn<String>(
    'cycle_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usdAmountMeta = const VerificationMeta(
    'usdAmount',
  );
  @override
  late final GeneratedColumn<double> usdAmount = GeneratedColumn<double>(
    'usd_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fxRateAppliedMeta = const VerificationMeta(
    'fxRateApplied',
  );
  @override
  late final GeneratedColumn<double> fxRateApplied = GeneratedColumn<double>(
    'fx_rate_applied',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _krwFinalMeta = const VerificationMeta(
    'krwFinal',
  );
  @override
  late final GeneratedColumn<double> krwFinal = GeneratedColumn<double>(
    'krw_final',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subscriptionId,
    cycleKey,
    paidAt,
    usdAmount,
    fxRateApplied,
    krwFinal,
    memo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subscription_id')) {
      context.handle(
        _subscriptionIdMeta,
        subscriptionId.isAcceptableOrUnknown(
          data['subscription_id']!,
          _subscriptionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriptionIdMeta);
    }
    if (data.containsKey('cycle_key')) {
      context.handle(
        _cycleKeyMeta,
        cycleKey.isAcceptableOrUnknown(data['cycle_key']!, _cycleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleKeyMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('usd_amount')) {
      context.handle(
        _usdAmountMeta,
        usdAmount.isAcceptableOrUnknown(data['usd_amount']!, _usdAmountMeta),
      );
    }
    if (data.containsKey('fx_rate_applied')) {
      context.handle(
        _fxRateAppliedMeta,
        fxRateApplied.isAcceptableOrUnknown(
          data['fx_rate_applied']!,
          _fxRateAppliedMeta,
        ),
      );
    }
    if (data.containsKey('krw_final')) {
      context.handle(
        _krwFinalMeta,
        krwFinal.isAcceptableOrUnknown(data['krw_final']!, _krwFinalMeta),
      );
    } else if (isInserting) {
      context.missing(_krwFinalMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subscriptionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_id'],
      )!,
      cycleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_key'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      usdAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usd_amount'],
      ),
      fxRateApplied: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fx_rate_applied'],
      ),
      krwFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}krw_final'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentLogsTable createAlias(String alias) {
    return $PaymentLogsTable(attachedDatabase, alias);
  }
}

class PaymentLog extends DataClass implements Insertable<PaymentLog> {
  final String id;
  final String subscriptionId;
  final String cycleKey;
  final DateTime paidAt;
  final double? usdAmount;
  final double? fxRateApplied;
  final double krwFinal;
  final String? memo;
  final DateTime createdAt;
  const PaymentLog({
    required this.id,
    required this.subscriptionId,
    required this.cycleKey,
    required this.paidAt,
    this.usdAmount,
    this.fxRateApplied,
    required this.krwFinal,
    this.memo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subscription_id'] = Variable<String>(subscriptionId);
    map['cycle_key'] = Variable<String>(cycleKey);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || usdAmount != null) {
      map['usd_amount'] = Variable<double>(usdAmount);
    }
    if (!nullToAbsent || fxRateApplied != null) {
      map['fx_rate_applied'] = Variable<double>(fxRateApplied);
    }
    map['krw_final'] = Variable<double>(krwFinal);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentLogsCompanion toCompanion(bool nullToAbsent) {
    return PaymentLogsCompanion(
      id: Value(id),
      subscriptionId: Value(subscriptionId),
      cycleKey: Value(cycleKey),
      paidAt: Value(paidAt),
      usdAmount: usdAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(usdAmount),
      fxRateApplied: fxRateApplied == null && nullToAbsent
          ? const Value.absent()
          : Value(fxRateApplied),
      krwFinal: Value(krwFinal),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentLog(
      id: serializer.fromJson<String>(json['id']),
      subscriptionId: serializer.fromJson<String>(json['subscriptionId']),
      cycleKey: serializer.fromJson<String>(json['cycleKey']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      usdAmount: serializer.fromJson<double?>(json['usdAmount']),
      fxRateApplied: serializer.fromJson<double?>(json['fxRateApplied']),
      krwFinal: serializer.fromJson<double>(json['krwFinal']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subscriptionId': serializer.toJson<String>(subscriptionId),
      'cycleKey': serializer.toJson<String>(cycleKey),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'usdAmount': serializer.toJson<double?>(usdAmount),
      'fxRateApplied': serializer.toJson<double?>(fxRateApplied),
      'krwFinal': serializer.toJson<double>(krwFinal),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentLog copyWith({
    String? id,
    String? subscriptionId,
    String? cycleKey,
    DateTime? paidAt,
    Value<double?> usdAmount = const Value.absent(),
    Value<double?> fxRateApplied = const Value.absent(),
    double? krwFinal,
    Value<String?> memo = const Value.absent(),
    DateTime? createdAt,
  }) => PaymentLog(
    id: id ?? this.id,
    subscriptionId: subscriptionId ?? this.subscriptionId,
    cycleKey: cycleKey ?? this.cycleKey,
    paidAt: paidAt ?? this.paidAt,
    usdAmount: usdAmount.present ? usdAmount.value : this.usdAmount,
    fxRateApplied: fxRateApplied.present
        ? fxRateApplied.value
        : this.fxRateApplied,
    krwFinal: krwFinal ?? this.krwFinal,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentLog copyWithCompanion(PaymentLogsCompanion data) {
    return PaymentLog(
      id: data.id.present ? data.id.value : this.id,
      subscriptionId: data.subscriptionId.present
          ? data.subscriptionId.value
          : this.subscriptionId,
      cycleKey: data.cycleKey.present ? data.cycleKey.value : this.cycleKey,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      usdAmount: data.usdAmount.present ? data.usdAmount.value : this.usdAmount,
      fxRateApplied: data.fxRateApplied.present
          ? data.fxRateApplied.value
          : this.fxRateApplied,
      krwFinal: data.krwFinal.present ? data.krwFinal.value : this.krwFinal,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentLog(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('cycleKey: $cycleKey, ')
          ..write('paidAt: $paidAt, ')
          ..write('usdAmount: $usdAmount, ')
          ..write('fxRateApplied: $fxRateApplied, ')
          ..write('krwFinal: $krwFinal, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subscriptionId,
    cycleKey,
    paidAt,
    usdAmount,
    fxRateApplied,
    krwFinal,
    memo,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentLog &&
          other.id == this.id &&
          other.subscriptionId == this.subscriptionId &&
          other.cycleKey == this.cycleKey &&
          other.paidAt == this.paidAt &&
          other.usdAmount == this.usdAmount &&
          other.fxRateApplied == this.fxRateApplied &&
          other.krwFinal == this.krwFinal &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt);
}

class PaymentLogsCompanion extends UpdateCompanion<PaymentLog> {
  final Value<String> id;
  final Value<String> subscriptionId;
  final Value<String> cycleKey;
  final Value<DateTime> paidAt;
  final Value<double?> usdAmount;
  final Value<double?> fxRateApplied;
  final Value<double> krwFinal;
  final Value<String?> memo;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PaymentLogsCompanion({
    this.id = const Value.absent(),
    this.subscriptionId = const Value.absent(),
    this.cycleKey = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.usdAmount = const Value.absent(),
    this.fxRateApplied = const Value.absent(),
    this.krwFinal = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentLogsCompanion.insert({
    required String id,
    required String subscriptionId,
    required String cycleKey,
    required DateTime paidAt,
    this.usdAmount = const Value.absent(),
    this.fxRateApplied = const Value.absent(),
    required double krwFinal,
    this.memo = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subscriptionId = Value(subscriptionId),
       cycleKey = Value(cycleKey),
       paidAt = Value(paidAt),
       krwFinal = Value(krwFinal),
       createdAt = Value(createdAt);
  static Insertable<PaymentLog> custom({
    Expression<String>? id,
    Expression<String>? subscriptionId,
    Expression<String>? cycleKey,
    Expression<DateTime>? paidAt,
    Expression<double>? usdAmount,
    Expression<double>? fxRateApplied,
    Expression<double>? krwFinal,
    Expression<String>? memo,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (cycleKey != null) 'cycle_key': cycleKey,
      if (paidAt != null) 'paid_at': paidAt,
      if (usdAmount != null) 'usd_amount': usdAmount,
      if (fxRateApplied != null) 'fx_rate_applied': fxRateApplied,
      if (krwFinal != null) 'krw_final': krwFinal,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? subscriptionId,
    Value<String>? cycleKey,
    Value<DateTime>? paidAt,
    Value<double?>? usdAmount,
    Value<double?>? fxRateApplied,
    Value<double>? krwFinal,
    Value<String?>? memo,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PaymentLogsCompanion(
      id: id ?? this.id,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      cycleKey: cycleKey ?? this.cycleKey,
      paidAt: paidAt ?? this.paidAt,
      usdAmount: usdAmount ?? this.usdAmount,
      fxRateApplied: fxRateApplied ?? this.fxRateApplied,
      krwFinal: krwFinal ?? this.krwFinal,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subscriptionId.present) {
      map['subscription_id'] = Variable<String>(subscriptionId.value);
    }
    if (cycleKey.present) {
      map['cycle_key'] = Variable<String>(cycleKey.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (usdAmount.present) {
      map['usd_amount'] = Variable<double>(usdAmount.value);
    }
    if (fxRateApplied.present) {
      map['fx_rate_applied'] = Variable<double>(fxRateApplied.value);
    }
    if (krwFinal.present) {
      map['krw_final'] = Variable<double>(krwFinal.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentLogsCompanion(')
          ..write('id: $id, ')
          ..write('subscriptionId: $subscriptionId, ')
          ..write('cycleKey: $cycleKey, ')
          ..write('paidAt: $paidAt, ')
          ..write('usdAmount: $usdAmount, ')
          ..write('fxRateApplied: $fxRateApplied, ')
          ..write('krwFinal: $krwFinal, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingChangesTable extends PendingChanges
    with TableInfo<$PendingChangesTable, PendingChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entityId,
    entityType,
    action,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId};
  @override
  PendingChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingChange(
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingChangesTable createAlias(String alias) {
    return $PendingChangesTable(attachedDatabase, alias);
  }
}

class PendingChange extends DataClass implements Insertable<PendingChange> {
  final String entityId;
  final String entityType;
  final String action;
  final String payload;
  final DateTime createdAt;
  const PendingChange({
    required this.entityId,
    required this.entityType,
    required this.action,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['entity_type'] = Variable<String>(entityType);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingChangesCompanion toCompanion(bool nullToAbsent) {
    return PendingChangesCompanion(
      entityId: Value(entityId),
      entityType: Value(entityType),
      action: Value(action),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory PendingChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingChange(
      entityId: serializer.fromJson<String>(json['entityId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'entityType': serializer.toJson<String>(entityType),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingChange copyWith({
    String? entityId,
    String? entityType,
    String? action,
    String? payload,
    DateTime? createdAt,
  }) => PendingChange(
    entityId: entityId ?? this.entityId,
    entityType: entityType ?? this.entityType,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingChange copyWithCompanion(PendingChangesCompanion data) {
    return PendingChange(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingChange(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entityId, entityType, action, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingChange &&
          other.entityId == this.entityId &&
          other.entityType == this.entityType &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class PendingChangesCompanion extends UpdateCompanion<PendingChange> {
  final Value<String> entityId;
  final Value<String> entityType;
  final Value<String> action;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingChangesCompanion({
    this.entityId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingChangesCompanion.insert({
    required String entityId,
    required String entityType,
    required String action,
    required String payload,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : entityId = Value(entityId),
       entityType = Value(entityType),
       action = Value(action),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<PendingChange> custom({
    Expression<String>? entityId,
    Expression<String>? entityType,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (entityType != null) 'entity_type': entityType,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingChangesCompanion copyWith({
    Value<String>? entityId,
    Value<String>? entityType,
    Value<String>? action,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingChangesCompanion(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingChangesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserSubscriptionsTable userSubscriptions =
      $UserSubscriptionsTable(this);
  late final $FxRatesDailyTable fxRatesDaily = $FxRatesDailyTable(this);
  late final $PresetCacheTable presetCache = $PresetCacheTable(this);
  late final $SubscriptionGroupsTable subscriptionGroups =
      $SubscriptionGroupsTable(this);
  late final $PaymentLogsTable paymentLogs = $PaymentLogsTable(this);
  late final $PendingChangesTable pendingChanges = $PendingChangesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userSubscriptions,
    fxRatesDaily,
    presetCache,
    subscriptionGroups,
    paymentLogs,
    pendingChanges,
  ];
}

typedef $$UserSubscriptionsTableCreateCompanionBuilder =
    UserSubscriptionsCompanion Function({
      required String id,
      required String groupCode,
      required String name,
      required double amount,
      required String currency,
      required int billingDay,
      required String period,
      Value<String?> category,
      Value<String?> memo,
      Value<double?> feeRatePercent,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$UserSubscriptionsTableUpdateCompanionBuilder =
    UserSubscriptionsCompanion Function({
      Value<String> id,
      Value<String> groupCode,
      Value<String> name,
      Value<double> amount,
      Value<String> currency,
      Value<int> billingDay,
      Value<String> period,
      Value<String?> category,
      Value<String?> memo,
      Value<double?> feeRatePercent,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$UserSubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupCode => $composableBuilder(
    column: $table.groupCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get feeRatePercent => $composableBuilder(
    column: $table.feeRatePercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupCode => $composableBuilder(
    column: $table.groupCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get feeRatePercent => $composableBuilder(
    column: $table.feeRatePercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSubscriptionsTable> {
  $$UserSubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupCode =>
      $composableBuilder(column: $table.groupCode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get billingDay => $composableBuilder(
    column: $table.billingDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<double> get feeRatePercent => $composableBuilder(
    column: $table.feeRatePercent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserSubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSubscriptionsTable,
          UserSubscription,
          $$UserSubscriptionsTableFilterComposer,
          $$UserSubscriptionsTableOrderingComposer,
          $$UserSubscriptionsTableAnnotationComposer,
          $$UserSubscriptionsTableCreateCompanionBuilder,
          $$UserSubscriptionsTableUpdateCompanionBuilder,
          (
            UserSubscription,
            BaseReferences<
              _$AppDatabase,
              $UserSubscriptionsTable,
              UserSubscription
            >,
          ),
          UserSubscription,
          PrefetchHooks Function()
        > {
  $$UserSubscriptionsTableTableManager(
    _$AppDatabase db,
    $UserSubscriptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSubscriptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupCode = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> billingDay = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<double?> feeRatePercent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSubscriptionsCompanion(
                id: id,
                groupCode: groupCode,
                name: name,
                amount: amount,
                currency: currency,
                billingDay: billingDay,
                period: period,
                category: category,
                memo: memo,
                feeRatePercent: feeRatePercent,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupCode,
                required String name,
                required double amount,
                required String currency,
                required int billingDay,
                required String period,
                Value<String?> category = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<double?> feeRatePercent = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSubscriptionsCompanion.insert(
                id: id,
                groupCode: groupCode,
                name: name,
                amount: amount,
                currency: currency,
                billingDay: billingDay,
                period: period,
                category: category,
                memo: memo,
                feeRatePercent: feeRatePercent,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSubscriptionsTable,
      UserSubscription,
      $$UserSubscriptionsTableFilterComposer,
      $$UserSubscriptionsTableOrderingComposer,
      $$UserSubscriptionsTableAnnotationComposer,
      $$UserSubscriptionsTableCreateCompanionBuilder,
      $$UserSubscriptionsTableUpdateCompanionBuilder,
      (
        UserSubscription,
        BaseReferences<
          _$AppDatabase,
          $UserSubscriptionsTable,
          UserSubscription
        >,
      ),
      UserSubscription,
      PrefetchHooks Function()
    >;
typedef $$FxRatesDailyTableCreateCompanionBuilder =
    FxRatesDailyCompanion Function({
      required String dateKey,
      required double usd,
      required double krw,
      required double eur,
      required double jpy,
      required DateTime fetchedAt,
      required String source,
      Value<int> rowid,
    });
typedef $$FxRatesDailyTableUpdateCompanionBuilder =
    FxRatesDailyCompanion Function({
      Value<String> dateKey,
      Value<double> usd,
      Value<double> krw,
      Value<double> eur,
      Value<double> jpy,
      Value<DateTime> fetchedAt,
      Value<String> source,
      Value<int> rowid,
    });

class $$FxRatesDailyTableFilterComposer
    extends Composer<_$AppDatabase, $FxRatesDailyTable> {
  $$FxRatesDailyTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usd => $composableBuilder(
    column: $table.usd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get krw => $composableBuilder(
    column: $table.krw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get eur => $composableBuilder(
    column: $table.eur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jpy => $composableBuilder(
    column: $table.jpy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FxRatesDailyTableOrderingComposer
    extends Composer<_$AppDatabase, $FxRatesDailyTable> {
  $$FxRatesDailyTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usd => $composableBuilder(
    column: $table.usd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get krw => $composableBuilder(
    column: $table.krw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get eur => $composableBuilder(
    column: $table.eur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jpy => $composableBuilder(
    column: $table.jpy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FxRatesDailyTableAnnotationComposer
    extends Composer<_$AppDatabase, $FxRatesDailyTable> {
  $$FxRatesDailyTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<double> get usd =>
      $composableBuilder(column: $table.usd, builder: (column) => column);

  GeneratedColumn<double> get krw =>
      $composableBuilder(column: $table.krw, builder: (column) => column);

  GeneratedColumn<double> get eur =>
      $composableBuilder(column: $table.eur, builder: (column) => column);

  GeneratedColumn<double> get jpy =>
      $composableBuilder(column: $table.jpy, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$FxRatesDailyTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FxRatesDailyTable,
          FxRatesDailyData,
          $$FxRatesDailyTableFilterComposer,
          $$FxRatesDailyTableOrderingComposer,
          $$FxRatesDailyTableAnnotationComposer,
          $$FxRatesDailyTableCreateCompanionBuilder,
          $$FxRatesDailyTableUpdateCompanionBuilder,
          (
            FxRatesDailyData,
            BaseReferences<_$AppDatabase, $FxRatesDailyTable, FxRatesDailyData>,
          ),
          FxRatesDailyData,
          PrefetchHooks Function()
        > {
  $$FxRatesDailyTableTableManager(_$AppDatabase db, $FxRatesDailyTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FxRatesDailyTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FxRatesDailyTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FxRatesDailyTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<double> usd = const Value.absent(),
                Value<double> krw = const Value.absent(),
                Value<double> eur = const Value.absent(),
                Value<double> jpy = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FxRatesDailyCompanion(
                dateKey: dateKey,
                usd: usd,
                krw: krw,
                eur: eur,
                jpy: jpy,
                fetchedAt: fetchedAt,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required double usd,
                required double krw,
                required double eur,
                required double jpy,
                required DateTime fetchedAt,
                required String source,
                Value<int> rowid = const Value.absent(),
              }) => FxRatesDailyCompanion.insert(
                dateKey: dateKey,
                usd: usd,
                krw: krw,
                eur: eur,
                jpy: jpy,
                fetchedAt: fetchedAt,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FxRatesDailyTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FxRatesDailyTable,
      FxRatesDailyData,
      $$FxRatesDailyTableFilterComposer,
      $$FxRatesDailyTableOrderingComposer,
      $$FxRatesDailyTableAnnotationComposer,
      $$FxRatesDailyTableCreateCompanionBuilder,
      $$FxRatesDailyTableUpdateCompanionBuilder,
      (
        FxRatesDailyData,
        BaseReferences<_$AppDatabase, $FxRatesDailyTable, FxRatesDailyData>,
      ),
      FxRatesDailyData,
      PrefetchHooks Function()
    >;
typedef $$PresetCacheTableCreateCompanionBuilder =
    PresetCacheCompanion Function({
      required String brandKey,
      required String displayNameKo,
      Value<String?> displayNameEn,
      required String category,
      required String defaultCurrency,
      required String defaultPeriod,
      Value<String?> aliases,
      Value<String?> notes,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$PresetCacheTableUpdateCompanionBuilder =
    PresetCacheCompanion Function({
      Value<String> brandKey,
      Value<String> displayNameKo,
      Value<String?> displayNameEn,
      Value<String> category,
      Value<String> defaultCurrency,
      Value<String> defaultPeriod,
      Value<String?> aliases,
      Value<String?> notes,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$PresetCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get brandKey => $composableBuilder(
    column: $table.brandKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayNameKo => $composableBuilder(
    column: $table.displayNameKo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayNameEn => $composableBuilder(
    column: $table.displayNameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultPeriod => $composableBuilder(
    column: $table.defaultPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresetCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get brandKey => $composableBuilder(
    column: $table.brandKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayNameKo => $composableBuilder(
    column: $table.displayNameKo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayNameEn => $composableBuilder(
    column: $table.displayNameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultPeriod => $composableBuilder(
    column: $table.defaultPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresetCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetCacheTable> {
  $$PresetCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get brandKey =>
      $composableBuilder(column: $table.brandKey, builder: (column) => column);

  GeneratedColumn<String> get displayNameKo => $composableBuilder(
    column: $table.displayNameKo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayNameEn => $composableBuilder(
    column: $table.displayNameEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultCurrency => $composableBuilder(
    column: $table.defaultCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultPeriod => $composableBuilder(
    column: $table.defaultPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PresetCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresetCacheTable,
          PresetCacheData,
          $$PresetCacheTableFilterComposer,
          $$PresetCacheTableOrderingComposer,
          $$PresetCacheTableAnnotationComposer,
          $$PresetCacheTableCreateCompanionBuilder,
          $$PresetCacheTableUpdateCompanionBuilder,
          (
            PresetCacheData,
            BaseReferences<_$AppDatabase, $PresetCacheTable, PresetCacheData>,
          ),
          PresetCacheData,
          PrefetchHooks Function()
        > {
  $$PresetCacheTableTableManager(_$AppDatabase db, $PresetCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> brandKey = const Value.absent(),
                Value<String> displayNameKo = const Value.absent(),
                Value<String?> displayNameEn = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> defaultCurrency = const Value.absent(),
                Value<String> defaultPeriod = const Value.absent(),
                Value<String?> aliases = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresetCacheCompanion(
                brandKey: brandKey,
                displayNameKo: displayNameKo,
                displayNameEn: displayNameEn,
                category: category,
                defaultCurrency: defaultCurrency,
                defaultPeriod: defaultPeriod,
                aliases: aliases,
                notes: notes,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String brandKey,
                required String displayNameKo,
                Value<String?> displayNameEn = const Value.absent(),
                required String category,
                required String defaultCurrency,
                required String defaultPeriod,
                Value<String?> aliases = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => PresetCacheCompanion.insert(
                brandKey: brandKey,
                displayNameKo: displayNameKo,
                displayNameEn: displayNameEn,
                category: category,
                defaultCurrency: defaultCurrency,
                defaultPeriod: defaultPeriod,
                aliases: aliases,
                notes: notes,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresetCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresetCacheTable,
      PresetCacheData,
      $$PresetCacheTableFilterComposer,
      $$PresetCacheTableOrderingComposer,
      $$PresetCacheTableAnnotationComposer,
      $$PresetCacheTableCreateCompanionBuilder,
      $$PresetCacheTableUpdateCompanionBuilder,
      (
        PresetCacheData,
        BaseReferences<_$AppDatabase, $PresetCacheTable, PresetCacheData>,
      ),
      PresetCacheData,
      PrefetchHooks Function()
    >;
typedef $$SubscriptionGroupsTableCreateCompanionBuilder =
    SubscriptionGroupsCompanion Function({
      required String code,
      required String name,
      Value<String?> displayName,
      required String ownerId,
      Value<String> members,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$SubscriptionGroupsTableUpdateCompanionBuilder =
    SubscriptionGroupsCompanion Function({
      Value<String> code,
      Value<String> name,
      Value<String?> displayName,
      Value<String> ownerId,
      Value<String> members,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$SubscriptionGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionGroupsTable> {
  $$SubscriptionGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get members => $composableBuilder(
    column: $table.members,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionGroupsTable> {
  $$SubscriptionGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get members => $composableBuilder(
    column: $table.members,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionGroupsTable> {
  $$SubscriptionGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get members =>
      $composableBuilder(column: $table.members, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionGroupsTable,
          SubscriptionGroup,
          $$SubscriptionGroupsTableFilterComposer,
          $$SubscriptionGroupsTableOrderingComposer,
          $$SubscriptionGroupsTableAnnotationComposer,
          $$SubscriptionGroupsTableCreateCompanionBuilder,
          $$SubscriptionGroupsTableUpdateCompanionBuilder,
          (
            SubscriptionGroup,
            BaseReferences<
              _$AppDatabase,
              $SubscriptionGroupsTable,
              SubscriptionGroup
            >,
          ),
          SubscriptionGroup,
          PrefetchHooks Function()
        > {
  $$SubscriptionGroupsTableTableManager(
    _$AppDatabase db,
    $SubscriptionGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> members = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionGroupsCompanion(
                code: code,
                name: name,
                displayName: displayName,
                ownerId: ownerId,
                members: members,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String name,
                Value<String?> displayName = const Value.absent(),
                required String ownerId,
                Value<String> members = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionGroupsCompanion.insert(
                code: code,
                name: name,
                displayName: displayName,
                ownerId: ownerId,
                members: members,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionGroupsTable,
      SubscriptionGroup,
      $$SubscriptionGroupsTableFilterComposer,
      $$SubscriptionGroupsTableOrderingComposer,
      $$SubscriptionGroupsTableAnnotationComposer,
      $$SubscriptionGroupsTableCreateCompanionBuilder,
      $$SubscriptionGroupsTableUpdateCompanionBuilder,
      (
        SubscriptionGroup,
        BaseReferences<
          _$AppDatabase,
          $SubscriptionGroupsTable,
          SubscriptionGroup
        >,
      ),
      SubscriptionGroup,
      PrefetchHooks Function()
    >;
typedef $$PaymentLogsTableCreateCompanionBuilder =
    PaymentLogsCompanion Function({
      required String id,
      required String subscriptionId,
      required String cycleKey,
      required DateTime paidAt,
      Value<double?> usdAmount,
      Value<double?> fxRateApplied,
      required double krwFinal,
      Value<String?> memo,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PaymentLogsTableUpdateCompanionBuilder =
    PaymentLogsCompanion Function({
      Value<String> id,
      Value<String> subscriptionId,
      Value<String> cycleKey,
      Value<DateTime> paidAt,
      Value<double?> usdAmount,
      Value<double?> fxRateApplied,
      Value<double> krwFinal,
      Value<String?> memo,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PaymentLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleKey => $composableBuilder(
    column: $table.cycleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usdAmount => $composableBuilder(
    column: $table.usdAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fxRateApplied => $composableBuilder(
    column: $table.fxRateApplied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get krwFinal => $composableBuilder(
    column: $table.krwFinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleKey => $composableBuilder(
    column: $table.cycleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usdAmount => $composableBuilder(
    column: $table.usdAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fxRateApplied => $composableBuilder(
    column: $table.fxRateApplied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get krwFinal => $composableBuilder(
    column: $table.krwFinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentLogsTable> {
  $$PaymentLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subscriptionId => $composableBuilder(
    column: $table.subscriptionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cycleKey =>
      $composableBuilder(column: $table.cycleKey, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<double> get usdAmount =>
      $composableBuilder(column: $table.usdAmount, builder: (column) => column);

  GeneratedColumn<double> get fxRateApplied => $composableBuilder(
    column: $table.fxRateApplied,
    builder: (column) => column,
  );

  GeneratedColumn<double> get krwFinal =>
      $composableBuilder(column: $table.krwFinal, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentLogsTable,
          PaymentLog,
          $$PaymentLogsTableFilterComposer,
          $$PaymentLogsTableOrderingComposer,
          $$PaymentLogsTableAnnotationComposer,
          $$PaymentLogsTableCreateCompanionBuilder,
          $$PaymentLogsTableUpdateCompanionBuilder,
          (
            PaymentLog,
            BaseReferences<_$AppDatabase, $PaymentLogsTable, PaymentLog>,
          ),
          PaymentLog,
          PrefetchHooks Function()
        > {
  $$PaymentLogsTableTableManager(_$AppDatabase db, $PaymentLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subscriptionId = const Value.absent(),
                Value<String> cycleKey = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<double?> usdAmount = const Value.absent(),
                Value<double?> fxRateApplied = const Value.absent(),
                Value<double> krwFinal = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentLogsCompanion(
                id: id,
                subscriptionId: subscriptionId,
                cycleKey: cycleKey,
                paidAt: paidAt,
                usdAmount: usdAmount,
                fxRateApplied: fxRateApplied,
                krwFinal: krwFinal,
                memo: memo,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subscriptionId,
                required String cycleKey,
                required DateTime paidAt,
                Value<double?> usdAmount = const Value.absent(),
                Value<double?> fxRateApplied = const Value.absent(),
                required double krwFinal,
                Value<String?> memo = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentLogsCompanion.insert(
                id: id,
                subscriptionId: subscriptionId,
                cycleKey: cycleKey,
                paidAt: paidAt,
                usdAmount: usdAmount,
                fxRateApplied: fxRateApplied,
                krwFinal: krwFinal,
                memo: memo,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentLogsTable,
      PaymentLog,
      $$PaymentLogsTableFilterComposer,
      $$PaymentLogsTableOrderingComposer,
      $$PaymentLogsTableAnnotationComposer,
      $$PaymentLogsTableCreateCompanionBuilder,
      $$PaymentLogsTableUpdateCompanionBuilder,
      (
        PaymentLog,
        BaseReferences<_$AppDatabase, $PaymentLogsTable, PaymentLog>,
      ),
      PaymentLog,
      PrefetchHooks Function()
    >;
typedef $$PendingChangesTableCreateCompanionBuilder =
    PendingChangesCompanion Function({
      required String entityId,
      required String entityType,
      required String action,
      required String payload,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PendingChangesTableUpdateCompanionBuilder =
    PendingChangesCompanion Function({
      Value<String> entityId,
      Value<String> entityType,
      Value<String> action,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingChangesTableFilterComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingChangesTable> {
  $$PendingChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingChangesTable,
          PendingChange,
          $$PendingChangesTableFilterComposer,
          $$PendingChangesTableOrderingComposer,
          $$PendingChangesTableAnnotationComposer,
          $$PendingChangesTableCreateCompanionBuilder,
          $$PendingChangesTableUpdateCompanionBuilder,
          (
            PendingChange,
            BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>,
          ),
          PendingChange,
          PrefetchHooks Function()
        > {
  $$PendingChangesTableTableManager(
    _$AppDatabase db,
    $PendingChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingChangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingChangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingChangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingChangesCompanion(
                entityId: entityId,
                entityType: entityType,
                action: action,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityId,
                required String entityType,
                required String action,
                required String payload,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PendingChangesCompanion.insert(
                entityId: entityId,
                entityType: entityType,
                action: action,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingChangesTable,
      PendingChange,
      $$PendingChangesTableFilterComposer,
      $$PendingChangesTableOrderingComposer,
      $$PendingChangesTableAnnotationComposer,
      $$PendingChangesTableCreateCompanionBuilder,
      $$PendingChangesTableUpdateCompanionBuilder,
      (
        PendingChange,
        BaseReferences<_$AppDatabase, $PendingChangesTable, PendingChange>,
      ),
      PendingChange,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserSubscriptionsTableTableManager get userSubscriptions =>
      $$UserSubscriptionsTableTableManager(_db, _db.userSubscriptions);
  $$FxRatesDailyTableTableManager get fxRatesDaily =>
      $$FxRatesDailyTableTableManager(_db, _db.fxRatesDaily);
  $$PresetCacheTableTableManager get presetCache =>
      $$PresetCacheTableTableManager(_db, _db.presetCache);
  $$SubscriptionGroupsTableTableManager get subscriptionGroups =>
      $$SubscriptionGroupsTableTableManager(_db, _db.subscriptionGroups);
  $$PaymentLogsTableTableManager get paymentLogs =>
      $$PaymentLogsTableTableManager(_db, _db.paymentLogs);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(_db, _db.pendingChanges);
}
