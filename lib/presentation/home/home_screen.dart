import 'package:flutter/material.dart';
import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/usecase/add_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/watch_subscriptions_usecase.dart';
import 'package:bongpal/presentation/subscription/subscription_add_screen.dart';
import 'package:bongpal/presentation/subscription/subscription_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  final WatchSubscriptionsUseCase watchSubscriptions;
  final AddSubscriptionUseCase addSubscription;
  final GetSubscriptionByIdUseCase getSubscriptionById;
  final UpdateSubscriptionUseCase updateSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;

  const HomeScreen({
    super.key,
    required this.watchSubscriptions,
    required this.addSubscription,
    required this.getSubscriptionById,
    required this.updateSubscription,
    required this.deleteSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이번 달 고정비', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              StreamBuilder<List<Subscription>>(
                stream: watchSubscriptions(),
                builder: (context, snapshot) {
                  final subscriptions = snapshot.data ?? [];
                  final total = _calculateTotal(subscriptions);
                  return _SummaryCard(total: total);
                },
              ),
              const SizedBox(height: 16),
              const Text('구독 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<Subscription>>(
                  stream: watchSubscriptions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final subscriptions = snapshot.data ?? [];
                    if (subscriptions.isEmpty) {
                      return const _EmptyState();
                    }
                    return _SubscriptionList(
                      subscriptions: subscriptions,
                      onTap: (sub) => _navigateToEdit(context, sub.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAdd(context),
        label: const Text('구독 추가'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionAddScreen(
          addSubscription: addSubscription,
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionEditScreen(
          subscriptionId: id,
          getSubscriptionById: getSubscriptionById,
          updateSubscription: updateSubscription,
          deleteSubscription: deleteSubscription,
        ),
      ),
    );
  }

  double _calculateTotal(List<Subscription> subscriptions) {
    double total = 0;
    for (final sub in subscriptions) {
      if (sub.currency == 'KRW') {
        total += sub.amount;
      } else {
        total += sub.amount * 1450;
      }
    }
    return total;
  }
}

class _SummaryCard extends StatelessWidget {
  final double total;

  const _SummaryCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final formatted = total.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('예상 합계'),
            Text('₩ $formatted', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
  final List<Subscription> subscriptions;
  final void Function(Subscription) onTap;

  const _SubscriptionList({
    required this.subscriptions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final sub = subscriptions[index];
        return _SubscriptionTile(subscription: sub, onTap: () => onTap(sub));
      },
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  final Subscription subscription;
  final VoidCallback onTap;

  const _SubscriptionTile({
    required this.subscription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = subscription.currency == 'USD' ? '\$' : '₩';
    final formattedAmount = subscription.currency == 'USD'
        ? subscription.amount.toStringAsFixed(2)
        : subscription.amount.toInt().toString().replaceAllMapped(
              RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]},',
            );

    return Card(
      child: ListTile(
        title: Text(subscription.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('매월 ${subscription.billingDay}일 결제'),
        trailing: Text(
          '$currencySymbol$formattedAmount',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    );
  }
}
