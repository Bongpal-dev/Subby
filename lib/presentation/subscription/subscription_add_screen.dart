import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';
import 'package:subby/presentation/subscription/widgets/service_dropdown.dart';

class SubscriptionAddScreen extends ConsumerStatefulWidget {
  const SubscriptionAddScreen({super.key});

  @override
  ConsumerState<SubscriptionAddScreen> createState() => _SubscriptionAddScreenState();
}

class _SubscriptionAddScreenState extends ConsumerState<SubscriptionAddScreen> {
  final _focusSink = FocusNode(skipTraversal: true);

  @override
  void dispose() {
    _focusSink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;

    return GestureDetector(
      onTap: () => _focusSink.requestFocus(),
      child: Focus(
        focusNode: _focusSink,
        child: Scaffold(
          backgroundColor: colors.surface,
          appBar: const SubbyAppBar(
            title: '구독 추가',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.s6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ServiceDropdown(),
                      const SizedBox(height: AppSpacing.s6),
                      _PlanSection(focusSink: _focusSink),
                      const _AmountCurrencySection(),
                      const SizedBox(height: AppSpacing.s6),
                      _BillingDaySection(focusSink: _focusSink),
                      const SizedBox(height: AppSpacing.s6),
                      _PeriodSection(focusSink: _focusSink),
                      const SizedBox(height: AppSpacing.s6),
                      const _CategorySection(),
                      const SizedBox(height: AppSpacing.s6),
                      const _MemoSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              const _SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 요금제 섹션 - selectedPreset, selectedPlan, period watch
class _PlanSection extends ConsumerWidget {
  final FocusNode focusSink;

  const _PlanSection({required this.focusSink});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider;
    final selectedPreset = ref.watch(provider.select((s) => s.selectedPreset));
    final selectedPlan = ref.watch(provider.select((s) => s.selectedPlan));
    final period = ref.watch(provider.select((s) => s.period));

    if (selectedPreset?.hasPlans != true) {
      return const SizedBox.shrink();
    }

    final vm = ref.read(provider.notifier);
    final colors = context.subbyColor;
    final locale = Localizations.localeOf(context);

    // 현재 선택된 결제주기에 맞는 요금제만 필터링
    final plans = selectedPreset!.plans.where((p) => p.period == period).toList();

    if (plans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('요금제', style: AppTypography.label.copyWith(color: colors.onSurface)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: plans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            return Padding(
              padding: EdgeInsets.only(right: index < plans.length - 1 ? AppSpacing.s2 : 0),
              child: SubbyChip(
                label: plan.displayName(locale),
                isSelected: selectedPlan == plan,
                onTap: () {
                  focusSink.requestFocus();
                  vm.selectPlan(plan);
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.s6),
      ],
    );
  }
}

/// 금액/통화 섹션 - amount, currency만 watch
class _AmountCurrencySection extends ConsumerStatefulWidget {
  const _AmountCurrencySection();

  @override
  ConsumerState<_AmountCurrencySection> createState() => _AmountCurrencySectionState();
}

class _AmountCurrencySectionState extends ConsumerState<_AmountCurrencySection> {
  final _amountController = TextEditingController(text: '0');
  final _amountFocusNode = FocusNode();

  static const _currencies = ['KRW', 'USD', 'JPY', 'EUR'];
  static const _currencyLabels = {
    'KRW': 'KRW  원 (₩)',
    'USD': 'USD  달러 (\$)',
    'JPY': 'JPY  엔 (¥)',
    'EUR': 'EUR  유로 (€)',
  };

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _syncAmountController(double amount, String currency) {
    if (!_amountFocusNode.hasFocus) {
      final text = currency == 'KRW'
          ? amount.toInt().toString()
          : amount.toString();
      if (_amountController.text != text) {
        _amountController.text = text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionAddViewModelProvider;
    final amount = ref.watch(provider.select((s) => s.amount));
    final currency = ref.watch(provider.select((s) => s.currency));
    final vm = ref.read(provider.notifier);

    _syncAmountController(amount, currency);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 금액
        Expanded(
          child: SubbyTextField(
            label: '금액',
            controller: _amountController,
            focusNode: _amountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0;
              vm.setAmount(currency == 'KRW'
                  ? parsed.roundToDouble()
                  : (parsed * 100).round() / 100);
            },
          ),
        ),
        const SizedBox(width: 10),
        // 통화
        SizedBox(
          width: 120,
          child: SubbyDropdown<String>(
            label: '통화',
            items: _currencies,
            value: currency,
            onChanged: (value) {
              if (value != null) vm.setCurrency(value);
            },
            itemBuilder: (item) => SubbyDropdownItem(
              label: _currencyLabels[item] ?? item,
              isSelected: currency == item,
            ),
          ),
        ),
      ],
    );
  }
}

/// 결제일 섹션 - billingDay, billingMonth, period watch
class _BillingDaySection extends ConsumerStatefulWidget {
  final FocusNode focusSink;

  const _BillingDaySection({required this.focusSink});

  @override
  ConsumerState<_BillingDaySection> createState() => _BillingDaySectionState();
}

class _BillingDaySectionState extends ConsumerState<_BillingDaySection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionAddViewModelProvider;
    final billingDay = ref.watch(provider.select((s) => s.billingDay));
    final billingMonth = ref.watch(provider.select((s) => s.billingMonth));
    final period = ref.watch(provider.select((s) => s.period));
    final vm = ref.read(provider.notifier);

    final colors = context.subbyColor;
    final isYearly = period == 'YEARLY';

    final displayText = isYearly && billingMonth != null
        ? '매년 $billingMonth월 $billingDay일'
        : '매월 $billingDay일';
    _controller.text = displayText;

    return SubbyTextField(
      label: '결제일',
      controller: _controller,
      readOnly: true,
      onTap: () async {
        widget.focusSink.requestFocus();
        if (isYearly) {
          final result = await showMonthDayPickerDialog(
            context: context,
            initialMonth: billingMonth ?? DateTime.now().month,
            initialDay: billingDay,
          );
          if (result != null) {
            vm.setBillingMonth(result.month);
            vm.setBillingDay(result.day);
          }
        } else {
          final result = await showDayPickerDialog(
            context: context,
            initialDay: billingDay,
          );
          if (result != null) vm.setBillingDay(result);
        }
      },
      suffix: AppIcon(AppIconType.calendar, size: 24, color: colors.onSurfaceVariant),
    );
  }
}

/// 결제 주기 섹션 - period만 watch
class _PeriodSection extends ConsumerWidget {
  final FocusNode focusSink;

  const _PeriodSection({required this.focusSink});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider;
    final period = ref.watch(provider.select((s) => s.period));
    final vm = ref.read(provider.notifier);

    final colors = context.subbyColor;

    const periods = [('MONTHLY', '매월'), ('YEARLY', '매년')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 주기', style: AppTypography.label.copyWith(color: colors.onSurface)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: periods.map((p) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: p.$1 != 'YEARLY' ? AppSpacing.s2 : 0),
                child: SubbyChip(
                  label: p.$2,
                  isSelected: period == p.$1,
                  onTap: () {
                    focusSink.requestFocus();
                    vm.setPeriod(p.$1);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 카테고리 섹션 - category만 watch
class _CategorySection extends ConsumerWidget {
  const _CategorySection();

  static const _categories = ['영상', '음악', '게임', 'AI', '소프트웨어', '교육', '금융', '멤버십'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider;
    final category = ref.watch(provider.select((s) => s.category));
    final vm = ref.read(provider.notifier);

    return SubbyDropdown<String>(
      label: '카테고리',
      hint: '카테고리를 선택해 주세요',
      items: _categories,
      value: category,
      onChanged: (value) {
        if (value != null) vm.setCategory(value);
      },
      itemBuilder: (item) => SubbyDropdownItem(
        label: item,
        isSelected: category == item,
      ),
    );
  }
}

/// 메모 섹션 - memo만 watch
class _MemoSection extends ConsumerStatefulWidget {
  const _MemoSection();

  @override
  ConsumerState<_MemoSection> createState() => _MemoSectionState();
}

class _MemoSectionState extends ConsumerState<_MemoSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionAddViewModelProvider;
    final vm = ref.read(provider.notifier);

    return SubbyTextField(
      label: '메모',
      hint: '메모를 입력해 주세요',
      controller: _controller,
      onChanged: vm.setMemo,
    );
  }
}

/// 저장 버튼 - isSaving만 watch
class _SaveButton extends ConsumerWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider;
    final isSaving = ref.watch(provider.select((s) => s.isSaving));

    final colors = context.subbyColor;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
      ),
      child: SubbyButton(
        label: '저장하기',
        onPressed: isSaving ? null : () => _onSave(context, ref),
        isExpanded: true,
        isEnabled: !isSaving,
      ),
    );
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final provider = subscriptionAddViewModelProvider;
    final state = ref.read(provider);
    final vm = ref.read(provider.notifier);

    if (state.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서비스를 선택해주세요')),
      );
      return;
    }
    if (state.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금액을 입력해주세요')),
      );
      return;
    }

    final success = await vm.save();
    if (success && context.mounted) {
      Navigator.pop(context);
    }
  }
}
