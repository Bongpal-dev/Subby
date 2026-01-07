import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/home/home_view_model.dart';

class SubscriptionAddState {
  final List<SubscriptionPreset> presets;
  final List<SubscriptionPreset> filteredPresets;
  final bool isLoadingPresets;
  final bool isServiceSelected;
  final SubscriptionPreset? selectedPreset;
  final String name;
  final String currency;
  final double amount;
  final int amountStepKRW;
  final double amountStepUSD;
  final int billingDay;
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
    this.name = '',
    this.currency = 'KRW',
    this.amount = 0,
    this.amountStepKRW = 1000,
    this.amountStepUSD = 1,
    this.billingDay = 15,
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
    String? name,
    String? currency,
    double? amount,
    int? amountStepKRW,
    double? amountStepUSD,
    int? billingDay,
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
      name: name ?? this.name,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      amountStepKRW: amountStepKRW ?? this.amountStepKRW,
      amountStepUSD: amountStepUSD ?? this.amountStepUSD,
      billingDay: billingDay ?? this.billingDay,
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
    state = state.copyWith(
      selectedPreset: preset,
      isServiceSelected: true,
      name: preset.displayName(locale),
      currency: preset.defaultCurrency,
      amount: 0,
      period: preset.defaultPeriod,
      category: _mapPresetCategory(preset.category),
    );
  }

  void selectManualInput() {
    state = state.copyWith(
      clearSelectedPreset: true,
      isServiceSelected: true,
      name: '',
      currency: 'KRW',
      amount: 0,
      period: 'MONTHLY',
      clearCategory: true,
    );
  }

  void resetSelection() {
    state = state.copyWith(
      clearSelectedPreset: true,
      isServiceSelected: false,
      name: '',
      currency: 'KRW',
      amount: 0,
      billingDay: 15,
      period: 'MONTHLY',
      clearCategory: true,
      memo: '',
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name);
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

  void setPeriod(String period) {
    state = state.copyWith(period: period);
  }

  void setMemo(String memo) {
    state = state.copyWith(memo: memo);
  }

  String formatAmount() {
    if (state.currency == 'KRW') {
      return '\u20a9${state.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else {
      return '\$${state.amount.toStringAsFixed(2)}';
    }
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
        period: state.period,
        category: state.category,
        memo: state.memo.isEmpty ? null : state.memo,
        createdAt: DateTime.now(),
      );

      await addUseCase(subscription);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  String _mapPresetCategory(PresetCategory category) {
    switch (category) {
      case PresetCategory.VIDEO:
        return '영상';
      case PresetCategory.MUSIC:
        return '음악';
      case PresetCategory.GAME:
        return '게임';
      case PresetCategory.AI:
      case PresetCategory.DEV:
      case PresetCategory.CLOUD:
      case PresetCategory.PRODUCTIVITY:
        return '소프트웨어';
      case PresetCategory.EDUCATION:
        return '교육';
      case PresetCategory.DESIGN:
        return '디자인';
      case PresetCategory.FINANCE:
        return '금융';
    }
  }
}

final subscriptionAddViewModelProvider =
    NotifierProvider.autoDispose<SubscriptionAddViewModel, SubscriptionAddState>(() {
  return SubscriptionAddViewModel();
});
