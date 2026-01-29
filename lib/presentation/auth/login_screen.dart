import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/data/datasource/firebase_auth_datasource.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 아이콘
              Icon(
                Icons.account_circle_outlined,
                size: 80,
                color: colors.bgAccent,
              ),
              const SizedBox(height: AppSpacing.s5),

              // 제목
              Text(
                '내 그룹 찾기',
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s3),

              // 설명
              Text(
                '로그인하면 이전에 사용하던\n그룹을 다시 불러올 수 있어요',
                style: AppTypography.bodyLarge.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 1),

              // Google 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.g_mobiledata, size: 24),
                  label: Text(_isLoading ? '로그인 중...' : 'Google로 계속하기'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 안내 문구
              Container(
                padding: const EdgeInsets.all(AppSpacing.s3),
                decoration: BoxDecoration(
                  color: colors.statusWarning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colors.statusWarning,
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: Text(
                        '로그인하지 않으면 기기 변경 시 데이터를 복구할 수 없습니다',
                        style: AppTypography.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final authDataSource = ref.read(firebaseAuthDataSourceProvider);
      final result = await authDataSource.signInWithGoogle();

      if (!mounted) return;

      switch (result) {
        case GoogleSignInSuccess(:final isNewUser):
          await _loadUserGroups(isNewUser);
        case GoogleSignInCancelled():
          // 사용자가 취소함
          break;
        case GoogleSignInError(:final message):
          _showErrorSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadUserGroups(bool isNewUser) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final groupRepository = ref.read(groupRepositoryProvider);
    final groups = await groupRepository.fetchRemoteGroupsByUserId(user.uid);

    if (!mounted) return;

    if (groups.isEmpty) {
      _showNoGroupsDialog();
    } else {
      // 그룹을 로컬에 저장
      for (final group in groups) {
        await groupRepository.saveToLocal(group);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${groups.length}개의 그룹을 복구했습니다')),
      );
      Navigator.pop(context);
    }
  }

  void _showNoGroupsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('연결된 그룹 없음'),
        content: const Text(
          '이 계정에 연결된 그룹이 없습니다.\n새 그룹을 만들거나 초대 코드로 참여해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 로그인 화면 닫기
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로그인 실패: $message')),
    );
  }
}
