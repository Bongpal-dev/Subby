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
  const SubscriptionAddScreen({super.key});

  @override
  ConsumerState<SubscriptionAddScreen> createState() => _SubscriptionAddScreenState();
}

class _SubscriptionAddScreenState extends ConsumerState<SubscriptionAddScreen> {
  final _memoController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  final _amountFocusNode = FocusNode();
  // 키보드 닫기용 포커스 싱크 (포커스를 받지만 키보드를 띄우지 않음)
  final _focusSink = FocusNode(skipTraversal: true);

  static const _currencies = ['KRW', 'USD', 'JPY', 'EUR'];
  static const _currencyLabels = {
    'KRW': 'KRW  원 (₩)',
    'USD': 'USD  달러 (\$)',
    'JPY': 'JPY  엔 (¥)',
    'EUR': 'EUR  유로 (€)',
  };
  static const _categories = ['영상', '음악', '게임', 'AI', '소프트웨어', '교육', '금융', '멤버십'];

  @override
  void dispose() {
    _memoController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    _focusSink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionAddViewModelProvider);
    final vm = ref.read(subscriptionAddViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    _syncAmountController(state);

    return GestureDetector(
      onTap: () => _focusSink.requestFocus(),
      child: Focus(
        focusNode: _focusSink,
        child: Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: const AppAppBar(
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
                  if (state.selectedPreset?.hasPlans == true) ...[
                    _buildPlanSection(state, vm, colors),
                    const SizedBox(height: AppSpacing.s6),
                  ],
                  _buildAmountCurrencyRow(state, vm, colors),
                  const SizedBox(height: AppSpacing.s6),
                  _buildBillingDayField(state, vm, colors),
                  const SizedBox(height: AppSpacing.s6),
                  _buildPeriodSection(state, vm, colors),
                  const SizedBox(height: AppSpacing.s6),
                  _buildCategoryDropdown(state, vm),
                  const SizedBox(height: AppSpacing.s6),
                  AppTextField(
                    label: '메모',
                    hint: '메모를 입력해 주세요',
                    controller: _memoController,
                    onChanged: vm.setMemo,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomButton(state, colors),
        ],
      ),
      ),
      ),
    );
  }

  void _syncAmountController(SubscriptionAddState state) {
    if (!_amountFocusNode.hasFocus) {
      final text = state.currency == 'KRW'
          ? state.amount.toInt().toString()
          : state.amount.toString();
      if (_amountController.text != text) {
        _amountController.text = text;
      }
    }
  }

  Widget _buildPlanSection(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    AppColorScheme colors,
  ) {
    final locale = Localizations.localeOf(context);
    final plans = state.selectedPreset?.plans ?? [];

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
                isSelected: state.selectedPlan == plan,
                onTap: () {
                  _focusSink.requestFocus();
                  vm.selectPlan(plan);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAmountCurrencyRow(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    AppColorScheme colors,
  ) {
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
                      vm.setAmount(state.currency == 'KRW'
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
        // 통화 - AppDropdown 사용
        SizedBox(
          width: 120,
          child: AppDropdown<String>(
            label: '통화',
            items: _currencies,
            value: state.currency,
            onChanged: (value) {
              if (value != null) vm.setCurrency(value);
            },
            itemBuilder: (item) => AppDropdownItem(
              label: _currencyLabels[item] ?? item,
              isSelected: state.currency == item,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingDayField(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    AppColorScheme colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제일', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        GestureDetector(
          onTap: () async {
            _focusSink.requestFocus();
            final result = await showDayPickerDialog(
              context: context,
              initialDay: state.billingDay,
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
                    '매월 ${state.billingDay}일',
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

  Widget _buildPeriodSection(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    AppColorScheme colors,
  ) {
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
                  isSelected: state.period == p.$1,
                  onTap: () {
                    _focusSink.requestFocus();
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

  Widget _buildCategoryDropdown(SubscriptionAddState state, SubscriptionAddViewModel vm) {
    return AppDropdown<String>(
      label: '카테고리',
      hint: '카테고리를 선택해 주세요',
      items: _categories,
      value: state.category,
      onChanged: (value) {
        if (value != null) vm.setCategory(value);
      },
      itemBuilder: (item) => AppDropdownItem(
        label: item,
        isSelected: state.category == item,
      ),
    );
  }

  Widget _buildBottomButton(SubscriptionAddState state, AppColorScheme colors) {
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
        onPressed: state.isSaving ? null : _onSave,
        isExpanded: true,
        isEnabled: !state.isSaving,
      ),
    );
  }

  Future<void> _onSave() async {
    final state = ref.read(subscriptionAddViewModelProvider);
    final vm = ref.read(subscriptionAddViewModelProvider.notifier);

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
    if (success && mounted) Navigator.pop(context);
  }
}
