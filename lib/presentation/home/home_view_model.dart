import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/utils/currency_converter.dart';
import 'package:subby/domain/model/currency.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';

/// 구독 카드 UI 모델
class SubscriptionUiModel {
  final String id;
  final String name;
  final String? category;
  final int billingDay;
  final String period;
  final String formattedAmount; // 원래 통화로 포맷된 금액
  final String? convertedAmount; // 기본 통화로 변환된 금액 (다를 경우)
  final String periodLabel;

  const SubscriptionUiModel({
    required this.id,
    required this.name,
    this.category,
    required this.billingDay,
    required this.period,
    required this.formattedAmount,
    this.convertedAmount,
    required this.periodLabel,
  });
}

class HomeState {
  final List<UserSubscription> subscriptions;
  final List<SubscriptionUiModel> subscriptionUiModels;
  final List<SubscriptionGroup> groups;
  final String? selectedGroupCode;
  final String? selectedCategory;
  final bool isLoading;
  final String formattedTotal;

  const HomeState({
    this.subscriptions = const [],
    this.subscriptionUiModels = const [],
    this.groups = const [],
    this.selectedGroupCode,
    this.selectedCategory,
    this.isLoading = true,
    this.formattedTotal = '',
  });

  String get currentGroupName {
    if (selectedGroupCode == null) return '내 구독';
    final group = groups.where((g) => g.code == selectedGroupCode).firstOrNull;
    return group?.effectiveName ?? '내 구독';
  }

  /// 구독 목록에서 고유한 카테고리 목록 추출
  List<String> get categories {
    final cats = subscriptions
        .map((s) => s.category)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  HomeState copyWith({
    List<UserSubscription>? subscriptions,
    List<SubscriptionUiModel>? subscriptionUiModels,
    List<SubscriptionGroup>? groups,
    String? selectedGroupCode,
    bool clearSelectedGroup = false,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    bool? isLoading,
    String? formattedTotal,
  }) {
    return HomeState(
      subscriptions: subscriptions ?? this.subscriptions,
      subscriptionUiModels: subscriptionUiModels ?? this.subscriptionUiModels,
      groups: groups ?? this.groups,
      selectedGroupCode: clearSelectedGroup ? null : (selectedGroupCode ?? this.selectedGroupCode),
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
      formattedTotal: formattedTotal ?? this.formattedTotal,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  StreamSubscription<List<SubscriptionGroup>>? _remoteGroupsSubscription;
  StreamSubscription<List<UserSubscription>>? _subscriptionsSubscription;
  List<UserSubscription> _rawSubscriptions = [];

  @override
  HomeState build() {
    // 설정 변경 시 UI 모델 재생성
    ref.watch(defaultCurrencyProvider);
    ref.watch(currencyConverterProvider);

    _watchGroups();
    _watchSubscriptions();
    _watchRemoteGroups();
    return const HomeState();
  }

  void _watchGroups() {
    final groupRepository = ref.read(groupRepositoryProvider);
    groupRepository.watchAll().listen((groups) {
      // 선택된 그룹이 삭제되었으면 다른 그룹으로 전환
      final selectedExists = groups.any((g) => g.code == state.selectedGroupCode);
      final newGroupCode = selectedExists ? state.selectedGroupCode : groups.firstOrNull?.code;

      state = state.copyWith(
        groups: groups,
        selectedGroupCode: newGroupCode,
        clearSelectedGroup: newGroupCode == null,
        isLoading: false,
      );

      // currentGroupCodeProvider 동기화
      if (newGroupCode != null) {
        ref.read(currentGroupCodeProvider.notifier).state = newGroupCode;
      }
    });
  }

  /// Firestore 실시간 감시 - 그룹 멤버 변경 등 반영
  void _watchRemoteGroups() {
    final authDataSource = ref.read(firebaseAuthDataSourceProvider);
    final userId = authDataSource.currentUserId;
    if (userId == null) return;

    final groupRepository = ref.read(groupRepositoryProvider);

    _remoteGroupsSubscription?.cancel();
    _remoteGroupsSubscription = groupRepository
        .watchRemoteGroupsByUserId(userId)
        .listen((remoteGroups) async {
      // 원격 그룹 변경 시 로컬 DB 업데이트
      final localGroups = await groupRepository.getAll();

      for (final remoteGroup in remoteGroups) {
        final localGroup = localGroups.where((g) => g.code == remoteGroup.code).firstOrNull;

        if (localGroup != null) {
          // displayName은 로컬 값 유지, 나머지는 원격 값으로 업데이트
          final updatedGroup = remoteGroup.copyWith(
            displayName: localGroup.displayName,
          );
          await groupRepository.update(updatedGroup);
        }
      }
    });
  }

  void _watchSubscriptions() {
    _subscriptionsSubscription?.cancel();
    final watchUseCase = ref.read(watchSubscriptionsUseCaseProvider);
    _subscriptionsSubscription = watchUseCase().listen((subscriptions) {
      _rawSubscriptions = subscriptions;
      _updateState();
    });
  }

  void _updateState() {
    final groupFiltered = _filterByGroup(_rawSubscriptions);
    final categoryFiltered = _filterByCategory(groupFiltered);
    final uiModels = _mapToUiModels(categoryFiltered);
    final formattedTotal = _calculateFormattedTotal(categoryFiltered);

    state = state.copyWith(
      subscriptions: groupFiltered,
      subscriptionUiModels: uiModels,
      isLoading: false,
      formattedTotal: formattedTotal,
    );
  }

  List<UserSubscription> _filterByGroup(List<UserSubscription> subscriptions) {
    final groupCode = state.selectedGroupCode;
    if (groupCode == null) return subscriptions;
    return subscriptions.where((s) => s.groupCode == groupCode).toList();
  }

  List<UserSubscription> _filterByCategory(List<UserSubscription> subscriptions) {
    final category = state.selectedCategory;
    if (category == null) return subscriptions;
    return subscriptions.where((s) => s.category == category).toList();
  }

  void selectGroup(String? groupCode) {
    state = state.copyWith(
      selectedGroupCode: groupCode,
      clearSelectedGroup: groupCode == null,
      clearSelectedCategory: true, // 그룹 변경 시 카테고리 필터 초기화
    );

    // currentGroupCodeProvider 동기화
    ref.read(currentGroupCodeProvider.notifier).state = groupCode;

    _watchSubscriptions();
  }

  void selectCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
    );
    _applyFilters();
  }

  void _applyFilters() {
    _updateState();
  }

  List<SubscriptionUiModel> _mapToUiModels(List<UserSubscription> subscriptions) {
    final defaultCurrency = ref.read(defaultCurrencyProvider);
    final converter = ref.read(currencyConverterProvider);

    return subscriptions.map((sub) {
      final subCurrency = Currency.fromCode(sub.currency) ?? Currency.KRW;
      final isSameCurrency = subCurrency == defaultCurrency;

      // 원래 통화로 포맷
      final formattedAmount = converter?.format(sub.amount, subCurrency) ??
          '${subCurrency.symbol}${sub.amount.toStringAsFixed(subCurrency.decimalDigits)}';

      // 기본 통화와 다르면 변환
      String? convertedAmount;
      if (!isSameCurrency && converter != null) {
        final converted = converter.convert(sub.amount, subCurrency, defaultCurrency);
        convertedAmount = '≈${converter.format(converted, defaultCurrency)}';
      }

      return SubscriptionUiModel(
        id: sub.id,
        name: sub.name,
        category: sub.category,
        billingDay: sub.billingDay,
        period: sub.period,
        formattedAmount: formattedAmount,
        convertedAmount: convertedAmount,
        periodLabel: _getPeriodLabel(sub.period),
      );
    }).toList();
  }

  String _calculateFormattedTotal(List<UserSubscription> subscriptions) {
    final defaultCurrency = ref.read(defaultCurrencyProvider);
    final converter = ref.read(currencyConverterProvider);

    double total = 0;
    for (final sub in subscriptions) {
      final subCurrency = Currency.fromCode(sub.currency) ?? Currency.KRW;
      if (subCurrency == defaultCurrency) {
        total += sub.amount;
      } else if (converter != null) {
        total += converter.convert(sub.amount, subCurrency, defaultCurrency);
      } else {
        total += sub.amount;
      }
    }

    return converter?.format(total, defaultCurrency) ??
        '${defaultCurrency.symbol}${total.toStringAsFixed(defaultCurrency.decimalDigits)}';
  }

  String _getPeriodLabel(String period) {
    switch (period) {
      case 'monthly':
        return '월간 결제';
      case 'yearly':
        return '연간 결제';
      case 'weekly':
        return '주간 결제';
      default:
        return '월간 결제';
    }
  }

  Future<bool> deleteSubscription(String subscriptionId) async {
    try {
      final deleteUseCase = ref.read(deleteSubscriptionUseCaseProvider);
      await deleteUseCase(subscriptionId);
      ref.read(pendingSyncTriggerProvider.notifier).state++;
      return true;
    } catch (e) {
      return false;
    }
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
