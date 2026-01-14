import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/util/currency_formatter.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/exchange_rate.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/app_drawer.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';
import 'package:subby/presentation/subscription/subscription_add_screen.dart';
import 'package:subby/presentation/subscription/subscription_edit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final exchangeRate = ref.watch(exchangeRateProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.currentGroupName),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _onInvite(
              context,
              state.currentGroupName,
              state.selectedGroupCode,
            ),
            child: const Text('초대하기'),
          ),
        ],
      ),
      drawer: const AppDrawer(),
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
                        exchangeRate: exchangeRate,
                        onTap: (sub) => _navigateToEdit(context, ref, sub.id),
                      ),
          ),

          // 하단 추가 버튼
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _navigateToAdd(context, ref),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '+ 구독 추가하기',
                    style: AppTypography.titleLarge,
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

  void _onInvite(BuildContext context, String groupName, String? groupCode) {
    if (groupCode == null) return;

    showInviteDialog(
      context: context,
      groupCode: groupCode,
      groupName: groupName,
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final double total;

  const _HeaderCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = CurrencyFormatter.formatKrw(total.toInt());

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.lg),
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '이번 달 구독료',
            style: AppTypography.titleLarge.copyWith(color: Colors.white),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '\u20a9$formatted',
            style: AppTypography.displayLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: colors.primary.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            '아직 등록된 구독이 없습니다',
            style: AppTypography.titleLarge.copyWith(color: colors.textPrimary),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '아래 버튼을 눌러 첫 구독을 추가해보세요!',
            style: AppTypography.bodySmall.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  final List<UserSubscription> subscriptions;
  final ExchangeRate? exchangeRate;
  final void Function(UserSubscription) onTap;

  const _SubscriptionList({
    required this.subscriptions,
    required this.exchangeRate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final sub = subscriptions[index];

        return _SubscriptionTile(
          subscription: sub,
          exchangeRate: exchangeRate,
          onTap: () => onTap(sub),
        );
      },
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  final UserSubscription subscription;
  final ExchangeRate? exchangeRate;
  final VoidCallback onTap;

  const _SubscriptionTile({
    required this.subscription,
    required this.exchangeRate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    final isKrw = subscription.currency == 'KRW';

    final currencySymbol = _getCurrencySymbol(subscription.currency);
    final formattedAmount = isKrw
        ? CurrencyFormatter.formatKrw(subscription.amount.toInt())
        : subscription.amount.toStringAsFixed(2);

    final krwConverted = _getKrwConverted();

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: AppTypography.titleLarge.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '매월 ${subscription.billingDay}일 결제',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textTertiary,
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
                    style: AppTypography.titleLarge.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  if (krwConverted != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '\u2248 \u20a9${CurrencyFormatter.formatKrw(krwConverted)}',
                      style: AppTypography.captionLarge.copyWith(
                        color: colors.textTertiary,
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

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'JPY':
        return '¥';
      default:
        return '₩';
    }
  }

  int? _getKrwConverted() {
    if (subscription.currency == 'KRW') return null;

    if (exchangeRate != null) {
      return exchangeRate!
          .convert(subscription.amount, subscription.currency, 'KRW')
          .toInt();
    }

    // 환율 없으면 기본값 사용
    return (subscription.amount * 1400).toInt();
  }
}
