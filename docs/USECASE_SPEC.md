# UseCase 명세

## 개요

UseCase는 **단일 비즈니스 로직**을 캡슐화합니다.
- 하나의 UseCase는 하나의 작업만 수행
- Repository 인터페이스에만 의존
- `call()` 메서드로 실행

---

## Auth 관련 UseCase

### WatchAuthStateUseCase

**파일**: `lib/domain/usecase/watch_auth_state_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 인증 상태 변화 스트림 반환 |
| **의존성** | `AuthRepository` |
| **메서드** | `call()` → `Stream<String?>` |

### CheckAuthStateUseCase

**파일**: `lib/domain/usecase/check_auth_state_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 현재 인증 상태 확인 |
| **의존성** | `AuthRepository` |
| **메서드** | `call()` → `String?` (현재 사용자 ID) |

### SignInAnonymouslyUseCase

**파일**: `lib/domain/usecase/sign_in_anonymously_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 익명 로그인 수행 |
| **의존성** | `AuthRepository` |
| **메서드** | `call()` → `Future<String>` (로그인된 사용자 ID) |

### SignInWithGoogleUseCase

**파일**: `lib/domain/usecase/sign_in_with_google_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | Google 로그인 수행 |
| **의존성** | `AuthRepository` |
| **메서드** | `call()` → `Future<GoogleSignInResult>` |

### SignOutUseCase

**파일**: `lib/domain/usecase/sign_out_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 로그아웃 및 로컬 데이터 정리 |
| **의존성** | `AuthRepository`, `UserRepository`, `GroupRepository`, `SubscriptionRepository`, `PendingChangeRepository` |
| **메서드** | `call()` → `Future<void>` |

---

## User 관련 UseCase

### FetchUserInfoUseCase

**파일**: `lib/domain/usecase/fetch_user_info_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 사용자 정보(닉네임) 조회 |
| **의존성** | `AuthRepository`, `UserRepository` |
| **메서드** | `call()` → `Future<String?>` (닉네임) |

### SaveUserInfoUseCase

**파일**: `lib/domain/usecase/save_user_info_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 사용자 정보(닉네임) 저장 및 그룹 멤버 정보 업데이트 |
| **의존성** | `AuthRepository`, `UserRepository`, `GroupRepository` |
| **메서드** | `call(nickname)` → `Future<void>` |

### SyncUserDataAfterLoginUseCase

**파일**: `lib/domain/usecase/sync_user_data_after_login_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | Google 로그인 후 사용자 데이터 동기화 |
| **의존성** | `AuthRepository`, `GroupRepository`, `UserRepository` |
| **메서드** | `call()` → `Future<void>` |

---

## Onboarding 관련 UseCase

### CheckOnboardingCompletedUseCase

**파일**: `lib/domain/usecase/check_onboarding_completed_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 온보딩 완료 여부 확인 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<bool>` |

### CompleteOnboardingUseCase

**파일**: `lib/domain/usecase/complete_onboarding_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 온보딩 완료 처리 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<void>` |

### CheckTutorialCompletedUseCase

**파일**: `lib/domain/usecase/check_tutorial_completed_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 튜토리얼 완료 여부 확인 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<bool>` |

### CompleteTutorialUseCase

**파일**: `lib/domain/usecase/complete_tutorial_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 튜토리얼 완료 처리 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<void>` |

### CheckSetupCompletedUseCase

**파일**: `lib/domain/usecase/check_setup_completed_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 초기 설정 완료 여부 확인 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<bool>` |

### CompleteSetupUseCase

**파일**: `lib/domain/usecase/complete_setup_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 초기 설정 완료 처리 |
| **의존성** | `OnboardingRepository` |
| **메서드** | `call()` → `Future<void>` |

---

## Settings 관련 UseCase

### GetThemeModeUseCase

**파일**: `lib/domain/usecase/get_theme_mode_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 테마 모드 조회 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call()` → `Future<ThemeMode>` |

### SetThemeModeUseCase

**파일**: `lib/domain/usecase/set_theme_mode_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 테마 모드 저장 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call(mode)` → `Future<void>` |

### GetDefaultCurrencyUseCase

**파일**: `lib/domain/usecase/get_default_currency_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 기본 통화 조회 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call()` → `Future<Currency>` |

### SetDefaultCurrencyUseCase

**파일**: `lib/domain/usecase/set_default_currency_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 기본 통화 저장 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call(currency)` → `Future<void>` |

### CheckNotificationEnabledUseCase

**파일**: `lib/domain/usecase/check_notification_enabled_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 알림 활성화 여부 확인 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call()` → `Future<bool>` |

### SetNotificationEnabledUseCase

**파일**: `lib/domain/usecase/set_notification_enabled_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 알림 활성화 설정 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call(enabled)` → `Future<void>` |

### GetLastSelectedGroupCodeUseCase

**파일**: `lib/domain/usecase/get_last_selected_group_code_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 마지막 선택 그룹 코드 조회 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call()` → `Future<String?>` |

### SaveLastSelectedGroupCodeUseCase

**파일**: `lib/domain/usecase/save_last_selected_group_code_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 마지막 선택 그룹 코드 저장 |
| **의존성** | `SettingsRepository` |
| **메서드** | `call(code)` → `Future<void>` |

---

## Group 관련 UseCase

### CreateGroupUseCase

**파일**: `lib/domain/usecase/create_group_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 새 구독 그룹 생성 |
| **의존성** | `AuthRepository`, `GroupRepository`, `UserRepository`, `PendingChangeRepository` |
| **메서드** | `call(name)` → `Future<SubscriptionGroup>` |

### JoinGroupUseCase

**파일**: `lib/domain/usecase/join_group_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 기존 그룹에 참여 |
| **의존성** | `GroupRepository`, `AuthRepository`, `UserRepository` |
| **메서드** | `call(code)` → `Future<JoinGroupResult>` |

### LeaveGroupUseCase

**파일**: `lib/domain/usecase/leave_group_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 그룹 탈퇴 |
| **의존성** | `AuthRepository`, `GroupRepository`, `SubscriptionRepository`, `PendingChangeRepository` |
| **메서드** | `call(code)` → `Future<void>` |

### WatchGroupsUseCase

**파일**: `lib/domain/usecase/watch_groups_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 모든 그룹 실시간 감시 |
| **의존성** | `GroupRepository` |
| **메서드** | `call()` → `Stream<List<SubscriptionGroup>>` |

### WatchGroupByCodeUseCase

**파일**: `lib/domain/usecase/watch_group_by_code_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 특정 그룹 실시간 감시 |
| **의존성** | `GroupRepository` |
| **메서드** | `call(code)` → `Stream<SubscriptionGroup?>` |

### UpdateGroupDisplayNameUseCase

**파일**: `lib/domain/usecase/update_group_display_name_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 그룹 표시명 변경 |
| **의존성** | `GroupRepository` |
| **메서드** | `call(code, displayName)` → `Future<void>` |

### SyncRemoteGroupsUseCase

**파일**: `lib/domain/usecase/sync_remote_groups_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 원격 그룹 목록 동기화 |
| **의존성** | `AuthRepository`, `GroupRepository` |
| **메서드** | `call()` → `Future<void>` |

---

## Subscription 관련 UseCase

### WatchSubscriptionsUseCase

**파일**: `lib/domain/usecase/watch_subscriptions_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 모든 구독 실시간 감시 |
| **의존성** | `SubscriptionRepository` |
| **메서드** | `call()` → `Stream<List<UserSubscription>>` |

### GetSubscriptionByIdUseCase

**파일**: `lib/domain/usecase/get_subscription_by_id_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | ID로 구독 조회 |
| **의존성** | `SubscriptionRepository` |
| **메서드** | `call(id)` → `Future<UserSubscription?>` |

### AddSubscriptionUseCase

**파일**: `lib/domain/usecase/add_subscription_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 새 구독 추가 |
| **의존성** | `SubscriptionRepository`, `PendingChangeRepository` |
| **메서드** | `call(subscription)` → `Future<void>` |

### UpdateSubscriptionUseCase

**파일**: `lib/domain/usecase/update_subscription_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 구독 정보 수정 |
| **의존성** | `SubscriptionRepository`, `PendingChangeRepository` |
| **메서드** | `call(subscription)` → `Future<void>` |

### DeleteSubscriptionUseCase

**파일**: `lib/domain/usecase/delete_subscription_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 구독 삭제 |
| **의존성** | `SubscriptionRepository`, `PendingChangeRepository` |
| **메서드** | `call(subscription)` → `Future<void>` |

---

## ExchangeRate 관련 UseCase

### GetExchangeRateUseCase

**파일**: `lib/domain/usecase/get_exchange_rate_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 환율 정보 조회 |
| **의존성** | `ExchangeRateRepository` |
| **메서드** | `call()` → `Future<ExchangeRate?>` |

---

## Sync 관련 UseCase

### ProcessPendingChangesUseCase

**파일**: `lib/domain/usecase/process_pending_changes_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 대기 중인 오프라인 변경사항 처리 |
| **의존성** | `PendingChangeRepository`, `GroupRepository`, `SubscriptionRepository`, `AuthRepository`, `DetectSubscriptionConflictUseCase` |
| **메서드** | `call({onConflict})` → `Future<void>` |

### DetectSubscriptionConflictUseCase

**파일**: `lib/domain/usecase/detect_subscription_conflict_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 구독 데이터 충돌 감지 |
| **의존성** | 없음 (순수 로직) |
| **메서드** | `call(local, remote)` → `ConflictType?` |

---

## Preset 관련 UseCase

### GetPresetsUseCase

**파일**: `lib/domain/usecase/get_presets_usecase.dart`

| 항목 | 내용 |
|------|------|
| **설명** | 구독 프리셋 목록 조회 |
| **의존성** | `PresetRepository` |
| **메서드** | `call({forceRefresh})` → `Future<List<SubscriptionPreset>>` |

---

## UseCase Provider 매핑

**파일**: `lib/core/di/domain/usecase_providers.dart`

### Auth
| UseCase | Provider |
|---------|----------|
| `WatchAuthStateUseCase` | `watchAuthStateUseCaseProvider` |
| `CheckAuthStateUseCase` | `checkAuthStateUseCaseProvider` |
| `SignInAnonymouslyUseCase` | `signInAnonymouslyUseCaseProvider` |
| `SignInWithGoogleUseCase` | `signInWithGoogleUseCaseProvider` |
| `SignOutUseCase` | `signOutUseCaseProvider` |

### User
| UseCase | Provider |
|---------|----------|
| `FetchUserInfoUseCase` | `fetchUserInfoUseCaseProvider` |
| `SaveUserInfoUseCase` | `saveUserInfoUseCaseProvider` |
| `SyncUserDataAfterLoginUseCase` | `syncUserDataAfterLoginUseCaseProvider` |

### Onboarding
| UseCase | Provider |
|---------|----------|
| `CheckOnboardingCompletedUseCase` | `checkOnboardingCompletedUseCaseProvider` |
| `CompleteOnboardingUseCase` | `completeOnboardingUseCaseProvider` |
| `CheckTutorialCompletedUseCase` | `checkTutorialCompletedUseCaseProvider` |
| `CompleteTutorialUseCase` | `completeTutorialUseCaseProvider` |
| `CheckSetupCompletedUseCase` | `checkSetupCompletedUseCaseProvider` |
| `CompleteSetupUseCase` | `completeSetupUseCaseProvider` |

### Settings
| UseCase | Provider |
|---------|----------|
| `GetThemeModeUseCase` | `getThemeModeUseCaseProvider` |
| `SetThemeModeUseCase` | `setThemeModeUseCaseProvider` |
| `GetDefaultCurrencyUseCase` | `getDefaultCurrencyUseCaseProvider` |
| `SetDefaultCurrencyUseCase` | `setDefaultCurrencyUseCaseProvider` |
| `CheckNotificationEnabledUseCase` | `checkNotificationEnabledUseCaseProvider` |
| `SetNotificationEnabledUseCase` | `setNotificationEnabledUseCaseProvider` |
| `GetLastSelectedGroupCodeUseCase` | `getLastSelectedGroupCodeUseCaseProvider` |
| `SaveLastSelectedGroupCodeUseCase` | `saveLastSelectedGroupCodeUseCaseProvider` |

### Group
| UseCase | Provider |
|---------|----------|
| `CreateGroupUseCase` | `createGroupUseCaseProvider` |
| `JoinGroupUseCase` | `joinGroupUseCaseProvider` |
| `LeaveGroupUseCase` | `leaveGroupUseCaseProvider` |
| `WatchGroupsUseCase` | `watchGroupsUseCaseProvider` |
| `WatchGroupByCodeUseCase` | `watchGroupByCodeUseCaseProvider` |
| `UpdateGroupDisplayNameUseCase` | `updateGroupDisplayNameUseCaseProvider` |
| `SyncRemoteGroupsUseCase` | `syncRemoteGroupsUseCaseProvider` |

### Subscription
| UseCase | Provider |
|---------|----------|
| `WatchSubscriptionsUseCase` | `watchSubscriptionsUseCaseProvider` |
| `GetSubscriptionByIdUseCase` | `getSubscriptionByIdUseCaseProvider` |
| `AddSubscriptionUseCase` | `addSubscriptionUseCaseProvider` |
| `UpdateSubscriptionUseCase` | `updateSubscriptionUseCaseProvider` |
| `DeleteSubscriptionUseCase` | `deleteSubscriptionUseCaseProvider` |

### ExchangeRate
| UseCase | Provider |
|---------|----------|
| `GetExchangeRateUseCase` | `getExchangeRateUseCaseProvider` |

### Sync
| UseCase | Provider |
|---------|----------|
| `ProcessPendingChangesUseCase` | `processPendingChangesUseCaseProvider` |
| `DetectSubscriptionConflictUseCase` | `detectSubscriptionConflictUseCaseProvider` |

### Preset
| UseCase | Provider |
|---------|----------|
| `GetPresetsUseCase` | `getPresetsUseCaseProvider` |
