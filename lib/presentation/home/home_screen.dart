import 'package:flutter/material.dart';
import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/usecase/add_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/get_presets_usecase.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/watch_subscriptions_usecase.dart';
import 'package:bongpal/presentation/common/subby_app_bar.dart';
import 'package:bongpal/presentation/subscription/subscription_add_screen.dart';
import 'package:bongpal/presentation/subscription/subscription_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  final WatchSubscriptionsUseCase watchSubscriptions;
  final AddSubscriptionUseCase addSubscription;
  final GetSubscriptionByIdUseCase getSubscriptionById;
  final UpdateSubscriptionUseCase updateSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;
  final GetPresetsUseCase getPresets;

  const HomeScreen({
    super.key,
    required this.watchSubscriptions,
    required this.addSubscription,
    required this.getSubscriptionById,
    required this.updateSubscription,
    required this.deleteSubscription,
    required this.getPresets,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const SubbyAppBar(title: '', showBackButton: false),
      body: StreamBuilder<List<Subscription>>(
          stream: watchSubscriptions(),
          builder: (context, snapshot) {
            final subscriptions = snapshot.data ?? [];
            final total = _calculateTotal(subscriptions);

            return Column(
              children: [
                // 상단 헤더
                _HeaderCard(total: total),

                // 구독 목록
                Expanded(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : subscriptions.isEmpty
                          ? const _EmptyState()
                          : _SubscriptionList(
                              subscriptions: subscriptions,
                              onTap: (sub) => _navigateToEdit(context, sub.id),
                            ),
                ),

                // 하단 추가 버튼
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _navigateToAdd(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '+ 구독 추가하기',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionAddScreen(
          addSubscription: addSubscription,
          getPresets: getPresets,
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

class _HeaderCard extends StatelessWidget {
  final double total;

  const _HeaderCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = _formatKrw(total.toInt());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            '이번 달 구독료',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₩$formatted',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatKrw(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 등록된 구독이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '아래 버튼을 눌러 첫 구독을 추가해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isUsd = subscription.currency == 'USD';

    final currencySymbol = isUsd ? '\$' : '₩';
    final formattedAmount = isUsd
        ? subscription.amount.toStringAsFixed(2)
        : _formatKrw(subscription.amount.toInt());

    final krwConverted = isUsd ? (subscription.amount * 1450).toInt() : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '매월 ${subscription.billingDay}일 결제',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currencySymbol$formattedAmount',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                  if (krwConverted != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '≈ ₩${_formatKrw(krwConverted)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatKrw(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
