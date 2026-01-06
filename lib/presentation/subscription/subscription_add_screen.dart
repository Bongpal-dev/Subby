import 'package:flutter/material.dart';

class SubscriptionAddScreen extends StatefulWidget {
  const SubscriptionAddScreen({super.key});

  @override
  State<SubscriptionAddScreen> createState() => _SubscriptionAddScreenState();
}

class _SubscriptionAddScreenState extends State<SubscriptionAddScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _feeController = TextEditingController();
  
  String _currency = 'KRW';
  int _billingDay = 1;
  String _period = 'MONTHLY';
  String? _category;

  final List<String> _categories = ['영상', '음악', '게임', '소프트웨어', '기타'];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('구독 추가'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 서비스명
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

            // 금액 + 통화
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

            // 결제일 + 주기
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

            // 카테고리
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

            // 메모
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: '메모 (선택)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // 수수료
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

            // 저장 버튼
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

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: DB 저장 로직
      Navigator.pop(context);
    }
  }
}
