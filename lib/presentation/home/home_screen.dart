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
        scrolledUnderElevation: 0,
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
                        onDelete: (sub) => _onDelete(context, ref, sub),
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

  void _onDelete(BuildContext context, WidgetRef ref, UserSubscription sub) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('구독 삭제'),
        content: Text('\'${sub.name}\'을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final vm = ref.read(homeViewModelProvider.notifier);
              await vm.deleteSubscription(sub.id);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
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
  final void Function(UserSubscription) onDelete;

  const _SubscriptionList({
    required this.subscriptions,
    required this.exchangeRate,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final sub = subscriptions[index];

        return _SubscriptionTile(
          key: ValueKey(sub.id),
          subscription: sub,
          exchangeRate: exchangeRate,
          onTap: () => onTap(sub),
          onDelete: () => onDelete(sub),
        );
      },
    );
  }
}

class _SubscriptionTile extends StatefulWidget {
  final UserSubscription subscription;
  final ExchangeRate? exchangeRate;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SubscriptionTile({
    super.key,
    required this.subscription,
    required this.exchangeRate,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<_SubscriptionTile> {
  double _dragExtent = 0;
  static const double _deleteThreshold = 80;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent = (_dragExtent - details.delta.dx).clamp(0.0, 120.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent >= _deleteThreshold) {
      widget.onDelete();
    }
    setState(() {
      _dragExtent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    final colorScheme = Theme.of(context).colorScheme;
    final isKrw = widget.subscription.currency == 'KRW';

    final currencySymbol = _getCurrencySymbol(widget.subscription.currency);
    final formattedAmount = isKrw
        ? CurrencyFormatter.formatKrw(widget.subscription.amount.toInt())
        : widget.subscription.amount.toStringAsFixed(2);

    final krwConverted = _getKrwConverted();

    // 스와이프 진행률 (0.0 ~ 1.0)
    final progress = (_dragExtent / _deleteThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Card(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 빨간 배경 (삭제 UI) - 스와이프 시에만 표시
            if (progress > 0)
              Positioned.fill(
                child: Container(
                  color: colorScheme.error,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '삭제하기',
                        style: AppTypography.headlineSmall.copyWith(
                          color: Colors.white.withValues(alpha: progress),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.delete,
                        color: Colors.white.withValues(alpha: progress),
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            // 카드 내용 (오른쪽에서 왼쪽으로 페이드)
            if (progress < 1.0)
              ShaderMask(
                shaderCallback: (bounds) {
                  // progress가 0이면 전체 불투명, 1이면 완전히 투명
                  final fadeEnd = 1.0 - progress;
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.white, Colors.transparent],
                    stops: [fadeEnd.clamp(0.0, 1.0), 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.subscription.name,
                                  style: AppTypography.titleLarge.copyWith(
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  '매월 ${widget.subscription.billingDay}일 결제',
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
                ),
              ),
          ],
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
    if (widget.subscription.currency == 'KRW') return null;

    if (widget.exchangeRate != null) {
      return widget.exchangeRate!
          .convert(widget.subscription.amount, widget.subscription.currency, 'KRW')
          .toInt();
    }

    // 환율 없으면 기본값 사용
    return (widget.subscription.amount * 1400).toInt();
  }
}
