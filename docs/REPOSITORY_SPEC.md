# Repository 인터페이스 명세

## 개요

Repository는 Domain Layer에서 정의된 **인터페이스**로, Data Layer에서 구현됩니다.
UseCase는 Repository 인터페이스에만 의존하며, 구체적인 데이터 소스(DB, API)를 알지 못합니다.

---

## AuthRepository

**파일**: `lib/domain/repository/auth_repository.dart`
**구현체**: `lib/data/repository/auth_repository_impl.dart`

인증 관련 기능을 담당합니다.

| 타입 | 메서드/속성 | 반환 타입 | 설명 |
|------|------------|----------|------|
| Getter | `currentUserId` | `String?` | 현재 로그인된 사용자 ID |
| Getter | `isAnonymous` | `bool` | 익명 로그인 여부 |
| Stream | `authStateChanges` | `Stream<String?>` | 인증 상태 변화 스트림 |
| Method | `signInAnonymously()` | `Future<String>` | 익명 로그인 |
| Method | `signInWithGoogle()` | `Future<GoogleSignInResult>` | Google 로그인 |
| Method | `signOut()` | `Future<void>` | 로그아웃 |

---

## UserRepository

**파일**: `lib/domain/repository/user_repository.dart`
**구현체**: `lib/data/repository/user_repository_impl.dart`

사용자 정보(닉네임 등) 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getNickname(userId)` | `Future<String?>` | 원격에서 사용자 닉네임 조회 |
| `getLocalNickname()` | `Future<String?>` | 로컬에서 닉네임 조회 |
| `saveNickname(userId, nickname)` | `Future<void>` | 원격에 닉네임 저장 |
| `saveLocalNickname(nickname)` | `Future<void>` | 로컬에 닉네임 저장 |
| `clearLocalNickname()` | `Future<void>` | 로컬 닉네임 삭제 |
| `getLocalUserId()` | `Future<String?>` | 로컬에서 사용자 ID 조회 |
| `saveLocalUserId(id)` | `Future<void>` | 로컬에 사용자 ID 저장 |
| `clearLocalUserId()` | `Future<void>` | 로컬 사용자 ID 삭제 |

---

## GroupRepository

**파일**: `lib/domain/repository/group_repository.dart`
**구현체**: `lib/data/repository/group_repository_impl.dart`

구독 그룹 관리를 담당합니다.

### 로컬 조회/감시

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<SubscriptionGroup>>` | 모든 그룹 조회 |
| `getByCode(code)` | `Future<SubscriptionGroup?>` | 코드로 그룹 조회 |
| `existsByName(name)` | `Future<bool>` | 이름으로 그룹 존재 여부 |
| `watchAll()` | `Stream<List<SubscriptionGroup>>` | 모든 그룹 실시간 감시 |
| `watchByCode(code)` | `Stream<SubscriptionGroup?>` | 특정 그룹 실시간 감시 |

### 로컬 수정

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `create(group)` | `Future<void>` | 그룹 생성 (로컬) |
| `update(group)` | `Future<void>` | 그룹 수정 (로컬) |
| `leaveGroup(code, userId)` | `Future<void>` | 그룹 탈퇴 (로컬) |
| `updateDisplayName(code, displayName)` | `Future<void>` | 표시명 변경 (로컬) |
| `saveToLocal(group)` | `Future<void>` | 로컬에만 저장 |
| `clearLocalData()` | `Future<void>` | 로컬 데이터 전체 삭제 |

### 원격 동기화

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `syncCreate(group, {ownerNickname})` | `Future<void>` | 그룹 생성 동기화 |
| `syncUpdate(group)` | `Future<void>` | 그룹 수정 동기화 |
| `syncLeave(code, userId)` | `Future<void>` | 그룹 탈퇴 동기화 |

### 원격 조회

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `fetchRemoteByCode(code)` | `Future<SubscriptionGroup?>` | 원격에서 그룹 조회 |
| `joinGroup(code, userId)` | `Future<void>` | 그룹 참여 (원격+로컬) |
| `fetchRemoteGroupsByUserId(userId)` | `Future<List<SubscriptionGroup>>` | 사용자의 모든 그룹 조회 |
| `watchRemoteGroupsByUserId(userId)` | `Stream<List<SubscriptionGroup>>` | 사용자의 모든 그룹 감시 |
| `updateMemberNicknameInGroups(...)` | `Future<void>` | 여러 그룹에서 멤버 닉네임 변경 |

---

## SubscriptionRepository

**파일**: `lib/domain/repository/subscription_repository.dart`
**구현체**: `lib/data/repository/subscription_repository_impl.dart`

구독 항목 관리를 담당합니다.

### 로컬 CRUD

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<UserSubscription>>` | 모든 구독 조회 |
| `getById(id)` | `Future<UserSubscription?>` | ID로 구독 조회 |
| `create(subscription)` | `Future<void>` | 구독 생성 |
| `update(subscription)` | `Future<void>` | 구독 수정 |
| `delete(id)` | `Future<void>` | 구독 삭제 |
| `deleteByGroupCode(groupCode)` | `Future<void>` | 그룹별 구독 전체 삭제 |
| `watchAll()` | `Stream<List<UserSubscription>>` | 모든 구독 실시간 감시 |
| `clearLocalData()` | `Future<void>` | 로컬 데이터 전체 삭제 |

### 원격 동기화

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `syncCreate(subscription)` | `Future<void>` | 구독 생성 동기화 |
| `syncUpdate(subscription)` | `Future<void>` | 구독 수정 동기화 |
| `syncDelete(groupCode, subscriptionId)` | `Future<void>` | 구독 삭제 동기화 |
| `fetchRemoteByGroupCode(groupCode)` | `Future<List<UserSubscription>>` | 원격에서 그룹 구독 조회 |

---

## SettingsRepository

**파일**: `lib/domain/repository/settings_repository.dart`
**구현체**: `lib/data/repository/settings_repository_impl.dart`

앱 설정 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getThemeMode()` | `Future<ThemeMode>` | 테마 모드 조회 |
| `setThemeMode(mode)` | `Future<void>` | 테마 모드 저장 |
| `getDefaultCurrency()` | `Future<Currency>` | 기본 통화 조회 |
| `setDefaultCurrency(currency)` | `Future<void>` | 기본 통화 저장 |
| `isNotificationEnabled()` | `Future<bool>` | 알림 활성화 여부 조회 |
| `setNotificationEnabled(enabled)` | `Future<void>` | 알림 활성화 설정 |
| `getLastSelectedGroupCode()` | `Future<String?>` | 마지막 선택 그룹 코드 조회 |
| `setLastSelectedGroupCode(code)` | `Future<void>` | 마지막 선택 그룹 코드 저장 |

---

## OnboardingRepository

**파일**: `lib/domain/repository/onboarding_repository.dart`
**구현체**: `lib/data/repository/onboarding_repository_impl.dart`

온보딩 상태 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `isOnboardingCompleted()` | `Future<bool>` | 온보딩 완료 여부 |
| `completeOnboarding()` | `Future<void>` | 온보딩 완료 처리 |
| `isTutorialCompleted()` | `Future<bool>` | 튜토리얼 완료 여부 |
| `completeTutorial()` | `Future<void>` | 튜토리얼 완료 처리 |
| `isSetupCompleted()` | `Future<bool>` | 초기 설정 완료 여부 |
| `completeSetup()` | `Future<void>` | 초기 설정 완료 처리 |

---

## PendingChangeRepository

**파일**: `lib/domain/repository/pending_change_repository.dart`
**구현체**: `lib/data/repository/pending_change_repository_impl.dart`

오프라인 변경사항(Pending Changes) 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<PendingChange>>` | 모든 대기 변경 조회 |
| `getByEntityId(entityId)` | `Future<PendingChange?>` | 엔티티 ID로 조회 |
| `save(change)` | `Future<void>` | 대기 변경 저장 |
| `delete(entityId)` | `Future<void>` | 대기 변경 삭제 |
| `deleteAll()` | `Future<void>` | 모든 대기 변경 삭제 |
| `saveGroupChange(group, action)` | `Future<void>` | 그룹 변경 저장 |
| `getGroupChanges()` | `Future<List<(PendingChange, SubscriptionGroup?)>>` | 그룹 변경 목록 |
| `saveSubscriptionChange(subscription, action)` | `Future<void>` | 구독 변경 저장 |
| `getSubscriptionChanges()` | `Future<List<(PendingChange, UserSubscription?)>>` | 구독 변경 목록 |

**ChangeAction**: `create` | `update` | `delete`

---

## PresetRepository

**파일**: `lib/domain/repository/preset_repository.dart`
**구현체**: `lib/data/repository/preset_repository_impl.dart`

구독 프리셋(템플릿) 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getPresets({forceRefresh})` | `Future<List<SubscriptionPreset>>` | 프리셋 목록 (캐시/원격) |
| `getPresetsFromCache()` | `Future<List<SubscriptionPreset>>` | 캐시된 프리셋만 조회 |
| `fetchAndCachePresets()` | `Future<List<SubscriptionPreset>>` | 원격에서 조회 후 캐싱 |

---

## ExchangeRateRepository

**파일**: `lib/domain/repository/exchange_rate_repository.dart`
**구현체**: `lib/data/repository/exchange_rate_repository_impl.dart`

환율 정보 관리를 담당합니다.

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getExchangeRate()` | `Future<ExchangeRate?>` | 환율 정보 조회 (캐시 우선) |
