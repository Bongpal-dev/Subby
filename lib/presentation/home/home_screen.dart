import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/subby_app_bar.dart';
import 'package:subby/presentation/home/home_view_model.dart';
import 'package:subby/presentation/subscription/subscription_add_screen.dart';
import 'package:subby/presentation/subscription/subscription_edit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const SubbyAppBar(title: '', showBackButton: false),
      body: Column(
        children: [
          // 상단 헤더
          _HeaderCard(total: state.totalKrw),

          // 구독 목록
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.subscriptions.isEmpty
                    ? const _EmptyState()
                    : _SubscriptionList(
                        subscriptions: state.subscriptions,
                        onTap: (sub) => _navigateToEdit(context, ref, sub.id),
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
                  onPressed: () => _navigateToAdd(context, ref),
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
      ),
    );
  }

  void _navigateToAdd(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SubscriptionAddScreen(),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, WidgetRef ref, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubscriptionEditScreen(subscriptionId: id),
      ),
    );
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
            '\u20a9$formatted',
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
  final List<UserSubscription> subscriptions;
  final void Function(UserSubscription) onTap;

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
  final UserSubscription subscription;
  final VoidCallback onTap;

  const _SubscriptionTile({
    required this.subscription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUsd = subscription.currency == 'USD';

    final currencySymbol = isUsd ? '\$' : '\u20a9';
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
                      '\u2248 \u20a9${_formatKrw(krwConverted)}',
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
