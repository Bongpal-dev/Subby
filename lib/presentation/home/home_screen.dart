import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/util/currency_formatter.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/exchange_rate.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/app_drawer.dart';
import 'package:subby/presentation/common/group_actions.dart';
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
    final hasGroup = state.groups.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: hasGroup ? Text(state.currentGroupName) : null,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (hasGroup)
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
      floatingActionButton: hasGroup
          ? AppFab(
              onPressed: () => _navigateToAdd(context, ref),
            )
          : null,
      body: Column(
        children: [
          // 상단 헤더 (그룹이 있을 때만)
          if (hasGroup) _HeaderCard(total: state.totalKrw),

          // 카테고리 필터 (그룹이 있고, 구독이 있을 때만)
          if (hasGroup && state.subscriptions.isNotEmpty && state.categories.isNotEmpty)
            _FilterSection(
              categories: state.categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: (category) {
                ref.read(homeViewModelProvider.notifier).selectCategory(category);
              },
            ),

          // 구독 목록
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.groups.isEmpty
                    ? const _NoGroupState()
                    : state.subscriptions.isEmpty
                        ? const _EmptyState()
                        : _SubscriptionList(
                            subscriptions: state.filteredSubscriptions,
                            exchangeRate: exchangeRate,
                            onTap: (sub) => _navigateToEdit(context, ref, sub.id),
                            onDelete: (sub) => _onDelete(context, ref, sub),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final formatted = CurrencyFormatter.formatKrw(total.toInt());

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s6,
        horizontal: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: colors.bgAccent,
        borderRadius: BorderRadius.circular(AppSpacing.s4),
      ),
      child: Column(
        children: [
          Text(
            '이번 달 예상 구독료',
            style: AppTypography.body.copyWith(color: colors.textOnAccent),
          ),
          Text(
            '\u20a9$formatted',
            style: AppTypography.display.copyWith(color: colors.textOnAccent),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const _FilterSection({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: AppSpacing.s4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        itemCount: categories.length + 1, // +1 for "전체"
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (context, index) {
          if (index == 0) {
            // "전체" 칩
            return AppChip(
              label: '전체',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            );
          }
          final category = categories[index - 1];
          return AppChip(
            label: category,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: colors.bgAccent.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            '아직 등록된 구독이 없습니다',
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            '아래 버튼을 눌러 첫 구독을 추가해보세요!',
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _NoGroupState extends ConsumerWidget {
  const _NoGroupState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // 아이콘
          Icon(
            Icons.cancel_outlined,
            size: 24,
            color: colors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.s6),

          // 메인 텍스트
          Text(
            '참여중인 그룹이 없어요',
            style: AppTypography.title.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            '새 그룹을 만들거나 초대 코드로 참여하세요',
            style: AppTypography.body.copyWith(
              color: colors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.s6),

          // 새 그룹 만들기 버튼
          AppButton(
            label: '+ 새 그룹 만들기',
            onPressed: () => showCreateGroupFlow(context, ref),
            type: AppButtonType.primary,
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.s3),

          // 초대 코드로 참여 버튼
          AppButton(
            label: '초대 코드로 참여',
            onPressed: () => showJoinGroupFlow(context, ref),
            type: AppButtonType.outline,
            isExpanded: true,
          ),

          const Spacer(flex: 1),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
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
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.s3),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.s4),
        ),
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
                        style: AppTypography.title.copyWith(
                          color: Colors.white.withValues(alpha: progress),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
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
            // Stack 크기 유지를 위해 항상 렌더링 (Opacity로 숨김)
            Opacity(
              opacity: progress < 1.0 ? 1.0 : 0.0,
              child: ShaderMask(
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
                  color: colors.bgSecondary,
                  child: InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s4),
                      child: Row(
                        children: [
                          // 로고 placeholder
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors.buttonDisableBg,
                              borderRadius: BorderRadius.circular(AppSpacing.s3),
                            ),
                            child: Icon(
                              Icons.subscriptions_outlined,
                              color: colors.buttonDisableText,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 서비스 정보
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.subscription.name,
                                  style: AppTypography.bodySemi.copyWith(
                                    color: colors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.s1),
                                Text(
                                  '매월 ${widget.subscription.billingDay}일 결제',
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 금액 정보
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$currencySymbol$formattedAmount',
                                style: AppTypography.bodyLargeSemi.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                              if (krwConverted != null) ...[
                                const SizedBox(height: AppSpacing.s1),
                                Text(
                                  '\u2248\u20a9${CurrencyFormatter.formatKrw(krwConverted)}',
                                  style: AppTypography.caption.copyWith(
                                    color: colors.textTertiary,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.s1),
                              Text(
                                _getPeriodLabel(widget.subscription.period),
                                style: AppTypography.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  String _getPeriodLabel(String period) {
    switch (period) {
      case 'monthly':
        return '월간 결제';
      case 'yearly':
        return '연간 결제';
      case 'weekly':
        return '주간 결제';
      default:
        return '월간 결제';
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
