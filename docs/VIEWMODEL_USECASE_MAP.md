# ViewModel & UseCase 매핑 문서

## 아키텍처 개요

```
View (Screen) → ViewModel → UseCase → Repository → DataSource
```

- **View**: UI 렌더링, 사용자 입력 처리
- **ViewModel**: 상태 관리, 비즈니스 로직 조율
- **UseCase**: 단일 비즈니스 로직 단위
- **Repository**: 데이터 접근 추상화
- **DataSource**: 실제 데이터 소스 (Local DB, Remote API)

---

## 화면별 ViewModel 매핑

### 1. HomeScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/home/home_screen.dart` |
| ViewModel | `HomeViewModel` |
| Provider | `homeViewModelProvider` |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `watchGroupsUseCaseProvider` | 로컬 그룹 목록 실시간 감시 |
| `syncRemoteGroupsUseCaseProvider` | 원격 그룹 변경사항 동기화 |
| `watchSubscriptionsUseCaseProvider` | 구독 목록 실시간 감시 |
| `deleteSubscriptionUseCaseProvider` | 구독 삭제 |

---

### 2. SetupScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/setup/setup_screen.dart` |
| ViewModel | `SetupViewModel` |
| Provider | `setupViewModelProvider` |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `checkAuthStateUseCaseProvider` | 현재 인증 상태 확인 |
| `syncNicknameAfterLoginUseCaseProvider` | 로그인 후 닉네임 동기화 |
| `signInAnonymouslyUseCaseProvider` | 익명 로그인 수행 |
| `saveNicknameUseCaseProvider` | 닉네임 저장 |

---

### 3. SubscriptionAddScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/subscription/subscription_add_screen.dart` |
| ViewModel | `SubscriptionAddViewModel` |
| Provider | `subscriptionAddViewModelProvider` (family, 파라미터: `String?` subscriptionId) |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `getSubscriptionByIdUseCaseProvider` | 수정 모드 시 기존 구독 조회 |
| `getPresetsUseCaseProvider` | 구독 프리셋 목록 로드 |
| `addSubscriptionUseCaseProvider` | 새 구독 생성 |
| `updateSubscriptionUseCaseProvider` | 기존 구독 수정 |

---

### 4. SubscriptionEditScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/subscription/subscription_edit_screen.dart` |
| ViewModel | `SubscriptionEditViewModel` |
| Provider | `subscriptionEditViewModelProvider` (family, 파라미터: `String` subscriptionId) |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `getSubscriptionByIdUseCaseProvider` | 구독 상세 조회 |
| `updateSubscriptionUseCaseProvider` | 구독 수정 |
| `deleteSubscriptionUseCaseProvider` | 구독 삭제 |

---

## ViewModel 없이 Provider 직접 사용하는 화면

### 5. SubscriptionDetailScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/subscription/subscription_detail_screen.dart` |
| Provider | `subscriptionDetailProvider` (FutureProvider.family) |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `getSubscriptionByIdUseCaseProvider` | 구독 상세 조회 |

---

### 6. OnboardingScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/onboarding/onboarding_screen.dart` |
| ViewModel | 없음 |

**사용 Provider:**
- `onboardingTypeProvider` - 온보딩 타입 설정
- `onboardingCompletedProvider` - 온보딩 완료 상태

---

### 7. OnboardingTutorialScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/onboarding/onboarding_tutorial_screen.dart` |
| ViewModel | 없음 |

순수 UI 컴포넌트 화면 (UseCase 사용 없음)

---

### 8. OnboardingCoachMarkScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/onboarding/onboarding_coach_mark_screen.dart` |
| ViewModel | 없음 |

순수 UI 컴포넌트 화면 (UseCase 사용 없음)

---

### 9. SettingsScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/settings/settings_screen.dart` |
| ViewModel | 없음 |

**사용 Provider:**
- `themeModeProvider` - 테마 모드 설정
- `defaultCurrencyProvider` - 기본 통화 설정
- `notificationEnabledProvider` - 알림 설정
- `currentNicknameProvider` - 닉네임 표시
- `isAnonymousProvider` - 로그인 상태 표시

---

### 10. WebViewScreen
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/webview/webview_screen.dart` |
| ViewModel | 없음 |

순수 StatefulWidget (UseCase 사용 없음)

---

## 공통 위젯의 UseCase 사용

### AppDrawer
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/common/app_drawer.dart` |
| 타입 | ConsumerWidget |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `saveNicknameUseCaseProvider` | 닉네임 변경 |
| `updateGroupDisplayNameUseCaseProvider` | 그룹 이름 변경 |
| `leaveGroupUseCaseProvider` | 그룹 나가기 |
| `signOutUseCaseProvider` | 로그아웃 |
| `checkAuthStateUseCaseProvider` | 인증 상태 확인 (LoginDialog) |
| `signInWithGoogleUseCaseProvider` | Google 로그인 (LoginDialog) |
| `syncUserDataAfterLoginUseCaseProvider` | 로그인 후 데이터 동기화 (LoginDialog) |

---

### GroupActions (공통 다이얼로그)
| 항목 | 내용 |
|------|------|
| 경로 | `lib/presentation/common/group_actions.dart` |
| 타입 | 함수 모음 |

**사용 UseCase:**
| UseCase | 용도 |
|---------|------|
| `createGroupUseCaseProvider` | 그룹 생성 |
| `joinGroupUseCaseProvider` | 그룹 참여 |

---

## 전체 UseCase 목록

총 **21개** UseCase:

| # | Provider | UseCase 클래스 | 용도 |
|---|----------|---------------|------|
| 1 | `createGroupUseCaseProvider` | `CreateGroupUseCase` | 그룹 생성 |
| 2 | `leaveGroupUseCaseProvider` | `LeaveGroupUseCase` | 그룹 나가기 |
| 3 | `joinGroupUseCaseProvider` | `JoinGroupUseCase` | 그룹 참여 |
| 4 | `watchSubscriptionsUseCaseProvider` | `WatchSubscriptionsUseCase` | 구독 목록 감시 |
| 5 | `addSubscriptionUseCaseProvider` | `AddSubscriptionUseCase` | 구독 추가 |
| 6 | `getSubscriptionByIdUseCaseProvider` | `GetSubscriptionByIdUseCase` | ID로 구독 조회 |
| 7 | `updateSubscriptionUseCaseProvider` | `UpdateSubscriptionUseCase` | 구독 수정 |
| 8 | `deleteSubscriptionUseCaseProvider` | `DeleteSubscriptionUseCase` | 구독 삭제 |
| 9 | `getPresetsUseCaseProvider` | `GetPresetsUseCase` | 프리셋 목록 조회 |
| 10 | `detectSubscriptionConflictUseCaseProvider` | `DetectSubscriptionConflictUseCase` | 구독 충돌 감지 |
| 11 | `processPendingChangesUseCaseProvider` | `ProcessPendingChangesUseCase` | 대기 중 변경사항 처리 |
| 12 | `syncNicknameAfterLoginUseCaseProvider` | `SyncNicknameAfterLoginUseCase` | 로그인 후 닉네임 동기화 |
| 13 | `saveNicknameUseCaseProvider` | `SaveNicknameUseCase` | 닉네임 저장 |
| 14 | `checkAuthStateUseCaseProvider` | `CheckAuthStateUseCase` | 인증 상태 확인 |
| 15 | `signInAnonymouslyUseCaseProvider` | `SignInAnonymouslyUseCase` | 익명 로그인 |
| 16 | `signOutUseCaseProvider` | `SignOutUseCase` | 로그아웃 |
| 17 | `updateGroupDisplayNameUseCaseProvider` | `UpdateGroupDisplayNameUseCase` | 그룹 표시이름 변경 |
| 18 | `watchGroupsUseCaseProvider` | `WatchGroupsUseCase` | 그룹 목록 감시 |
| 19 | `syncRemoteGroupsUseCaseProvider` | `SyncRemoteGroupsUseCase` | 원격 그룹 동기화 |
| 20 | `syncUserDataAfterLoginUseCaseProvider` | `SyncUserDataAfterLoginUseCase` | 로그인 후 사용자 데이터 동기화 |
| 21 | `signInWithGoogleUseCaseProvider` | `SignInWithGoogleUseCase` | Google 로그인 |

---

## 통계

| 항목 | 수치 |
|------|------|
| 전체 화면 수 | 10 |
| ViewModel 사용 화면 | 4 |
| ViewModel 미사용 화면 | 6 |
| 전체 ViewModel 수 | 4 |
| 전체 UseCase 수 | 21 |
| 가장 많이 사용되는 UseCase | `getSubscriptionByIdUseCaseProvider` (3곳) |

---

## 파일 구조

```
lib/
├── presentation/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── home_view_model.dart
│   ├── setup/
│   │   ├── setup_screen.dart
│   │   └── setup_view_model.dart
│   ├── subscription/
│   │   ├── subscription_add_screen.dart
│   │   ├── subscription_add_view_model.dart
│   │   ├── subscription_edit_screen.dart
│   │   ├── subscription_edit_view_model.dart
│   │   └── subscription_detail_screen.dart
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   ├── onboarding_tutorial_screen.dart
│   │   └── onboarding_coach_mark_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── webview/
│   │   └── webview_screen.dart
│   └── common/
│       ├── app_drawer.dart
│       ├── group_actions.dart
│       └── providers/
│           └── app_state_providers.dart
└── domain/
    └── usecase/
        ├── add_subscription_usecase.dart
        ├── check_auth_state_usecase.dart
        ├── create_group_usecase.dart
        ├── delete_subscription_usecase.dart
        ├── detect_subscription_conflict_usecase.dart
        ├── get_presets_usecase.dart
        ├── get_subscription_by_id_usecase.dart
        ├── join_group_usecase.dart
        ├── leave_group_usecase.dart
        ├── process_pending_changes_usecase.dart
        ├── save_nickname_usecase.dart
        ├── sign_in_anonymously_usecase.dart
        ├── sign_in_with_google_usecase.dart
        ├── sign_out_usecase.dart
        ├── sync_nickname_after_login_usecase.dart
        ├── sync_remote_groups_usecase.dart
        ├── sync_user_data_after_login_usecase.dart
        ├── update_group_display_name_usecase.dart
        ├── update_subscription_usecase.dart
        ├── watch_groups_usecase.dart
        └── watch_subscriptions_usecase.dart
```
