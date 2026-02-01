import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/core/utils/nickname_generator.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/widgets/subby_app_bar.dart';
import 'package:subby/presentation/common/widgets/subby_chip.dart';
import 'package:subby/presentation/common/widgets/subby_dialog.dart';
import 'package:subby/presentation/common/widgets/subby_fab.dart';
import 'package:subby/presentation/common/widgets/subby_text_input_dialog.dart';
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
  final GlobalKey _fabKey = GlobalKey();
  final GlobalKey _summaryCardKey = GlobalKey();
  final GlobalKey _drawerKey = GlobalKey();

  int _currentStep = 0; // 0: 구독추가, 1: 예상구독료, 2: 그룹관리, 3: 완료

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNextCoachMark();
    });
  }

  void _showNextCoachMark() {
    setState(() {
      _currentStep++;
    });

    if (_currentStep > 3) {
      _completeCoachMark();
    }
  }

  Future<void> _completeCoachMark() async {
    // 닉네임 설정 다이얼로그
    final nicknameSet = ref.read(nicknameSetProvider);
    if (!nicknameSet && mounted) {
      await _showNicknameDialog();
    }

    // 클라우드 연동 다이얼로그 (신규 사용자만)
    final cloudSyncPrompted = ref.read(cloudSyncPromptedProvider);
    if (!cloudSyncPrompted && mounted) {
      await _showCloudSyncDialog();
    }

    // 코치마크 완료 처리
    await ref.read(coachMarkCompletedProvider.notifier).completeCoachMark();
  }

  /// 닉네임 설정 다이얼로그
  Future<void> _showNicknameDialog() async {
    if (!mounted) return;

    final colors = context.colors;

    final nickname = await showSubbyTextInputDialog(
      context: context,
      title: '닉네임 설정',
      description: '다른 사람에게 보일 이름을\n입력해 주세요',
      hint: '닉네임을 입력하세요',
      initialValue: NicknameGenerator.generate(),
      cancelLabel: '취소',
      confirmLabel: '변경하기',
      barrierDismissible: false,
      suffixIcon: SvgPicture.asset(
        'assets/icons/ic_refresh_small.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          colors.iconSecondary,
          BlendMode.srcIn,
        ),
      ),
      onGenerateValue: NicknameGenerator.generate,
    );

    if (nickname != null && nickname.isNotEmpty) {
      // TODO: 닉네임 저장 (NicknameRepository 사용)
    }
    // 취소해도 완료 처리 (다시 묻지 않음)
    await ref.read(nicknameSetProvider.notifier).completeNicknameSet();
  }

  /// 클라우드 연동 다이얼로그
  Future<void> _showCloudSyncDialog() async {
    if (!mounted) return;

    final colors = context.colors;

    await showSubbyDialog(
      context: context,
      iconType: AppIconType.download,
      iconColor: colors.statusInfo,
      title: '클라우드에 연동할까요?',
      description: '로그인하면 데이터가 안전하게 저장되고,\n다른 기기에서도 사용할 수 있어요',
      barrierDismissible: false,
      actions: [
        SubbyDialogAction(
          label: '나중에',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SubbyDialogAction(
          label: '로그인',
          isPrimary: true,
          onPressed: () async {
            Navigator.pop(context);
            await _handleGoogleLogin();
          },
        ),
      ],
    );

    // 클라우드 연동 제안 완료 저장
    await ref.read(cloudSyncPromptedProvider.notifier).completeCloudSyncPrompt();
  }

  /// Google 로그인 처리
  Future<void> _handleGoogleLogin() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithGoogle();

    if (result is GoogleSignInSuccess) {
      // 로그인 성공 - 기존 데이터 마이그레이션 필요할 수 있음
    }
    // 취소하거나 실패해도 다시 묻지 않음 (cloudSyncPrompted = true)
  }


  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final coachMarkCompleted = ref.watch(coachMarkCompletedProvider);

    // 코치마크 완료되면 빈 화면 (AppInitializationWrapper가 HomeScreen으로 전환)
    if (coachMarkCompleted) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: SubbyAppBar(
        title: '그룹 이름',
        useAccentBackground: true,
        leading: Builder(
          key: _drawerKey,
          builder: (ctx) => SubbyAppBarIconButton(
            icon: AppIconType.menu,
            color: colors.iconOnAccent,
            onPressed: () {},
          ),
        ),
        actions: [
          SubbyAppBarIconButton(
            icon: AppIconType.share,
            color: colors.iconOnAccent,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: SubbyFab(
        key: _fabKey,
        onPressed: () {},
      ),
      body: Stack(
        children: [
          // 더미 HomeScreen 콘텐츠
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: AppSpacing.s4,
              bottom: 80,
            ),
            child: Column(
              children: [
                // Summary Card
                _DummySummaryCard(key: _summaryCardKey),
                const SizedBox(height: AppSpacing.s4),
                // Filter Chips
                const _DummyFilterSection(),
                const SizedBox(height: AppSpacing.s4),
                // Subscription Cards
                const _DummySubscriptionSection(),
              ],
            ),
          ),

          // 코치마크 오버레이
          if (_currentStep >= 1 && _currentStep <= 3)
            _CoachMarkOverlay(
              step: _currentStep,
              fabKey: _fabKey,
              summaryCardKey: _summaryCardKey,
              drawerKey: _drawerKey,
              onTap: _showNextCoachMark,
            ),
        ],
      ),
    );
  }
}

/// 코치마크 오버레이
class _CoachMarkOverlay extends StatelessWidget {
  final int step;
  final GlobalKey fabKey;
  final GlobalKey summaryCardKey;
  final GlobalKey drawerKey;
  final VoidCallback onTap;

  const _CoachMarkOverlay({
    required this.step,
    required this.fabKey,
    required this.summaryCardKey,
    required this.drawerKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    String title;
    String description;
    GlobalKey targetKey;
    TooltipPosition position;

    switch (step) {
      case 1: // 구독 추가
        title = '구독 추가하기';
        description = '+버튼을 눌러 구독중인 서비스를 추가하세요';
        targetKey = fabKey;
        position = TooltipPosition.top;
      case 2: // 예상 구독료
        title = '예상 구독료 확인하기';
        description = '이번 달 총 예상 구독료를 확인하세요';
        targetKey = summaryCardKey;
        position = TooltipPosition.bottom;
      case 3: // 그룹 관리
        title = '그룹으로 함께 관리';
        description = '그룹을 만들고 가족·친구와 공유하세요';
        targetKey = drawerKey;
        position = TooltipPosition.bottom;
      default:
        return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Stack(
          children: [
            // 하이라이트 영역 + 툴팁
            _HighlightWithTooltip(
              targetKey: targetKey,
              title: title,
              description: description,
              position: position,
              highlightColor: colors.bgPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

/// 하이라이트 영역과 툴팁
class _HighlightWithTooltip extends StatelessWidget {
  final GlobalKey targetKey;
  final String title;
  final String description;
  final TooltipPosition position;
  final Color highlightColor;

  const _HighlightWithTooltip({
    required this.targetKey,
    required this.title,
    required this.description,
    required this.position,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();

    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    // 툴팁 위치 계산
    const tooltipWidth = 280.0;
    double tooltipLeft;
    double tooltipTop;

    switch (position) {
      case TooltipPosition.top:
        tooltipLeft = (targetPosition.dx + targetSize.width / 2 - tooltipWidth / 2)
            .clamp(16.0, screenWidth - tooltipWidth - 16);
        tooltipTop = targetPosition.dy - 100;
      case TooltipPosition.bottom:
        tooltipLeft = (targetPosition.dx + targetSize.width / 2 - tooltipWidth / 2)
            .clamp(16.0, screenWidth - tooltipWidth - 16);
        tooltipTop = targetPosition.dy + targetSize.height + 16;
      case TooltipPosition.left:
        tooltipLeft = targetPosition.dx - tooltipWidth - 16;
        tooltipTop = targetPosition.dy;
      case TooltipPosition.right:
        tooltipLeft = targetPosition.dx + targetSize.width + 16;
        tooltipTop = targetPosition.dy;
    }

    return Stack(
      children: [
        // 하이라이트 영역 (구멍)
        Positioned(
          left: targetPosition.dx - 8,
          top: targetPosition.dy - 8,
          child: Container(
            width: targetSize.width + 16,
            height: targetSize.height + 16,
            decoration: BoxDecoration(
              color: highlightColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        // 타겟 위젯 다시 그리기 (하이라이트 위에)
        Positioned(
          left: targetPosition.dx,
          top: targetPosition.dy,
          width: targetSize.width,
          height: targetSize.height,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Builder(
                builder: (context) {
                  // 타겟 위젯의 실제 내용을 복사할 수 없으므로
                  // 하이라이트만 표시
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
        // 툴팁
        Positioned(
          left: tooltipLeft,
          top: tooltipTop,
          child: SubbyTooltip(
            title: title,
            description: description,
          ),
        ),
      ],
    );
  }
}

/// 더미 Summary Card
class _DummySummaryCard extends StatelessWidget {
  const _DummySummaryCard({super.key});

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        children: [
          _DummySubscriptionCard(name: 'Subby 구독', amount: '₩1,000'),
          const SizedBox(height: AppSpacing.s3),
          _DummySubscriptionCard(name: 'Claude', amount: '\$1.10'),
          const SizedBox(height: AppSpacing.s3),
          _DummySubscriptionCard(name: 'Youtube', amount: '₩14,500'),
          const SizedBox(height: AppSpacing.s3),
          _DummySubscriptionCard(name: 'Subby 구독', amount: '₩1,000'),
          const SizedBox(height: AppSpacing.s3),
          _DummySubscriptionCard(name: 'Subby 구독', amount: '₩1,000'),
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
    final colors = context.colors;

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
