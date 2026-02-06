import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/util/category_mapper.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';

class SubscriptionEditState {
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String subscriptionId;
  final String groupCode;
  final String name;
  final String currency;
  final double amount;
  final int billingDay;
  final int? billingMonth; // 연간 결제 시 결제월 (1-12)
  final String period;
  final String? category;
  final String memo;
  final DateTime createdAt;

  // 프리셋 관련
  final List<SubscriptionPreset> presets;
  final List<SubscriptionPreset> filteredPresets;
  final bool isLoadingPresets;
  final bool isServiceSelected;
  final SubscriptionPreset? selectedPreset;
  final PlanOption? selectedPlan;
  final String searchQuery;

  const SubscriptionEditState({
    this.isLoading = true,
    this.isSaving = false,
    this.isDeleting = false,
    this.subscriptionId = '',
    this.groupCode = 'default',
    this.name = '',
    this.currency = 'KRW',
    this.amount = 0,
    this.billingDay = 15,
    this.billingMonth,
    this.period = 'MONTHLY',
    this.category,
    this.memo = '',
    DateTime? createdAt,
    this.presets = const [],
    this.filteredPresets = const [],
    this.isLoadingPresets = true,
    this.isServiceSelected = false,
    this.selectedPreset,
    this.selectedPlan,
    this.searchQuery = '',
  }) : createdAt = createdAt ?? const _DefaultDateTime();

  SubscriptionEditState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? subscriptionId,
    String? groupCode,
    String? name,
    String? currency,
    double? amount,
    int? billingDay,
    int? billingMonth,
    bool clearBillingMonth = false,
    String? period,
    String? category,
    bool clearCategory = false,
    String? memo,
    DateTime? createdAt,
    List<SubscriptionPreset>? presets,
    List<SubscriptionPreset>? filteredPresets,
    bool? isLoadingPresets,
    bool? isServiceSelected,
    SubscriptionPreset? selectedPreset,
    bool clearSelectedPreset = false,
    PlanOption? selectedPlan,
    bool clearSelectedPlan = false,
    String? searchQuery,
  }) {
    return SubscriptionEditState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      groupCode: groupCode ?? this.groupCode,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      billingDay: billingDay ?? this.billingDay,
      billingMonth: clearBillingMonth ? null : (billingMonth ?? this.billingMonth),
      period: period ?? this.period,
      category: clearCategory ? null : (category ?? this.category),
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      presets: presets ?? this.presets,
      filteredPresets: filteredPresets ?? this.filteredPresets,
      isLoadingPresets: isLoadingPresets ?? this.isLoadingPresets,
      isServiceSelected: isServiceSelected ?? this.isServiceSelected,
      selectedPreset: clearSelectedPreset ? null : (selectedPreset ?? this.selectedPreset),
      selectedPlan: clearSelectedPlan ? null : (selectedPlan ?? this.selectedPlan),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class _DefaultDateTime implements DateTime {
  const _DefaultDateTime();

  @override
  dynamic noSuchMethod(Invocation invocation) => DateTime.now();
}

class SubscriptionEditViewModel extends AutoDisposeFamilyNotifier<SubscriptionEditState, String> {
  @override
  SubscriptionEditState build(String subscriptionId) {
    _initialize(subscriptionId);
    return SubscriptionEditState(subscriptionId: subscriptionId);
  }

  Future<void> _initialize(String subscriptionId) async {
    await _loadPresets();
    await _loadSubscription(subscriptionId);
  }

  Future<void> _loadPresets() async {
    try {
      final getPresetsUseCase = ref.read(getPresetsUseCaseProvider);
      final presets = await getPresetsUseCase();
      state = state.copyWith(
        presets: presets,
        filteredPresets: presets,
        isLoadingPresets: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingPresets: false);
    }
  }

  Future<void> _loadSubscription(String subscriptionId) async {
    final getByIdUseCase = ref.read(getSubscriptionByIdUseCaseProvider);
    final subscription = await getByIdUseCase(subscriptionId);

    if (subscription != null) {
      // 구독 이름과 일치하는 프리셋 찾기
      SubscriptionPreset? matchingPreset;
      for (final preset in state.presets) {
        if (preset.displayNameKo == subscription.name ||
            preset.displayNameEn == subscription.name) {
          matchingPreset = preset;
          break;
        }
      }

      // 프리셋이 있으면 일치하는 요금제 찾기
      PlanOption? matchingPlan;
      if (matchingPreset != null && matchingPreset.hasPlans) {
        for (final plan in matchingPreset.plans) {
          if (plan.currency == subscription.currency &&
              plan.price == subscription.amount &&
              plan.period == subscription.period) {
            matchingPlan = plan;
            break;
          }
        }
      }

      state = state.copyWith(
        isLoading: false,
        groupCode: subscription.groupCode,
        name: subscription.name,
        currency: subscription.currency,
        amount: subscription.amount,
        billingDay: subscription.billingDay,
        billingMonth: subscription.billingMonth,
        period: subscription.period,
        category: subscription.category,
        memo: subscription.memo ?? '',
        createdAt: subscription.createdAt,
        isServiceSelected: true,
        selectedPreset: matchingPreset,
        selectedPlan: matchingPlan,
      );
    }
  }

  void filterPresets(String query, Locale locale) {
    state = state.copyWith(searchQuery: query);
    _applyFilter(locale);
  }

  void _applyFilter(Locale locale) {
    final query = state.searchQuery.toLowerCase();
    final filtered = state.presets.where((preset) {
      final matchesQuery = query.isEmpty ||
          preset.displayName(locale).toLowerCase().contains(query) ||
          preset.displayNameKo.toLowerCase().contains(query) ||
          (preset.displayNameEn?.toLowerCase().contains(query) ?? false) ||
          preset.aliases.any((a) => a.toLowerCase().contains(query));
      return matchesQuery;
    }).toList();

    filtered.sort((a, b) => a.displayName(locale).compareTo(b.displayName(locale)));
    state = state.copyWith(filteredPresets: filtered);
  }

  void selectPreset(SubscriptionPreset preset, Locale locale) {
    final defaultPlan = preset.defaultPlan;
    final period = defaultPlan?.period ?? preset.defaultPeriod;

    state = state.copyWith(
      selectedPreset: preset,
      isServiceSelected: true,
      name: preset.displayName(locale),
      currency: defaultPlan?.currency ?? preset.defaultCurrency,
      amount: defaultPlan?.price ?? 0,
      period: period,
      billingMonth: period == 'YEARLY' ? (state.billingMonth ?? DateTime.now().month) : null,
      clearBillingMonth: period != 'YEARLY',
      category: mapPresetCategoryToKorean(preset.category),
      selectedPlan: defaultPlan,
    );
  }

  void selectPlan(PlanOption plan) {
    state = state.copyWith(
      selectedPlan: plan,
      currency: plan.currency,
      amount: plan.price,
      period: plan.period,
      billingMonth: plan.period == 'YEARLY' ? (state.billingMonth ?? DateTime.now().month) : null,
      clearBillingMonth: plan.period != 'YEARLY',
    );
  }

  void selectManualInput() {
    state = state.copyWith(
      clearSelectedPreset: true,
      clearSelectedPlan: true,
      isServiceSelected: true,
      currency: 'KRW',
      amount: 0,
      period: 'MONTHLY',
      clearCategory: true,
      clearBillingMonth: true,
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void clearPresetSelection() {
    if (state.isServiceSelected) {
      state = state.copyWith(
        clearSelectedPreset: true,
        isServiceSelected: false,
      );
    }
  }

  void setCurrency(String currency) {
    state = state.copyWith(currency: currency, amount: 0);
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setBillingDay(int day) {
    state = state.copyWith(billingDay: day);
  }

  void setBillingMonth(int? month) {
    if (month == null) {
      state = state.copyWith(clearBillingMonth: true);
    } else {
      state = state.copyWith(billingMonth: month);
    }
  }

  void setPeriod(String period) {
    // 해당 주기의 최저가 요금제 자동 선택
    PlanOption? lowestPricePlan;
    if (state.selectedPreset?.hasPlans == true) {
      final plansForPeriod = state.selectedPreset!.plans
          .where((p) => p.period == period)
          .toList();
      if (plansForPeriod.isNotEmpty) {
        plansForPeriod.sort((a, b) => a.price.compareTo(b.price));
        lowestPricePlan = plansForPeriod.first;
      }
    }

    if (period == 'YEARLY') {
      state = state.copyWith(
        period: period,
        billingMonth: state.billingMonth ?? DateTime.now().month,
        selectedPlan: lowestPricePlan,
        amount: lowestPricePlan?.price ?? state.amount,
        currency: lowestPricePlan?.currency ?? state.currency,
      );
    } else {
      state = state.copyWith(
        period: period,
        clearBillingMonth: true,
        selectedPlan: lowestPricePlan,
        amount: lowestPricePlan?.price ?? state.amount,
        currency: lowestPricePlan?.currency ?? state.currency,
      );
    }
  }

  void setMemo(String memo) {
    state = state.copyWith(memo: memo);
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  Future<bool> save() async {
    if (state.name.isEmpty || state.amount <= 0) {
      return false;
    }

    state = state.copyWith(isSaving: true);

    try {
      final updateUseCase = ref.read(updateSubscriptionUseCaseProvider);
      final subscription = UserSubscription(
        id: state.subscriptionId,
        groupCode: state.groupCode,
        name: state.name,
        amount: state.amount,
        currency: state.currency,
        billingDay: state.billingDay,
        billingMonth: state.period == 'YEARLY' ? state.billingMonth : null,
        period: state.period,
        category: state.category,
        memo: state.memo.isEmpty ? null : state.memo,
        createdAt: state.createdAt,
      );

      await updateUseCase(subscription);
      ref.read(pendingSyncTriggerProvider.notifier).state++;
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  Future<bool> delete() async {
    state = state.copyWith(isDeleting: true);

    try {
      final deleteUseCase = ref.read(deleteSubscriptionUseCaseProvider);
      await deleteUseCase(state.subscriptionId);
      ref.read(pendingSyncTriggerProvider.notifier).state++;
      state = state.copyWith(isDeleting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isDeleting: false);
      return false;
    }
  }
}

final subscriptionEditViewModelProvider =
    NotifierProvider.autoDispose.family<SubscriptionEditViewModel, SubscriptionEditState, String>(() {
  return SubscriptionEditViewModel();
});
