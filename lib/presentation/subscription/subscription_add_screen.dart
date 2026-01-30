import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';
import 'package:subby/presentation/subscription/widgets/service_dropdown.dart';

class SubscriptionAddScreen extends ConsumerStatefulWidget {
  final String? editSubscriptionId;

  const SubscriptionAddScreen({
    super.key,
    this.editSubscriptionId,
  });

  bool get isEditMode => editSubscriptionId != null;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return GestureDetector(
      onTap: () => _focusSink.requestFocus(),
      child: Focus(
        focusNode: _focusSink,
        child: Scaffold(
          backgroundColor: colors.bgPrimary,
          appBar: AppAppBar(
            title: widget.isEditMode ? '구독 수정' : '구독 추가',
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
                      ServiceDropdown(editSubscriptionId: widget.editSubscriptionId),
                      const SizedBox(height: AppSpacing.s6),
                      _PlanSection(
                        editSubscriptionId: widget.editSubscriptionId,
                        focusSink: _focusSink,
                      ),
                      _AmountCurrencySection(
                        editSubscriptionId: widget.editSubscriptionId,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _BillingDaySection(
                        editSubscriptionId: widget.editSubscriptionId,
                        focusSink: _focusSink,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _PeriodSection(
                        editSubscriptionId: widget.editSubscriptionId,
                        focusSink: _focusSink,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _CategorySection(
                        editSubscriptionId: widget.editSubscriptionId,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _MemoSection(
                        editSubscriptionId: widget.editSubscriptionId,
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _SaveButton(
                editSubscriptionId: widget.editSubscriptionId,
                isEditMode: widget.isEditMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 요금제 섹션 - selectedPreset, selectedPlan만 watch
class _PlanSection extends ConsumerWidget {
  final String? editSubscriptionId;
  final FocusNode focusSink;

  const _PlanSection({
    required this.editSubscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
    final selectedPreset = ref.watch(provider.select((s) => s.selectedPreset));
    final selectedPlan = ref.watch(provider.select((s) => s.selectedPlan));

    if (selectedPreset?.hasPlans != true) {
      return const SizedBox.shrink();
    }

    final vm = ref.read(provider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final locale = Localizations.localeOf(context);
    final plans = selectedPreset!.plans;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('요금제', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: plans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            return Padding(
              padding: EdgeInsets.only(right: index < plans.length - 1 ? AppSpacing.s2 : 0),
              child: AppChip(
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
  final String? editSubscriptionId;

  const _AmountCurrencySection({
    required this.editSubscriptionId,
  });

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
    final provider = subscriptionAddViewModelProvider(widget.editSubscriptionId);
    final amount = ref.watch(provider.select((s) => s.amount));
    final currency = ref.watch(provider.select((s) => s.currency));
    final vm = ref.read(provider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    _syncAmountController(amount, currency);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 금액
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('금액', style: AppTypography.label.copyWith(color: colors.textPrimary)),
              const SizedBox(height: AppSpacing.s2),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.bgTertiary,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colors.borderSecondary),
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(color: colors.textPrimary),
                    decoration: const InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s4,
                        vertical: AppSpacing.s4,
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      vm.setAmount(currency == 'KRW'
                          ? parsed.roundToDouble()
                          : (parsed * 100).round() / 100);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // 통화
        SizedBox(
          width: 120,
          child: AppDropdown<String>(
            label: '통화',
            items: _currencies,
            value: currency,
            onChanged: (value) {
              if (value != null) vm.setCurrency(value);
            },
            itemBuilder: (item) => AppDropdownItem(
              label: _currencyLabels[item] ?? item,
              isSelected: currency == item,
            ),
          ),
        ),
      ],
    );
  }
}

/// 결제일 섹션 - billingDay만 watch
class _BillingDaySection extends ConsumerWidget {
  final String? editSubscriptionId;
  final FocusNode focusSink;

  const _BillingDaySection({
    required this.editSubscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
    final billingDay = ref.watch(provider.select((s) => s.billingDay));
    final vm = ref.read(provider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제일', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        GestureDetector(
          onTap: () async {
            focusSink.requestFocus();
            final result = await showDayPickerDialog(
              context: context,
              initialDay: billingDay,
            );
            if (result != null) vm.setBillingDay(result);
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            decoration: BoxDecoration(
              color: colors.bgTertiary,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: colors.borderSecondary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '매월 ${billingDay}일',
                    style: AppTypography.body.copyWith(color: colors.textPrimary),
                  ),
                ),
                AppIcon(AppIconType.calendar, size: 24, color: colors.iconSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 결제 주기 섹션 - period만 watch
class _PeriodSection extends ConsumerWidget {
  final String? editSubscriptionId;
  final FocusNode focusSink;

  const _PeriodSection({
    required this.editSubscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
    final period = ref.watch(provider.select((s) => s.period));
    final vm = ref.read(provider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    const periods = [('WEEKLY', '매주'), ('MONTHLY', '매월'), ('YEARLY', '매년')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 주기', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: periods.map((p) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: p.$1 != 'YEARLY' ? AppSpacing.s2 : 0),
                child: AppChip(
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
  final String? editSubscriptionId;

  const _CategorySection({
    required this.editSubscriptionId,
  });

  static const _categories = ['영상', '음악', '게임', 'AI', '소프트웨어', '교육', '금융', '멤버십'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
    final category = ref.watch(provider.select((s) => s.category));
    final vm = ref.read(provider.notifier);

    return AppDropdown<String>(
      label: '카테고리',
      hint: '카테고리를 선택해 주세요',
      items: _categories,
      value: category,
      onChanged: (value) {
        if (value != null) vm.setCategory(value);
      },
      itemBuilder: (item) => AppDropdownItem(
        label: item,
        isSelected: category == item,
      ),
    );
  }
}

/// 메모 섹션 - memo만 watch
class _MemoSection extends ConsumerStatefulWidget {
  final String? editSubscriptionId;

  const _MemoSection({
    required this.editSubscriptionId,
  });

  @override
  ConsumerState<_MemoSection> createState() => _MemoSectionState();
}

class _MemoSectionState extends ConsumerState<_MemoSection> {
  final _controller = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionAddViewModelProvider(widget.editSubscriptionId);
    final memo = ref.watch(provider.select((s) => s.memo));
    final vm = ref.read(provider.notifier);

    // 초기값 동기화 (한 번만)
    if (!_initialized && memo.isNotEmpty) {
      _controller.text = memo;
      _initialized = true;
    }

    return AppTextField(
      label: '메모',
      hint: '메모를 입력해 주세요',
      controller: _controller,
      onChanged: vm.setMemo,
    );
  }
}

/// 저장 버튼 - isSaving만 watch
class _SaveButton extends ConsumerWidget {
  final String? editSubscriptionId;
  final bool isEditMode;

  const _SaveButton({
    required this.editSubscriptionId,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
    final isSaving = ref.watch(provider.select((s) => s.isSaving));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(top: BorderSide(color: colors.borderSecondary)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
      ),
      child: AppButton(
        label: '저장하기',
        onPressed: isSaving ? null : () => _onSave(context, ref),
        isExpanded: true,
        isEnabled: !isSaving,
      ),
    );
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final provider = subscriptionAddViewModelProvider(editSubscriptionId);
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

    final bool success;
    if (isEditMode) {
      success = await vm.update(editSubscriptionId!);
    } else {
      success = await vm.save();
    }

    if (success && context.mounted) {
      // 편집 모드: true 반환하여 상세 화면에서 refresh
      // 추가 모드: 단순 pop
      Navigator.pop(context, isEditMode ? true : null);
    }
  }
}
