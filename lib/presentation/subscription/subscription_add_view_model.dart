import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/util/category_mapper.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/home/home_view_model.dart';

class SubscriptionAddState {
  final List<SubscriptionPreset> presets;
  final List<SubscriptionPreset> filteredPresets;
  final bool isLoadingPresets;
  final bool isServiceSelected;
  final SubscriptionPreset? selectedPreset;
  final PlanOption? selectedPlan;  // 선택된 요금제
  final bool isManualPriceInput;   // 직접입력 모드 여부
  final String name;
  final String currency;
  final double amount;
  final int amountStepKRW;
  final double amountStepUSD;
  final int billingDay;
  final int? billingMonth; // 연간 결제 시 결제월 (1-12)
  final String period;
  final String? category;
  final String memo;
  final String searchQuery;
  final PresetCategory? selectedCategory;
  final bool isSaving;

  const SubscriptionAddState({
    this.presets = const [],
    this.filteredPresets = const [],
    this.isLoadingPresets = true,
    this.isServiceSelected = false,
    this.selectedPreset,
    this.selectedPlan,
    this.isManualPriceInput = false,
    this.name = '',
    this.currency = 'KRW',
    this.amount = 0,
    this.amountStepKRW = 1000,
    this.amountStepUSD = 1,
    this.billingDay = 15,
    this.billingMonth,
    this.period = 'MONTHLY',
    this.category,
    this.memo = '',
    this.searchQuery = '',
    this.selectedCategory,
    this.isSaving = false,
  });

  SubscriptionAddState copyWith({
    List<SubscriptionPreset>? presets,
    List<SubscriptionPreset>? filteredPresets,
    bool? isLoadingPresets,
    bool? isServiceSelected,
    SubscriptionPreset? selectedPreset,
    bool clearSelectedPreset = false,
    PlanOption? selectedPlan,
    bool clearSelectedPlan = false,
    bool? isManualPriceInput,
    String? name,
    String? currency,
    double? amount,
    int? amountStepKRW,
    double? amountStepUSD,
    int? billingDay,
    int? billingMonth,
    bool clearBillingMonth = false,
    String? period,
    String? category,
    bool clearCategory = false,
    String? memo,
    String? searchQuery,
    PresetCategory? selectedCategory,
    bool clearSelectedCategory = false,
    bool? isSaving,
  }) {
    return SubscriptionAddState(
      presets: presets ?? this.presets,
      filteredPresets: filteredPresets ?? this.filteredPresets,
      isLoadingPresets: isLoadingPresets ?? this.isLoadingPresets,
      isServiceSelected: isServiceSelected ?? this.isServiceSelected,
      selectedPreset: clearSelectedPreset ? null : (selectedPreset ?? this.selectedPreset),
      selectedPlan: clearSelectedPlan ? null : (selectedPlan ?? this.selectedPlan),
      isManualPriceInput: isManualPriceInput ?? this.isManualPriceInput,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      amountStepKRW: amountStepKRW ?? this.amountStepKRW,
      amountStepUSD: amountStepUSD ?? this.amountStepUSD,
      billingDay: billingDay ?? this.billingDay,
      billingMonth: clearBillingMonth ? null : (billingMonth ?? this.billingMonth),
      period: period ?? this.period,
      category: clearCategory ? null : (category ?? this.category),
      memo: memo ?? this.memo,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class SubscriptionAddViewModel extends AutoDisposeNotifier<SubscriptionAddState> {
  @override
  SubscriptionAddState build() {
    _loadPresets();
    return const SubscriptionAddState();
  }

  Future<void> _loadPresets() async {
    try {
      final getPresetsUseCase = ref.read(getPresetsUseCaseProvider);
      final presets = await getPresetsUseCase();
      print('Loaded ${presets.length} presets'); // debug
      state = state.copyWith(
        presets: presets,
        filteredPresets: presets,
        isLoadingPresets: false,
      );
    } catch (e) {
      print('Error loading presets: $e'); // debug
      state = state.copyWith(isLoadingPresets: false);
    }
  }

  void filterPresets(String query, Locale locale) {
    state = state.copyWith(searchQuery: query);
    _applyFilter(locale);
  }

  void selectCategory(PresetCategory? category, Locale locale) {
    if (category == null) {
      state = state.copyWith(clearSelectedCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
    _applyFilter(locale);
  }

  void _applyFilter(Locale locale) {
    final query = state.searchQuery.toLowerCase();
    final filtered = state.presets.where((preset) {
      final matchesCategory =
          state.selectedCategory == null || preset.category == state.selectedCategory;
      final matchesQuery = query.isEmpty ||
          preset.displayName(locale).toLowerCase().contains(query) ||
          preset.displayNameKo.toLowerCase().contains(query) ||
          (preset.displayNameEn?.toLowerCase().contains(query) ?? false) ||
          preset.aliases.any((a) => a.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    filtered.sort((a, b) => a.displayName(locale).compareTo(b.displayName(locale)));
    state = state.copyWith(filteredPresets: filtered);
  }

  void selectPreset(SubscriptionPreset preset, Locale locale) {
    // 기본 요금제가 있으면 자동 선택
    final defaultPlan = preset.defaultPlan;
    final period = defaultPlan?.period ?? preset.defaultPeriod;

    state = state.copyWith(
      selectedPreset: preset,
      isServiceSelected: true,
      name: preset.displayName(locale),
      currency: defaultPlan?.currency ?? preset.defaultCurrency,
      amount: defaultPlan?.price ?? 0,
      period: period,
      billingMonth: period == 'YEARLY' ? DateTime.now().month : null,
      clearBillingMonth: period != 'YEARLY',
      category: mapPresetCategoryToKorean(preset.category),
      selectedPlan: defaultPlan,
      isManualPriceInput: !preset.hasPlans, // 요금제 없으면 직접입력 모드
    );
  }

  /// 요금제 선택
  void selectPlan(PlanOption plan) {
    state = state.copyWith(
      selectedPlan: plan,
      currency: plan.currency,
      amount: plan.price,
      period: plan.period,
      billingMonth: plan.period == 'YEARLY' ? (state.billingMonth ?? DateTime.now().month) : null,
      clearBillingMonth: plan.period != 'YEARLY',
      isManualPriceInput: false,
    );
  }

  /// 직접입력 모드로 전환 (요금제 선택 해제)
  void selectManualPriceInput() {
    state = state.copyWith(
      clearSelectedPlan: true,
      isManualPriceInput: true,
      amount: 0,
    );
  }

  void selectManualInput() {
    // 프리셋 선택 해제, 입력한 이름은 유지
    state = state.copyWith(
      clearSelectedPreset: true,
      clearSelectedPlan: true,
      isServiceSelected: true,
      isManualPriceInput: true,
      // name은 유지 (사용자가 입력한 텍스트)
      currency: 'KRW',
      amount: 0,
      period: 'MONTHLY',
      clearCategory: true,
      clearBillingMonth: true,
    );
  }

  void resetSelection() {
    state = state.copyWith(
      clearSelectedPreset: true,
      clearSelectedPlan: true,
      isServiceSelected: false,
      isManualPriceInput: false,
      name: '',
      currency: 'KRW',
      amount: 0,
      billingDay: 15,
      clearBillingMonth: true,
      period: 'MONTHLY',
      clearCategory: true,
      memo: '',
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  /// 서비스 선택 해제 (입력 시 검색 아이콘으로 전환)
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

  void changeAmount(int direction) {
    double newAmount;
    if (state.currency == 'KRW') {
      newAmount = (state.amount + direction * state.amountStepKRW).clamp(0, double.infinity);
    } else {
      newAmount = ((state.amount + direction * state.amountStepUSD) * 100).round() / 100;
      newAmount = newAmount.clamp(0, double.infinity);
    }
    state = state.copyWith(amount: newAmount);
  }

  void setAmountStep(dynamic step) {
    if (state.currency == 'KRW') {
      state = state.copyWith(amountStepKRW: step as int);
    } else {
      state = state.copyWith(amountStepUSD: step as double);
    }
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
      final addUseCase = ref.read(addSubscriptionUseCaseProvider);
      final homeState = ref.read(homeViewModelProvider);
      // 현재 선택된 그룹 또는 기본 그룹 사용
      final groupCode = homeState.selectedGroupCode ?? 'default';

      final subscription = UserSubscription(
        id: const Uuid().v4(),
        groupCode: groupCode,
        name: state.name,
        amount: state.amount,
        currency: state.currency,
        billingDay: state.billingDay,
        billingMonth: state.period == 'YEARLY' ? state.billingMonth : null,
        period: state.period,
        category: state.category,
        memo: state.memo.isEmpty ? null : state.memo,
        createdAt: DateTime.now(),
      );

      await addUseCase(subscription);
      ref.read(pendingSyncTriggerProvider.notifier).state++;
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

}

final subscriptionAddViewModelProvider =
    NotifierProvider.autoDispose<SubscriptionAddViewModel, SubscriptionAddState>(() {
  return SubscriptionAddViewModel();
});
