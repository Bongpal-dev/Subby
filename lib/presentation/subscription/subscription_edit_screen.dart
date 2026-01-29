import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/subby_app_bar.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_edit_view_model.dart';

class SubscriptionEditScreen extends ConsumerStatefulWidget {
  final String subscriptionId;

  const SubscriptionEditScreen({
    super.key,
    required this.subscriptionId,
  });

  @override
  ConsumerState<SubscriptionEditScreen> createState() => _SubscriptionEditScreenState();
}

class _SubscriptionEditScreenState extends ConsumerState<SubscriptionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _memoController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  final _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _memoController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionEditViewModelProvider(widget.subscriptionId));
    final vm = ref.read(subscriptionEditViewModelProvider(widget.subscriptionId).notifier);

    if (state.isLoading) {
      return Scaffold(
        appBar: const SubbyAppBar(title: '구독 수정'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Sync memo controller
    if (_memoController.text != state.memo) {
      _memoController.text = state.memo;
    }

    // Sync amount controller (only when not focused)
    if (!_amountFocusNode.hasFocus) {
      final amountText = state.currency == 'KRW'
          ? state.amount.toInt().toString()
          : state.amount.toString();
      if (_amountController.text != amountText) {
        _amountController.text = amountText;
      }
    }

    final colorScheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: const SubbyAppBar(
        title: '구독 수정',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(AppSpacing.s4),
                children: [
                  // 서비스명 (읽기 전용)
                  AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.subscriptions_outlined, color: colorScheme.primary),
                        SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: Text(
                            state.name,
                            style: AppTypography.headline,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: colors.statusError),
                          onPressed: () => _onDelete(vm),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.s3),

                  // 통화 + 금액 그룹
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('통화', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.s2),
                        SegmentedSelector(
                          options: const ['KRW', 'USD'],
                          labels: const ['\u20a9 원화', '\$ 달러'],
                          selected: state.currency,
                          onChanged: vm.setCurrency,
                        ),
                        SizedBox(height: AppSpacing.s4),

                        Text('금액', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.s3),
                        _buildAmountTextField(state, vm, colorScheme),
                        SizedBox(height: AppSpacing.s3),
                        AmountAdder(
                          currency: state.currency,
                          onAdd: (step) => vm.setAmount(state.amount + step),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.s3),

                  // 결제일 + 결제 주기 그룹
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('결제일', style: Theme.of(context).textTheme.labelSmall),
                              SizedBox(height: AppSpacing.s2),
                              GestureDetector(
                                onTap: () async {
                                final result = await showDayPickerDialog(
                                  context: context,
                                  initialDay: state.billingDay,
                                );

                                if (result != null) {
                                  vm.setBillingDay(result);
                                }
                              },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: AppSpacing.s4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '매월 ${state.billingDay}일',
                                      style: AppTypography.title.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('결제 주기', style: Theme.of(context).textTheme.labelSmall),
                              SizedBox(height: AppSpacing.s2),
                              SegmentedSelector(
                                options: const ['MONTHLY', 'YEARLY'],
                                labels: const ['매월', '매년'],
                                selected: state.period,
                                onChanged: vm.setPeriod,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.s3),

                  // 메모
                  AppCard(
                    child: AppTextField(
                      label: '메모 (선택)',
                      hint: '메모를 입력하세요',
                      controller: _memoController,
                      onChanged: vm.setMemo,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // 저장 버튼 - 하단 고정
            Container(
              padding: EdgeInsets.all(AppSpacing.s4),
              child: SafeArea(
                child: FilledButton(
                  onPressed: state.isSaving ? null : () => _onSave(state, vm),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('저장', style: AppTypography.title),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountTextField(
    SubscriptionEditState state,
    SubscriptionEditViewModel vm,
    ColorScheme colorScheme,
  ) {
    final prefix = state.currency == 'KRW' ? '\u20a9 ' : '\$ ';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _amountController,
        focusNode: _amountFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: AppTypography.display.copyWith(
          color: colorScheme.primary,
        ),
        decoration: InputDecoration(
          prefixText: prefix,
          prefixStyle: AppTypography.display.copyWith(
            color: colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSpacing.s4),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            _amountController.text = '0';
            _amountController.selection = TextSelection.fromPosition(
              const TextPosition(offset: 1),
            );
            vm.setAmount(0);
            return;
          }

          // '0'으로 시작하고 두 번째가 숫자면 앞의 '0' 제거
          if (value.length >= 2 &&
              value.startsWith('0') &&
              value[1] != '.') {
            final newValue = value.substring(1);
            _amountController.text = newValue;
            _amountController.selection = TextSelection.fromPosition(
              TextPosition(offset: newValue.length),
            );
            final parsed = double.tryParse(newValue) ?? 0;
            if (state.currency == 'KRW') {
              vm.setAmount(parsed.roundToDouble());
            } else {
              vm.setAmount((parsed * 100).round() / 100);
            }
            return;
          }

          final parsed = double.tryParse(value) ?? 0;
          if (state.currency == 'KRW') {
            vm.setAmount(parsed.roundToDouble());
          } else {
            vm.setAmount((parsed * 100).round() / 100);
          }
        },
      ),
    );
  }

  Future<void> _onSave(SubscriptionEditState state, SubscriptionEditViewModel vm) async {
    if (_formKey.currentState!.validate()) {
      if (state.amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금액을 입력해주세요')),
        );
        return;
      }

      final success = await vm.save();
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _onDelete(SubscriptionEditViewModel vm) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('구독 삭제'),
        content: const Text('이 구독을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final success = await vm.delete();
              if (success && mounted) {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
