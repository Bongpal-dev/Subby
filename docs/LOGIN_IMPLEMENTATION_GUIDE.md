# 로그인 및 온보딩 구현 가이드

## 개요

Subby 앱에 로그인 기능과 개선된 온보딩 흐름을 구현하기 위한 가이드입니다.

---

## 1. 배경 및 결정 사항

### 현재 문제점
- 익명 로그인 기반으로 userId가 기기에 종속됨
- 기기 변경/앱 재설치 시 그룹 데이터 복구 불가
- 로그인 UI가 없어서 Google 로그인 코드가 사용되지 않음

### UX 원칙 (조사 결과 기반)
- **Value First, Login Later**: 로그인 강제 시 이탈률 증가
- **25%의 앱이 첫 사용 후 버려짐** - 가치를 먼저 보여줘야 함
- TikTok, DoorDash 등 성공 앱들은 로그인 없이 핵심 기능 체험 가능

### 확정된 앱 흐름

```
[현재 - MVP]
스플래시 → 홈 (Empty State 개선)
               ├─ 새 그룹 만들기 (익명으로 가능)
               ├─ 초대 코드로 참여 (익명으로 가능)
               └─ 로그인하여 내 그룹 찾기 (로그인 필수)

[나중에 - 온보딩 추가 시]
스플래시 → 온보딩 (1회) → 홈 (Empty State)
                           └─ "로그인해야 정보 유지" 문구
```

---

## 2. 구현 태스크

### Task 1: HomeScreen Empty State 개선

**파일**: `lib/presentation/home/home_screen.dart`

**현재 코드** (224-256줄):
```dart
class _NoGroupState extends StatelessWidget {
  const _NoGroupState();

  @override
  Widget build(BuildContext context) {
    // 현재는 텍스트만 표시
    return Align(
      alignment: const Alignment(0, -0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_outlined, size: 64, ...),
          Text('참여 중인 그룹이 없습니다', ...),
          Text('새 그룹을 만들거나 초대 코드로 참여하세요', ...),
        ],
      ),
    );
  }
}
```

**변경할 디자인**:
```
┌─────────────────────────────────────────┐
│  Subby                              ☰   │
├─────────────────────────────────────────┤
│                                         │
│            📋 (아이콘)                   │
│                                         │
│     구독을 한눈에 관리하세요              │
│     (서브 텍스트)                        │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      + 새 그룹 만들기            │   │  ← FilledButton (primary)
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      🔗 초대 코드로 참여          │   │  ← OutlinedButton
│  └─────────────────────────────────┘   │
│                                         │
│       ─────────────────────────         │
│                                         │
│       이미 사용 중이셨나요?              │  ← 구분선 + 텍스트
│       로그인하여 내 그룹 찾기 →          │  ← TextButton (작게)
│                                         │
└─────────────────────────────────────────┘
```

**구현 코드**:
```dart
class _NoGroupState extends ConsumerWidget {
  const _NoGroupState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // 아이콘
          Icon(
            Icons.subscriptions_outlined,
            size: 80,
            color: colors.primary.withValues(alpha: 0.6),
          ),
          SizedBox(height: AppSpacing.xl),

          // 메인 텍스트
          Text(
            '구독을 한눈에 관리하세요',
            style: AppTypography.headlineLarge.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '새 그룹을 만들거나 초대 코드로 참여해보세요',
            style: AppTypography.bodyLarge.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.xxxl),

          // 새 그룹 만들기 버튼
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showCreateGroupDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('새 그룹 만들기'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // 초대 코드로 참여 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showJoinGroupDialog(context, ref),
              icon: const Icon(Icons.link),
              label: const Text('초대 코드로 참여'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              ),
            ),
          ),

          const Spacer(flex: 1),

          // 구분선
          Row(
            children: [
              Expanded(child: Divider(color: colors.textTertiary.withValues(alpha: 0.3))),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  '이미 사용 중이셨나요?',
                  style: AppTypography.captionLarge.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colors.textTertiary.withValues(alpha: 0.3))),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // 로그인 링크
          TextButton(
            onPressed: () => _navigateToLogin(context),
            child: Text(
              '로그인하여 내 그룹 찾기',
              style: AppTypography.bodyLarge.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref) {
    // AppDrawer의 _showCreateGroupDialog 로직 재사용
    // 또는 별도 함수로 분리하여 공유
  }

  void _showJoinGroupDialog(BuildContext context, WidgetRef ref) {
    // AppDrawer의 _showJoinGroupDialog 로직 재사용
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
```

**주의사항**:
- `StatelessWidget` → `ConsumerWidget`으로 변경 필요 (ref 사용)
- 그룹 생성/참여 로직은 `AppDrawer`에 이미 있으므로 공통 함수로 추출 권장

---

### Task 2: 로그인 화면 생성

**새 파일**: `lib/presentation/auth/login_screen.dart`

**디자인**:
```
┌─────────────────────────────────────────┐
│  ←                                      │
├─────────────────────────────────────────┤
│                                         │
│            🔐 (아이콘)                   │
│                                         │
│         내 그룹 찾기                     │
│                                         │
│   로그인하면 이전에 사용하던             │
│   그룹을 다시 불러올 수 있어요           │
│                                         │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  G  Google로 계속하기            │   │  ← Google 로그인 버튼
│  └─────────────────────────────────┘   │
│                                         │
│                                         │
│   * 로그인하지 않으면 기기 변경 시       │  ← 안내 문구 (작게)
│     데이터를 복구할 수 없습니다          │
│                                         │
└─────────────────────────────────────────┘
```

**구현 코드**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
// auth provider import 필요

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
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 아이콘
              Icon(
                Icons.account_circle_outlined,
                size: 80,
                color: colors.primary,
              ),
              SizedBox(height: AppSpacing.xl),

              // 제목
              Text(
                '내 그룹 찾기',
                style: AppTypography.headlineLarge.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md),

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
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Image.asset(
                          'assets/icons/google_logo.png', // Google 로고 에셋 필요
                          width: 20,
                          height: 20,
                        ),
                  label: Text(_isLoading ? '로그인 중...' : 'Google로 계속하기'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 안내 문구
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colors.warning,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '로그인하지 않으면 기기 변경 시 데이터를 복구할 수 없습니다',
                        style: AppTypography.captionLarge.copyWith(
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
      // FirebaseAuthDataSource의 signInWithGoogle 호출
      // 성공 시:
      // 1. 해당 userId로 그룹 목록 조회
      // 2. 그룹이 있으면 홈으로 이동
      // 3. 그룹이 없으면 "연결된 그룹이 없습니다" 메시지

      final authDataSource = ref.read(firebaseAuthDataSourceProvider);
      final result = await authDataSource.signInWithGoogle();

      switch (result) {
        case GoogleSignInSuccess(:final userId, :final isNewUser):
          if (isNewUser) {
            // 새 사용자 - 그룹 없음
            _showNoGroupsDialog();
          } else {
            // 기존 사용자 - 그룹 동기화 후 홈으로
            await _syncAndNavigateHome(userId);
          }
        case GoogleSignInCancelled():
          // 사용자가 취소함 - 아무것도 안 함
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

  void _showNoGroupsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('연결된 그룹 없음'),
        content: const Text('이 계정에 연결된 그룹이 없습니다.\n새 그룹을 만들거나 초대 코드로 참여해주세요.'),
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

  Future<void> _syncAndNavigateHome(String userId) async {
    // TODO: userId로 Firebase에서 그룹 목록 조회 및 로컬 동기화
    // 구현 후 홈으로 이동
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('로그인 실패: $message')),
    );
  }
}
```

**필요한 추가 작업**:
1. `assets/icons/google_logo.png` 에셋 추가 (또는 아이콘 사용)
2. `firebaseAuthDataSourceProvider` 정의 확인
3. 로그인 성공 후 그룹 동기화 로직 구현

---

### Task 3: AppDrawer에 로그인 상태 표시

**파일**: `lib/presentation/common/app_drawer.dart`

**변경할 위치**: 하단 버튼 영역 (94-126줄)

**추가할 디자인**:
```
┌─────────────────────────────────────────┐
│  (그룹 목록)                             │
│  ...                                    │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │  + 새 그룹 만들기                │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  🔗 그룹 참여하기                │   │
│  └─────────────────────────────────┘   │
├─────────────────────────────────────────┤
│  [익명 상태일 때]                        │
│  ┌─────────────────────────────────┐   │
│  │  ⚠️ 백업되지 않음                │   │  ← 경고 배너
│  │  로그인하여 데이터 보호하기 →     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [로그인 상태일 때]                      │
│  ┌─────────────────────────────────┐   │
│  │  ✓ user@gmail.com              │   │  ← 이메일 표시
│  │                        로그아웃  │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

**구현 코드** (하단 영역에 추가):
```dart
// Container(color: colorScheme.surface, ...) 안에 추가

// 로그인 상태 섹션
_buildAccountSection(context, ref),
```

```dart
Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  final isAnonymous = authDataSource.isAnonymous;
  final email = authDataSource.currentEmail;
  final colors = Theme.of(context).brightness == Brightness.dark
      ? AppColors.dark
      : AppColors.light;

  if (isAnonymous) {
    // 익명 상태 - 백업 유도 배너
    return Container(
      margin: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colors.warning, size: 24),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '백업되지 않음',
                    style: AppTypography.titleSmall.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    '로그인하여 데이터 보호하기',
                    style: AppTypography.captionLarge.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.textTertiary),
          ],
        ),
      ),
    );
  } else {
    // 로그인 상태 - 계정 정보 표시
    return Container(
      margin: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: colors.success, size: 24),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              email ?? '로그인됨',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => _showSignOutDialog(context, ref),
            child: Text(
              '로그아웃',
              style: AppTypography.captionLarge.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showSignOutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('로그아웃하면 다른 기기에서 그룹에 접근할 수 없습니다.\n계속하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            final authDataSource = ref.read(firebaseAuthDataSourceProvider);
            await authDataSource.signOut();
            // 익명으로 다시 로그인
            await authDataSource.signInAnonymously();
          },
          child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

---

### Task 4: 공통 함수 추출

**새 파일**: `lib/presentation/common/group_actions.dart`

그룹 생성/참여 로직을 `AppDrawer`와 `_NoGroupState`에서 공유하기 위해 추출:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';

Future<void> showCreateGroupFlow(BuildContext context, WidgetRef ref) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final createGroup = ref.read(createGroupUseCaseProvider);
  final homeViewModel = ref.read(homeViewModelProvider.notifier);

  final groupName = await showAppTextInputDialog(
    context: context,
    title: '새 그룹 만들기',
    hint: '예: 가족 구독, 친구들',
    maxLength: 10,
    confirmLabel: '만들기',
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '그룹 이름을 입력해주세요';
      }
      return null;
    },
  );

  if (groupName != null) {
    try {
      final groupCode = await createGroup(groupName);
      homeViewModel.selectGroup(groupCode);
    } on Exception catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

Future<void> showJoinGroupFlow(BuildContext context, WidgetRef ref) async {
  final groupCode = await showAppTextInputDialog(
    context: context,
    title: '그룹 참여하기',
    hint: '12자리 그룹 코드 입력',
    maxLength: 12,
    confirmLabel: '확인',
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '그룹 코드를 입력해주세요';
      }

      final code = value.trim().toUpperCase();

      if (code.length != 12) {
        return '12자리 코드를 입력해주세요';
      }
      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
        return '영문 대문자와 숫자만 입력해주세요';
      }

      return null;
    },
  );

  if (groupCode == null) return;

  final code = groupCode.trim().toUpperCase();

  showJoinGroupDialog(
    context: context,
    groupCode: code,
  );
}
```

---

## 3. 파일 구조

```
lib/presentation/
├── auth/
│   └── login_screen.dart              # [NEW] 로그인 화면
├── common/
│   ├── app_drawer.dart                # [MODIFY] 로그인 상태 섹션 추가
│   ├── group_actions.dart             # [NEW] 그룹 생성/참여 공통 함수
│   └── widgets/
│       └── ...
├── home/
│   └── home_screen.dart               # [MODIFY] _NoGroupState 개선
└── ...
```

---

## 4. Provider 설정

**파일**: `lib/core/di/data/datasource_providers.dart` (또는 해당 위치)

```dart
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});
```

---

## 5. 체크리스트

- [ ] `_NoGroupState` 위젯 개선 (버튼 3개 추가)
- [ ] `LoginScreen` 생성
- [ ] `AppDrawer`에 로그인 상태 섹션 추가
- [ ] 공통 함수 추출 (`group_actions.dart`)
- [ ] `firebaseAuthDataSourceProvider` 설정 확인
- [ ] Google 로고 에셋 추가 (선택)
- [ ] 로그인 성공 후 그룹 동기화 로직 구현

---

## 6. 참고 - 기존 Auth 코드

### FirebaseAuthDataSource (이미 구현됨)
- `lib/data/datasource/firebase_auth_datasource.dart`
- `signInWithGoogle()` - Google 로그인
- `signInAnonymously()` - 익명 로그인
- `linkWithGoogle()` - 익명 계정에 Google 연결
- `isAnonymous` - 익명 여부
- `currentEmail` - 현재 이메일

### 주요 Result 타입
```dart
sealed class GoogleSignInResult {}
class GoogleSignInSuccess extends GoogleSignInResult { userId, email, isNewUser }
class GoogleSignInCancelled extends GoogleSignInResult {}
class GoogleSignInError extends GoogleSignInResult { code, message }
```

---

## 7. 나중에 추가할 것

1. **온보딩 화면** - 앱 첫 실행 시 1회 표시
2. **그룹 생성 후 백업 유도 배너** - 홈 화면 상단
3. **설정 화면** - 계정 관리 통합
