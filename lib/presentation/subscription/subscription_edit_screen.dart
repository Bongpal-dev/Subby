import 'package:flutter/material.dart';
import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';
import 'package:bongpal/presentation/common/subby_app_bar.dart';

class SubscriptionEditScreen extends StatefulWidget {
  final String subscriptionId;
  final GetSubscriptionByIdUseCase getSubscriptionById;
  final UpdateSubscriptionUseCase updateSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;

  const SubscriptionEditScreen({
    super.key,
    required this.subscriptionId,
    required this.getSubscriptionById,
    required this.updateSubscription,
    required this.deleteSubscription,
  });

  @override
  State<SubscriptionEditScreen> createState() => _SubscriptionEditScreenState();
}

class _SubscriptionEditScreenState extends State<SubscriptionEditScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _memoController = TextEditingController();

  String _currency = 'KRW';
  double _amount = 0;
  int _amountStepKRW = 1000;
  double _amountStepUSD = 1;
  int _billingDay = 15;
  String _period = 'MONTHLY';
  String? _category;
  DateTime _createdAt = DateTime.now();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    final subscription = await widget.getSubscriptionById(widget.subscriptionId);
    if (subscription != null && mounted) {
      setState(() {
        _nameController.text = subscription.name;
        _amount = subscription.amount;
        _currency = subscription.currency;
        _billingDay = subscription.billingDay;
        _period = subscription.period;
        _category = subscription.category;
        _memoController.text = subscription.memo ?? '';
        _createdAt = subscription.createdAt;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _changeAmount(int direction) {
    setState(() {
      if (_currency == 'KRW') {
        _amount = (_amount + direction * _amountStepKRW).clamp(0, double.infinity);
      } else {
        _amount = ((_amount + direction * _amountStepUSD) * 100).round() / 100;
        _amount = _amount.clamp(0, double.infinity);
      }
    });
  }

  String _formatAmount() {
    if (_currency == 'KRW') {
      return '₩${_amount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else {
      return '\$${_amount.toStringAsFixed(2)}';
    }
  }

  void _showAmountInput() {
    final controller = TextEditingController(
      text: _amount > 0 ? (_currency == 'KRW' ? _amount.toInt().toString() : _amount.toString()) : '',
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
            prefixText: _currency == 'KRW' ? '₩ ' : '\$ ',
            hintText: _currency == 'KRW' ? '0' : '0.00',
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
              setState(() {
                if (_currency == 'KRW') {
                  _amount = value.roundToDouble();
                } else {
                  _amount = (value * 100).round() / 100;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker() {
    int tempDay = _billingDay;
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
                          setState(() => _billingDay = tempDay);
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const SubbyAppBar(title: '구독 수정'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: SubbyAppBar(
        title: '구독 수정',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _onDelete,
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
                  _buildCard(
                    child: Row(
                      children: [
                        Icon(Icons.subscriptions_outlined, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          _nameController.text,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 통화 + 금액 그룹
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('통화'),
                        const SizedBox(height: 8),
                        _buildSegmentedButton(
                          options: const ['KRW', 'USD'],
                          labels: const ['₩ 원화', '\$ 달러'],
                          selected: _currency,
                          onChanged: (value) {
                            setState(() {
                              _currency = value;
                              _amount = 0;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('금액'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildAmountButton(
                              icon: Icons.remove,
                              onTap: () => _changeAmount(-1),
                              isPrimary: false,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showAmountInput,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _formatAmount(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildAmountButton(
                              icon: Icons.add,
                              onTap: () => _changeAmount(1),
                              isPrimary: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStepSelector(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 결제일 + 결제 주기 그룹
                  _buildCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('결제일'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showDayPicker,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '매월 $_billingDay일',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                              _buildLabel('결제 주기'),
                              const SizedBox(height: 8),
                              _buildSegmentedButton(
                                options: const ['MONTHLY', 'YEARLY'],
                                labels: const ['매월', '매년'],
                                selected: _period,
                                onChanged: (value) => setState(() => _period = value),
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
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('메모 (선택)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _memoController,
                          decoration: const InputDecoration(
                            hintText: '메모를 입력하세요',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 3,
                        ),
                      ],
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
                  onPressed: _onSave,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('저장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildSegmentedButton({
    required List<String> options,
    required List<String> labels,
    required String selected,
    required void Function(String) onChanged,
    bool compact = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = selected == options[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(options[index]),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: compact ? 10 : 12),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: compact ? 13 : 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAmountButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isPrimary ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 28,
          color: isPrimary ? Colors.white : colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildStepSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = _currency == 'KRW'
        ? [100, 1000, 10000]
        : [0.1, 1.0, 10.0];
    final currentStep = _currency == 'KRW' ? _amountStepKRW : _amountStepUSD;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: steps.map((step) {
          final isSelected = (_currency == 'KRW' && step == currentStep) ||
              (_currency == 'USD' && step == currentStep);
          final label = _currency == 'KRW'
              ? '₩${(step as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
              : '\$${(step as double).toString().replaceAll(RegExp(r'\.0$'), '')}';

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_currency == 'KRW') {
                    _amountStepKRW = step as int;
                  } else {
                    _amountStepUSD = step as double;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      if (_amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금액을 입력해주세요')),
        );
        return;
      }

      final subscription = Subscription(
        id: widget.subscriptionId,
        name: _nameController.text,
        amount: _amount,
        currency: _currency,
        billingDay: _billingDay,
        period: _period,
        category: _category,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
        createdAt: _createdAt,
      );

      await widget.updateSubscription(subscription);
      if (mounted) Navigator.pop(context);
    }
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('구독 삭제'),
        content: const Text('이 구독을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await widget.deleteSubscription(widget.subscriptionId);
              if (mounted) {
                Navigator.pop(context);
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
