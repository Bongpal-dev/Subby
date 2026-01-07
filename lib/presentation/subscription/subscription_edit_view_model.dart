import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/model/user_subscription.dart';

class SubscriptionEditState {
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String subscriptionId;
  final String groupCode;
  final String name;
  final String currency;
  final double amount;
  final int amountStepKRW;
  final double amountStepUSD;
  final int billingDay;
  final String period;
  final String? category;
  final String memo;
  final DateTime createdAt;

  const SubscriptionEditState({
    this.isLoading = true,
    this.isSaving = false,
    this.isDeleting = false,
    this.subscriptionId = '',
    this.groupCode = 'default',
    this.name = '',
    this.currency = 'KRW',
    this.amount = 0,
    this.amountStepKRW = 1000,
    this.amountStepUSD = 1,
    this.billingDay = 15,
    this.period = 'MONTHLY',
    this.category,
    this.memo = '',
    DateTime? createdAt,
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
    int? amountStepKRW,
    double? amountStepUSD,
    int? billingDay,
    String? period,
    String? category,
    bool clearCategory = false,
    String? memo,
    DateTime? createdAt,
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
      amountStepKRW: amountStepKRW ?? this.amountStepKRW,
      amountStepUSD: amountStepUSD ?? this.amountStepUSD,
      billingDay: billingDay ?? this.billingDay,
      period: period ?? this.period,
      category: clearCategory ? null : (category ?? this.category),
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
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
    _loadSubscription(subscriptionId);
    return SubscriptionEditState(subscriptionId: subscriptionId);
  }

  Future<void> _loadSubscription(String subscriptionId) async {
    final getByIdUseCase = ref.read(getSubscriptionByIdUseCaseProvider);
    final subscription = await getByIdUseCase(subscriptionId);

    if (subscription != null) {
      state = state.copyWith(
        isLoading: false,
        groupCode: subscription.groupCode,
        name: subscription.name,
        currency: subscription.currency,
        amount: subscription.amount,
        billingDay: subscription.billingDay,
        period: subscription.period,
        category: subscription.category,
        memo: subscription.memo ?? '',
        createdAt: subscription.createdAt,
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
      final updateUseCase = ref.read(updateSubscriptionUseCaseProvider);
      final subscription = UserSubscription(
        id: state.subscriptionId,
        groupCode: state.groupCode,
        name: state.name,
        amount: state.amount,
        currency: state.currency,
        billingDay: state.billingDay,
        period: state.period,
        category: state.category,
        memo: state.memo.isEmpty ? null : state.memo,
        createdAt: state.createdAt,
      );

      await updateUseCase(subscription);
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
