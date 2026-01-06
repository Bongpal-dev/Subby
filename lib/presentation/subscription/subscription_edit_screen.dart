import 'package:flutter/material.dart';
import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';

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
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _feeController = TextEditingController();

  String _currency = 'KRW';
  int _billingDay = 1;
  String _period = 'MONTHLY';
  String? _category;
  DateTime _createdAt = DateTime.now();

  bool _isLoading = true;

  final List<String> _categories = ['영상', '음악', '게임', '소프트웨어', '기타'];

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
        _amountController.text = subscription.amount.toString();
        _currency = subscription.currency;
        _billingDay = subscription.billingDay;
        _period = subscription.period;
        _category = subscription.category;
        _memoController.text = subscription.memo ?? '';
        _feeController.text = subscription.feeRatePercent?.toString() ?? '';
        _createdAt = subscription.createdAt;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('구독 수정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 수정'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _onDelete,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '서비스명',
                hintText: 'Netflix, Spotify 등',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '서비스명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: '금액',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '금액을 입력해주세요';
                      }
                      if (double.tryParse(value) == null) {
                        return '숫자만 입력해주세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: const InputDecoration(
                      labelText: '통화',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'KRW', child: Text('₩ KRW')),
                      DropdownMenuItem(value: 'USD', child: Text('\$ USD')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _billingDay,
                    decoration: const InputDecoration(
                      labelText: '결제일',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(31, (i) => i + 1)
                        .map((day) => DropdownMenuItem(
                              value: day,
                              child: Text('$day일'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _billingDay = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _period,
                    decoration: const InputDecoration(
                      labelText: '결제 주기',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'MONTHLY', child: Text('매월')),
                      DropdownMenuItem(value: 'YEARLY', child: Text('매년')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _period = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: '카테고리 (선택)',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: '메모 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _feeController,
              decoration: const InputDecoration(
                labelText: '수수료 % (선택)',
                hintText: '해외결제 수수료 등',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _onSave,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('저장', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      final subscription = Subscription(
        id: widget.subscriptionId,
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        currency: _currency,
        billingDay: _billingDay,
        period: _period,
        category: _category,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
        feeRatePercent: _feeController.text.isEmpty
            ? null
            : double.tryParse(_feeController.text),
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
