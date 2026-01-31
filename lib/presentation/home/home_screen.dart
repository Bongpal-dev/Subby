import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:subby/core/router/app_router.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/app_drawer.dart';
import 'package:subby/presentation/common/group_actions.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final colors = context.colors;
    final hasGroup = state.groups.isNotEmpty;

    return Scaffold(
      // Figma: AppBar with bgAccent background
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: hasGroup ? colors.bgAccent : null,
        foregroundColor: hasGroup ? colors.textOnAccent : null,
        toolbarHeight: 56,
        title: hasGroup
            ? Text(
                state.currentGroupName,
                style: AppTypography.title.copyWith(color: colors.textOnAccent),
              )
            : null,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: hasGroup ? colors.iconOnAccent : colors.iconPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (hasGroup)
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ic_share.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  colors.iconOnAccent,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => _onInvite(
                context,
                state.currentGroupName,
                state.selectedGroupCode,
              ),
            ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: hasGroup
          ? SubbyFab(
              onPressed: () => _navigateToAdd(context, ref),
            )
          : null,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.groups.isEmpty
              ? const _NoGroupState()
              : _HomeContent(
                  state: state,
                  onCategorySelected: (category) {
                    ref.read(homeViewModelProvider.notifier).selectCategory(category);
                  },
                  onTap: (sub) => _navigateToDetail(context, sub.id),
                  onDelete: (sub) => _onDelete(context, ref, sub),
                ),
    );
  }

  void _navigateToAdd(BuildContext context, WidgetRef ref) {
    context.push(AppRoutes.subscriptionAdd);
  }

  void _navigateToDetail(BuildContext context, String subscriptionId) {
    context.push(AppRoutes.subscriptionDetailPath(subscriptionId));
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
    final colors = context.colors;

    showSubbyDialog(
      context: context,
      iconType: AppIconType.trash,
      iconColor: colors.statusError,
      title: '구독 삭제',
      description: '"${sub.name}"를 정말 삭제할까요?',
      actions: [
        SubbyDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context),
        ),
        SubbyDialogAction(
          label: '삭제',
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context);
            final vm = ref.read(homeViewModelProvider.notifier);
            await vm.deleteSubscription(sub.id);
          },
        ),
      ],
    );
  }
}

/// Figma HomeContent - 스크롤 가능한 메인 콘텐츠
class _HomeContent extends StatelessWidget {
  final HomeState state;
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<UserSubscription> onTap;
  final ValueChanged<UserSubscription> onDelete;

  const _HomeContent({
    required this.state,
    required this.onCategorySelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Figma: padding-bottom 80px for FAB space
      padding: const EdgeInsets.only(
        top: AppSpacing.s4,
        bottom: 80,
      ),
      child: Column(
        children: [
          // SummarySection
          _HeaderCard(formattedTotal: state.formattedTotal),

          // FilterSection (구독이 있을 때만)
          if (state.subscriptions.isNotEmpty && state.categories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            _FilterSection(
              categories: state.categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: onCategorySelected,
            ),
          ],

          // SubscriptionSection
          const SizedBox(height: AppSpacing.s4),
          if (state.subscriptions.isEmpty)
            const _EmptyState()
          else
            _SubscriptionSection(
              subscriptions: state.subscriptions,
              uiModels: state.subscriptionUiModels,
              onTap: onTap,
              onDelete: onDelete,
            ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String formattedTotal;

  const _HeaderCard({required this.formattedTotal});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Container(
        width: double.infinity,
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
              formattedTotal,
              style: AppTypography.display.copyWith(color: colors.textOnAccent),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma: FilterSection - 가로 스크롤 칩
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
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        itemCount: categories.length + 1, // +1 for "전체"
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SubbyChip(
              label: '전체',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            );
          }
          final category = categories[index - 1];
          return SubbyChip(
            label: category,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

/// Figma: SubscriptionSection - 카드 간격 12px
class _SubscriptionSection extends StatelessWidget {
  final List<UserSubscription> subscriptions;
  final List<SubscriptionUiModel> uiModels;
  final ValueChanged<UserSubscription> onTap;
  final ValueChanged<UserSubscription> onDelete;

  const _SubscriptionSection({
    required this.subscriptions,
    required this.uiModels,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        children: [
          for (int i = 0; i < uiModels.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s3),
            _SubscriptionTile(
              subscription: subscriptions[i],
              uiModel: uiModels[i],
              onTap: () => onTap(subscriptions[i]),
              onDelete: () => onDelete(subscriptions[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 아이콘
          SvgPicture.asset(
            'assets/icons/ic_dot_mark.svg',
            width: 56,
            height: 56,
            colorFilter: ColorFilter.mode(
              colors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: AppSpacing.s6),

          // 텍스트 그룹
          Text(
            '아직 추가된 서비스가 없어요',
            style: AppTypography.title.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            '아래 버튼을 눌러 구독중인 서비스를 추가해보세요',
            style: AppTypography.body.copyWith(color: colors.textTertiary),
            textAlign: TextAlign.center,
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
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // 아이콘
          SvgPicture.asset(
            'assets/icons/ic_xmark.svg',
            width: 56,
            height: 56,
            colorFilter: ColorFilter.mode(
              colors.textSecondary,
              BlendMode.srcIn,
            ),
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
          SubbyButton(
            label: '+ 새 그룹 만들기',
            onPressed: () => showCreateGroupFlow(context, ref),
            type: SubbyButtonType.primary,
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.s3),

          // 초대 코드로 참여 버튼
          SubbyButton(
            label: '초대 코드로 참여',
            onPressed: () => showJoinGroupFlow(context, ref),
            type: SubbyButtonType.outline,
            isExpanded: true,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

/// Figma: SubscriptionCard with swipe-to-delete
class _SubscriptionTile extends StatefulWidget {
  final UserSubscription subscription;
  final SubscriptionUiModel uiModel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SubscriptionTile({
    super.key,
    required this.subscription,
    required this.uiModel,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SubscriptionTile> createState() => _SubscriptionTileState();
}

class _SubscriptionTileState extends State<_SubscriptionTile> {
  double _dragOffset = 0;
  bool _hasTriggered = false;

  void _handleDragUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      // 왼쪽으로만 스와이프 가능 (음수 방향)
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-double.infinity, 0.0);
    });

    if (!_hasTriggered && _dragOffset.abs() > screenWidth * 0.42) {
      _hasTriggered = true;
      HapticFeedback.mediumImpact();

      // 다이얼로그 띄우고 카드 원위치
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _dragOffset = 0;
        });
        widget.onDelete();
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_hasTriggered) {
      _hasTriggered = false;
      return;
    }
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final uiModel = widget.uiModel;

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 뒤쪽 삭제 UI (카드가 스와이프되면 보임)
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(right: AppSpacing.s4),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '삭제하기',
                    style: AppTypography.bodyLargeSemi.copyWith(
                      color: colors.statusError,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  SvgPicture.asset(
                    'assets/icons/ic_trash.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      colors.statusError,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 카드 (스와이프 시 왼쪽으로 이동)
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: Container(
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.s4),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.s4),
                  onTap: _dragOffset == 0 ? widget.onTap : null,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    child: Row(
                      children: [
                        // 로고 placeholder (SubLogo)
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
                              uiModel.formattedAmount,
                              style: AppTypography.bodyLargeSemi.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            if (uiModel.convertedAmount != null) ...[
                              const SizedBox(height: AppSpacing.s1),
                              Text(
                                uiModel.convertedAmount!,
                                style: AppTypography.caption.copyWith(
                                  color: colors.textTertiary,
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.s1),
                            Text(
                              uiModel.periodLabel,
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
    );
  }

}
