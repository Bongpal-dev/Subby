import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_app_bar.dart';
import 'package:subby/presentation/common/widgets/subby_button.dart';
import 'package:subby/presentation/common/widgets/subby_chip.dart';
import 'package:subby/presentation/common/widgets/subby_fab.dart';
import 'package:subby/presentation/common/widgets/subby_tooltip.dart';

/// 온보딩 코치마크 전용 화면
/// 더미 HomeScreen UI를 보여주고 코치마크 툴팁을 순차적으로 표시
class OnboardingCoachMarkScreen extends ConsumerStatefulWidget {
  const OnboardingCoachMarkScreen({super.key});

  @override
  ConsumerState<OnboardingCoachMarkScreen> createState() =>
      _OnboardingCoachMarkScreenState();
}

class _OnboardingCoachMarkScreenState
    extends ConsumerState<OnboardingCoachMarkScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeCoachMark() async {
    // 코치마크 완료 처리 → 홈 화면으로 이동 후 다이얼로그 표시
    await ref.read(coachMarkCompletedProvider.notifier).completeCoachMark();
  }

  @override
  Widget build(BuildContext context) {
    final coachMarkCompleted = ref.watch(coachMarkCompletedProvider);

    // 코치마크 완료되면 빈 화면 (AppInitializationWrapper가 HomeScreen으로 전환)
    if (coachMarkCompleted) {
      return const SizedBox.shrink();
    }

    // 라이트 모드 강제 적용
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: [
              _FabCoachMarkPage(onTap: _goToNextPage),
              _SummaryCardCoachMarkPage(onTap: _goToNextPage),
              _DrawerCoachMarkPage(onTap: _goToNextPage),
              _WelcomeCompletePage(onStart: _completeCoachMark),
            ],
          ),
          // 페이지 인디케이터
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 32,
            child: _PageIndicator(
              currentPage: _currentPage,
              pageCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}

/// 페이지 인디케이터
class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _PageIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
          decoration: BoxDecoration(
            color: isActive ? colors.iconAccent : colors.iconSecondary,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// 더미 홈 화면 Scaffold (공통)
class _DummyHomeScaffold extends StatelessWidget {
  const _DummyHomeScaffold();

  @override
  Widget build(BuildContext context) {
    // 라이트 모드 색상 사용
    final colors = AppColors.light;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: SubbyAppBar(
        title: '그룹 이름',
        useAccentBackground: true,
        leading: SubbyAppBarIconButton(
          icon: AppIconType.menu,
          color: colors.iconOnAccent,
          onPressed: () {},
        ),
        actions: [
          SubbyAppBarIconButton(
            icon: AppIconType.share,
            color: colors.iconOnAccent,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: AppSpacing.s4,
          bottom: 80,
        ),
        child: const Column(
          children: [
            _DummySummaryCard(),
            SizedBox(height: AppSpacing.s4),
            _DummyFilterSection(),
            SizedBox(height: AppSpacing.s4),
            _DummySubscriptionSection(),
          ],
        ),
      ),
      floatingActionButton: SubbyFab(onPressed: () {}),
    );
  }
}

/// Step 1: FAB 코치마크 페이지
class _FabCoachMarkPage extends StatelessWidget {
  final VoidCallback onTap;

  const _FabCoachMarkPage({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    // FAB 위치 계산 (Scaffold FAB 기본 위치 기준)
    const fabSize = 56.0;
    const fabMargin = 16.0;

    return Stack(
      children: [
        // 더미 홈 화면
        const _DummyHomeScaffold(),

        // 오버레이
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Stack(
              children: [
                // 연두색 하이라이트 테두리 (FAB 주변) - 배경색으로 dim 제거
                Positioned(
                  right: fabMargin - 8,
                  bottom: fabMargin + bottomPadding - 8,
                  child: Container(
                    width: fabSize + 16,
                    height: fabSize + 16,
                    decoration: BoxDecoration(
                      color: colors.bgPrimary,
                      border: Border.all(
                        color: colors.bgAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // FAB 다시 그리기
                Positioned(
                  right: fabMargin,
                  bottom: fabMargin + bottomPadding,
                  child: SubbyFab(onPressed: () {}),
                ),
                // 툴팁 (FAB 왼쪽 위)
                Positioned(
                  left: 16,
                  bottom: fabMargin + bottomPadding + fabSize + 32,
                  child: const SubbyTooltip(
                    title: '구독 추가하기',
                    description: '+버튼을 눌러 구독중인 서비스를 추가하세요',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 2: Summary Card 코치마크 페이지
class _SummaryCardCoachMarkPage extends StatelessWidget {
  final VoidCallback onTap;

  const _SummaryCardCoachMarkPage({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;
    const appBarHeight = 56.0;

    // Summary Card 위치 (앱바 아래, padding 16)
    final cardTop = statusBarHeight + appBarHeight + AppSpacing.s4;
    const cardHorizontalPadding = AppSpacing.s4;
    // Summary Card 높이 (padding 24*2 + body text + display text + 여백)
    const cardHeight = 116.0;

    return Stack(
      children: [
        // 더미 홈 화면
        const _DummyHomeScaffold(),

        // 오버레이
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: Stack(
              children: [
                // 연두색 하이라이트 테두리 (Summary Card 주변) - 배경색으로 dim 제거
                Positioned(
                  left: cardHorizontalPadding - 8,
                  top: cardTop - 8,
                  right: cardHorizontalPadding - 8,
                  child: Container(
                    height: cardHeight + 16,
                    decoration: BoxDecoration(
                      color: colors.bgPrimary,
                      border: Border.all(
                        color: colors.bgAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                // Summary Card 다시 그리기
                Positioned(
                  left: cardHorizontalPadding,
                  top: cardTop,
                  right: cardHorizontalPadding,
                  child: Container(
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
                          style: AppTypography.body.copyWith(
                            color: colors.textOnAccent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          '₩199,200',
                          style: AppTypography.display.copyWith(
                            color: colors.textOnAccent,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 툴팁 (카드 아래)
                Positioned(
                  left: 16,
                  top: cardTop + cardHeight + 16,
                  child: const SubbyTooltip(
                    title: '예상 구독료 확인하기',
                    description: '이번 달 총 예상 구독료를 확인하세요',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Step 3: 드로어 코치마크 페이지
class _DrawerCoachMarkPage extends StatelessWidget {
  final VoidCallback onTap;

  const _DrawerCoachMarkPage({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;
    final mediaQuery = MediaQuery.of(context);
    final statusBarHeight = mediaQuery.padding.top;

    // 그룹 아이템 위치 계산
    const drawerWidth = 300.0;
    const profileSectionHeight = 24.0; // 닉네임 높이
    const dividerHeight = 1.0;
    const groupItemHeight = 56.0;
    final groupItemTop = statusBarHeight + AppSpacing.s6 + profileSectionHeight + AppSpacing.s4 + dividerHeight + AppSpacing.s4;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // 홈 화면 배경
          const _DummyHomeScaffold(),

          // 전체 dim 오버레이
          Container(
            color: Colors.black.withOpacity(0.7),
          ),

          // 드로어
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: drawerWidth,
              child: Stack(
                children: [
                  // 드로어 흰색 배경
                  Container(
                    color: colors.bgSecondary,
                    padding: EdgeInsets.only(
                      left: AppSpacing.s4,
                      right: AppSpacing.s4,
                      top: statusBarHeight + AppSpacing.s6,
                      bottom: AppSpacing.s6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 프로필 섹션
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '졸린 빨간색 판다',
                                style: AppTypography.bodyLargeSemi.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/ic_edit.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                colors.iconPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Divider(color: colors.borderSecondary, height: 1),
                        const SizedBox(height: AppSpacing.s4),

                        // 그룹 목록
                        Expanded(
                          child: Column(
                            children: [
                              _DummyGroupItem(
                                name: '그룹이름',
                                memberCount: '2명 참여중',
                                isSelected: false,
                              ),
                              const SizedBox(height: AppSpacing.s2),
                              _DummyGroupItem(
                                name: '그룹이름',
                                memberCount: '나만 사용중',
                                isSelected: true,
                              ),
                              const SizedBox(height: AppSpacing.s2),
                              _DummyGroupItem(
                                name: '그룹이름',
                                memberCount: '2명 참여중',
                                isSelected: false,
                              ),
                              const SizedBox(height: AppSpacing.s2),
                              _DummyGroupItem(
                                name: '그룹이름',
                                memberCount: '2명 참여중',
                                isSelected: false,
                              ),
                            ],
                          ),
                        ),

                        // 하단 메뉴
                        Divider(color: colors.borderSecondary, height: 1),
                        const SizedBox(height: AppSpacing.s2),
                        _DummyMenuItem(
                          icon: 'assets/icons/ic_plus.svg',
                          label: '새 그룹 만들기',
                        ),
                        _DummyMenuItem(
                          icon: 'assets/icons/ic_mail.svg',
                          label: '그룹 참여하기',
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        Divider(color: colors.borderSecondary, height: 1),
                        const SizedBox(height: AppSpacing.s2),
                        _DummyMenuItem(
                          icon: 'assets/icons/ic_logout.svg',
                          label: '로그아웃',
                        ),
                        _DummyMenuItem(
                          icon: 'assets/icons/ic_setting.svg',
                          label: '설정',
                        ),
                      ],
                    ),
                  ),

                  // 드로어 위에 dim 오버레이
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),

                  // 하이라이트 영역 (dim 제거 + 테두리)
                  Positioned(
                    left: AppSpacing.s4 - 8,
                    top: groupItemTop - 8,
                    right: AppSpacing.s4 - 8,
                    child: Container(
                      height: groupItemHeight + 16,
                      decoration: BoxDecoration(
                        color: colors.bgSecondary, // 흰색 배경으로 dim 제거
                        border: Border.all(
                          color: colors.bgAccent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  // 그룹 아이템 다시 그리기 (하이라이트 위에)
                  Positioned(
                    left: AppSpacing.s4,
                    top: groupItemTop,
                    right: AppSpacing.s4,
                    child: _DummyGroupItem(
                      name: '그룹이름',
                      memberCount: '2명 참여중',
                      isSelected: false,
                    ),
                  ),
                ],
              ),
            ),

          // 툴팁 (하이라이트 아래)
          Positioned(
            left: 16,
            top: groupItemTop + groupItemHeight + 24,
            child: const SubbyTooltip(
              title: '그룹으로 함께 관리',
              description: '그룹을 만들고 가족·친구와 공유하세요',
            ),
          ),
        ],
      ),
    );
  }
}

/// 더미 그룹 아이템
class _DummyGroupItem extends StatelessWidget {
  final String name;
  final String memberCount;
  final bool isSelected;

  const _DummyGroupItem({
    required this.name,
    required this.memberCount,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
      decoration: BoxDecoration(
        color: isSelected ? colors.bgTertiary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.s2),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_group.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colors.iconPrimary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    color: colors.textPrimary,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  memberCount,
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            SvgPicture.asset(
              'assets/icons/ic_check.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                colors.iconPrimary,
                BlendMode.srcIn,
              ),
            ),
          const SizedBox(width: AppSpacing.s2),
          SvgPicture.asset(
            'assets/icons/ic_more.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colors.iconSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

/// 더미 메뉴 아이템
class _DummyMenuItem extends StatelessWidget {
  final String icon;
  final String label;

  const _DummyMenuItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.s3),
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colors.iconSecondary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Text(
            label,
            style: AppTypography.body.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 더미 Summary Card
class _DummySummaryCard extends StatelessWidget {
  const _DummySummaryCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;

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
              '₩199,200',
              style: AppTypography.display.copyWith(color: colors.textOnAccent),
            ),
          ],
        ),
      ),
    );
  }
}

/// 더미 Filter Section
class _DummyFilterSection extends StatelessWidget {
  const _DummyFilterSection();

  @override
  Widget build(BuildContext context) {
    final categories = ['전체', '영상', '음악', 'AI', '생산성', '이미지'];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (context, index) {
          return SubbyChip(
            label: categories[index],
            isSelected: index == 0,
            onTap: () {},
          );
        },
      ),
    );
  }
}

/// 더미 Subscription Section
class _DummySubscriptionSection extends StatelessWidget {
  const _DummySubscriptionSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        children: [
          _DummySubscriptionCard(name: 'Claude', amount: '\$20.00'),
          SizedBox(height: AppSpacing.s3),
          _DummySubscriptionCard(name: 'Youtube', amount: '₩14,900'),
        ],
      ),
    );
  }
}

/// 더미 Subscription Card
class _DummySubscriptionCard extends StatelessWidget {
  final String name;
  final String amount;

  const _DummySubscriptionCard({
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.light;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.s4),
      ),
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
          const SizedBox(width: AppSpacing.s3),
          // 서비스 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.bodySemi.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  '매월 15일 결제',
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
                amount,
                style: AppTypography.bodyLargeSemi.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                '월간 결제',
                style: AppTypography.caption.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Step 4: 시작할 준비 완료 페이지
class _WelcomeCompletePage extends StatelessWidget {
  final VoidCallback onStart;

  const _WelcomeCompletePage({required this.onStart});

  @override
  Widget build(BuildContext context) {
    // 라이트 모드 색상 사용
    final colors = AppColors.light;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s6,
                      vertical: AppSpacing.s4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subby 로고 (64x64)
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colors.bgAccent,
                            borderRadius: BorderRadius.circular(AppSpacing.s4),
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/subby_place_holder.svg',
                            colorFilter: ColorFilter.mode(
                              colors.textOnAccent,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        // 타이틀
                        Text(
                          '시작할 준비 완료!',
                          style: AppTypography.title.copyWith(
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        // 설명
                        Text(
                          '이제 구독을 등록하고 한눈에 관리해보세요',
                          style: AppTypography.body.copyWith(
                            color: colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        // 시작하기 버튼 (중앙 콘텐츠와 함께)
                        SizedBox(
                          width: double.infinity,
                          child: SubbyButton(
                            label: '시작하기',
                            type: SubbyButtonType.primary,
                            isExpanded: true,
                            onPressed: onStart,
                          ),
                        ),
                        // 인디케이터 공간 확보
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
