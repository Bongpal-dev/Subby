import 'package:flutter/material.dart';
import 'package:bongpal/presentation/subscription/subscription_add_screen.dart';
import 'package:bongpal/presentation/subscription/subscription_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: 나중에 DB에서 가져올 더미 데이터
  static const _dummySubscriptions = [
    {'id': '1', 'name': 'Netflix', 'amount': 15.99, 'currency': 'USD', 'billingDay': 15},
    {'id': '2', 'name': 'Spotify', 'amount': 10900, 'currency': 'KRW', 'billingDay': 20},
    {'id': '3', 'name': 'YouTube Premium', 'amount': 14900, 'currency': 'KRW', 'billingDay': 5},
  ];

  @override
  Widget build(BuildContext context) {
    final subscriptions = _dummySubscriptions;
    final isEmpty = subscriptions.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이번 달 고정비', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const _SummaryCard(),
              const SizedBox(height: 16),
              const Text('구독 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: isEmpty
                    ? const _EmptyState()
                    : _SubscriptionList(subscriptions: subscriptions),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubscriptionAddScreen()),
          );
        },
        label: const Text('구독 추가'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('예상 합계'),
            Text('₩ 40,800', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '아직 등록된 구독이 없습니다.\n오른쪽 아래에서 추가해 주세요.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  final List<Map<String, dynamic>> subscriptions;

  const _SubscriptionList({required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final item = subscriptions[index];
        return _SubscriptionTile(
          id: item['id'] as String,
          name: item['name'] as String,
          amount: item['amount'] as num,
          currency: item['currency'] as String,
          billingDay: item['billingDay'] as int,
        );
      },
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  final String id;
  final String name;
  final num amount;
  final String currency;
  final int billingDay;

  const _SubscriptionTile({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingDay,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = currency == 'USD' ? '\$' : '₩';
    final formattedAmount = currency == 'USD'
        ? amount.toStringAsFixed(2)
        : amount.toInt().toString().replaceAllMapped(
              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]},',
            );

    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('매월 $billingDay일 결제'),
        trailing: Text(
          '$currencySymbol$formattedAmount',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionEditScreen(subscriptionId: id),
            ),
          );
        },
      ),
    );
  }
}
