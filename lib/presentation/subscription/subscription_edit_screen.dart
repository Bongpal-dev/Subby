import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
    _memoController.dispose();
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

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: SubbyAppBar(
        title: '구독 수정',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _onDelete(vm),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 서비스명 (읽기 전용)
                  AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.subscriptions_outlined, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          state.name,
                          style: AppTypography.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 통화 + 금액 그룹
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('통화', style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 8),
                        SegmentedSelector(
                          options: const ['KRW', 'USD'],
                          labels: const ['\u20a9 원화', '\$ 달러'],
                          selected: state.currency,
                          onChanged: vm.setCurrency,
                        ),
                        const SizedBox(height: 20),

                        Text('금액', style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            AmountButton(
                              icon: Icons.remove,
                              onTap: () => vm.changeAmount(-1),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showAmountInput(state, vm),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      vm.formatAmount(),
                                      style: AppTypography.displaySmall.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AmountButton(
                              icon: Icons.add,
                              onTap: () => vm.changeAmount(1),
                              isPrimary: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StepSelector(
                          currency: state.currency,
                          currentStep: state.currency == 'KRW'
                              ? state.amountStepKRW
                              : state.amountStepUSD,
                          onStepChanged: vm.setAmountStep,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 결제일 + 결제 주기 그룹
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('결제일', style: Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _showDayPicker(state, vm),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '매월 ${state.billingDay}일',
                                      style: AppTypography.titleLarge.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('결제 주기', style: Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 8),
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
                  const SizedBox(height: 12),

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
              padding: const EdgeInsets.all(16),
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
                      : Text('저장', style: AppTypography.titleLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountInput(SubscriptionEditState state, SubscriptionEditViewModel vm) {
    final controller = TextEditingController(
      text: state.amount > 0 ? (state.currency == 'KRW' ? state.amount.toInt().toString() : state.amount.toString()) : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('금액 입력'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: InputDecoration(
            prefixText: state.currency == 'KRW' ? '\u20a9 ' : '\$ ',
            hintText: state.currency == 'KRW' ? '0' : '0.00',
          ),
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text) ?? 0;
              if (state.currency == 'KRW') {
                vm.setAmount(value.roundToDouble());
              } else {
                vm.setAmount((value * 100).round() / 100);
              }
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker(SubscriptionEditState state, SubscriptionEditViewModel vm) {
    int tempDay = state.billingDay;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '결제일 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 44,
                  ),
                  itemCount: 31,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final isSelected = tempDay == day;
                    return GestureDetector(
                      onTap: () => setDialogState(() => tempDay = day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '매월 $tempDay일',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          vm.setBillingDay(tempDay);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
