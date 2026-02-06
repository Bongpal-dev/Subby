import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
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
  final int? billingMonth; // 연간 결제 시 결제월 (1-12)
  final String period;
  final String formattedAmount; // 원래 통화로 포맷된 금액
  final String? convertedAmount; // 기본 통화로 변환된 금액 (다를 경우)
  final String periodLabel;
  final String billingDayLabel; // 결제일 라벨 (연간: "매년 M월 N일", 월간: "매월 N일")

  const SubscriptionUiModel({
    required this.id,
    required this.name,
    this.category,
    required this.billingDay,
    this.billingMonth,
    required this.period,
    required this.formattedAmount,
    this.convertedAmount,
    required this.periodLabel,
    required this.billingDayLabel,
  });
}

class HomeState {
  final List<SubscriptionUiModel> subscriptions;
  final List<SubscriptionGroup> groups;
  final String? selectedGroupCode;
  final String? selectedCategory;
  final bool isLoading;
  final String formattedTotal;

  const HomeState({
    this.subscriptions = const [],
    this.groups = const [],
    this.selectedGroupCode,
    this.selectedCategory,
    this.isLoading = true,
    this.formattedTotal = '',
  });

  bool get hasGroup => groups.isNotEmpty;

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
    List<SubscriptionUiModel>? subscriptions,
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

    // FCM 초기화
    ref.watch(fcmInitializedProvider);

    _watchGroups();
    _watchSubscriptions();
    _watchRemoteGroups();
    return const HomeState();
  }

  void _watchGroups() {
    final watchGroupsUseCase = ref.read(watchGroupsUseCaseProvider);
    final savedGroupCode = ref.read(lastSelectedGroupCodeProvider);

    watchGroupsUseCase().listen((groups) {
      String? newGroupCode;

      if (state.selectedGroupCode != null) {
        // 이미 선택된 그룹이 있으면 유지 (삭제된 경우 제외)
        final selectedExists = groups.any((g) => g.code == state.selectedGroupCode);
        newGroupCode = selectedExists ? state.selectedGroupCode : groups.firstOrNull?.code;
      } else if (savedGroupCode != null) {
        // 저장된 그룹 코드가 있으면 복원
        final savedExists = groups.any((g) => g.code == savedGroupCode);
        newGroupCode = savedExists ? savedGroupCode : groups.firstOrNull?.code;
      } else {
        // 처음이면 첫 번째 그룹 선택
        newGroupCode = groups.firstOrNull?.code;
      }

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
    final syncRemoteGroupsUseCase = ref.read(syncRemoteGroupsUseCaseProvider);

    _remoteGroupsSubscription?.cancel();
    _remoteGroupsSubscription = syncRemoteGroupsUseCase(
      onRemoteGroupsChanged: (remoteGroups) async {
        // UseCase 내부에서 이미 동기화 처리됨
      },
    );
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
      subscriptions: uiModels,
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

    // 마지막 선택 그룹 저장
    ref.read(lastSelectedGroupCodeProvider.notifier).setGroupCode(groupCode);

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

      // 결제일 라벨 생성
      final billingDayLabel = _getBillingDayLabel(sub.period, sub.billingDay, sub.billingMonth);

      return SubscriptionUiModel(
        id: sub.id,
        name: sub.name,
        category: sub.category,
        billingDay: sub.billingDay,
        billingMonth: sub.billingMonth,
        period: sub.period,
        formattedAmount: formattedAmount,
        convertedAmount: convertedAmount,
        periodLabel: _getPeriodLabel(sub.period),
        billingDayLabel: billingDayLabel,
      );
    }).toList();
  }

  String _getBillingDayLabel(String period, int billingDay, int? billingMonth) {
    if (period.toUpperCase() == 'YEARLY') {
      if (billingMonth != null) {
        return '매년 $billingMonth월 $billingDay일 결제';
      }
      return '매년 $billingDay일 결제';
    }
    return '매월 $billingDay일 결제';
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
    switch (period.toUpperCase()) {
      case 'MONTHLY':
        return '월간 결제';
      case 'YEARLY':
        return '연간 결제';
      case 'WEEKLY':
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
