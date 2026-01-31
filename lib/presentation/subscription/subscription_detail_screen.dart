import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/router/app_router.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/util/currency_formatter.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';

/// 구독 상세 조회 Provider (autoDispose로 화면 닫힐 때 캐시 해제)
final subscriptionDetailProvider = FutureProvider.autoDispose.family<UserSubscription?, String>((ref, id) async {
  final useCase = ref.watch(getSubscriptionByIdUseCaseProvider);
  return useCase(id);
});

class SubscriptionDetailScreen extends ConsumerWidget {
  final String subscriptionId;

  const SubscriptionDetailScreen({
    super.key,
    required this.subscriptionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final subscriptionAsync = ref.watch(subscriptionDetailProvider(subscriptionId));

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppAppBar(
        title: '구독 상세',
        showBackButton: true,
        actions: [
          AppBarIconButton(
            icon: AppIconType.trash,
            onPressed: () => subscriptionAsync.whenData(
              (sub) => sub != null ? _showDeleteDialog(context, ref, sub) : null,
            ),
            color: colors.iconPrimary,
          ),
        ],
      ),
      body: subscriptionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (subscription) {
          if (subscription == null) {
            return const Center(child: Text('구독을 찾을 수 없습니다'));
          }
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s6,
                    vertical: AppSpacing.s4,
                  ),
                  child: Column(
                    children: [
                      _HeaderSection(subscription: subscription),
                      const SizedBox(height: AppSpacing.s6),
                      _InfoSection(subscription: subscription),
                    ],
                  ),
                ),
              ),
              _BottomButton(
                onPressed: () => _navigateToEdit(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context, WidgetRef ref) async {
    final result = await context.push<bool>(
      AppRoutes.subscriptionEditPath(subscriptionId),
    );

    // 수정 완료 시 상세 데이터 refresh
    if (result == true) {
      ref.invalidate(subscriptionDetailProvider(subscriptionId));
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, UserSubscription subscription) {
    final colors = context.colors;

    showAppDialog(
      context: context,
      iconType: AppIconType.trash,
      iconColor: colors.statusError,
      title: '구독 삭제',
      description: '"${subscription.name}"를 정말 삭제할까요?',
      actions: [
        AppDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context),
        ),
        AppDialogAction(
          label: '삭제',
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context); // 다이얼로그 닫기
            final vm = ref.read(homeViewModelProvider.notifier);
            await vm.deleteSubscription(subscriptionId);
            if (context.mounted) {
              Navigator.pop(context); // 상세 화면 닫기
            }
          },
        ),
      ],
    );
  }
}

/// Figma: HeaderSection
class _HeaderSection extends StatelessWidget {
  final UserSubscription subscription;

  const _HeaderSection({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        // SubLogo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.buttonDisableBg,
            borderRadius: BorderRadius.circular(AppSpacing.s3),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/subby_place_holder.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              colors.buttonDisableText,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),

        // 서비스명
        Text(
          subscription.name,
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.s2),

        // 카테고리
        if (subscription.category != null)
          Text(
            subscription.category!,
            style: AppTypography.label.copyWith(color: colors.textSecondary),
          ),
        const SizedBox(height: AppSpacing.s2),

        // Divider
        const AppDivider(),
      ],
    );
  }
}

/// Figma: InfoSection
class _InfoSection extends StatelessWidget {
  final UserSubscription subscription;

  const _InfoSection({required this.subscription});

  @override
  Widget build(BuildContext context) {
    final formattedAmount = _formatAmount();
    final periodLabel = _getPeriodLabel();
    final nextBillingDate = _getNextBillingDate();

    return Column(
      children: [
        // 금액
        _InfoRow(
          label: '금액',
          value: '$formattedAmount / $periodLabel',
        ),
        const SizedBox(height: AppSpacing.s4),

        // 결제일
        _InfoRow(
          label: '결제일',
          value: '매월 ${subscription.billingDay}일',
        ),
        const SizedBox(height: AppSpacing.s4),

        // 다음 결제일
        _InfoRow(
          label: '다음 결제일',
          value: nextBillingDate,
        ),

        // 메모 (있을 때만)
        if (subscription.memo != null && subscription.memo!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s4),
          _InfoRow(
            label: '메모',
            value: subscription.memo!,
          ),
        ],
      ],
    );
  }

  String _formatAmount() {
    final symbol = _getCurrencySymbol();
    if (subscription.currency == 'KRW') {
      return '$symbol${CurrencyFormatter.formatKrw(subscription.amount.toInt())}';
    }
    return '$symbol${subscription.amount.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol() {
    switch (subscription.currency) {
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

  String _getPeriodLabel() {
    switch (subscription.period.toUpperCase()) {
      case 'YEARLY':
        return '매년';
      case 'WEEKLY':
        return '매주';
      default:
        return '매월';
    }
  }

  String _getNextBillingDate() {
    final now = DateTime.now();
    int year = now.year;
    int month = now.month;

    // 이번 달 결제일이 지났으면 다음 달
    if (now.day > subscription.billingDay) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    }

    // 월말 처리 (31일이 없는 달 등)
    final lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final billingDay = subscription.billingDay > lastDayOfMonth
        ? lastDayOfMonth
        : subscription.billingDay;

    return '$year.${month.toString().padLeft(2, '0')}.${billingDay.toString().padLeft(2, '0')}';
  }
}

/// Figma: InfoRow
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.label.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            value,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Figma: BottomButton
class _BottomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BottomButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppDivider(),
        Container(
          color: colors.bgPrimary,
          padding: EdgeInsets.only(
            left: AppSpacing.s4,
            right: AppSpacing.s4,
            top: AppSpacing.s4,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
          ),
          child: AppButton(
            label: '수정하기',
            onPressed: onPressed,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
