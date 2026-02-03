# DataSource 인터페이스 명세

## 개요

DataSource는 **실제 데이터 저장소에 접근**하는 최하위 계층입니다.
- **Local**: Drift(SQLite), SharedPreferences
- **Remote**: Firebase Firestore, Firebase Realtime Database

Repository 구현체에서만 DataSource를 사용합니다.

---

## FirebaseAuthDataSource

**파일**: `lib/data/datasource/firebase_auth_datasource.dart`
**저장소**: Firebase Auth

Firebase 인증 관련 기능을 담당합니다.

### 속성

| 속성 | 타입 | 설명 |
|------|------|------|
| `currentUserId` | `String?` | 현재 사용자 ID |
| `currentUser` | `User?` | 현재 Firebase User 객체 |
| `isAnonymous` | `bool` | 익명 로그인 여부 |
| `currentEmail` | `String?` | 현재 사용자 이메일 |
| `authStateChanges` | `Stream<String?>` | 인증 상태 변화 스트림 |
| `userChanges` | `Stream<User?>` | User 객체 변화 스트림 |

### 메서드

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `signInAnonymously()` | `Future<String>` | 익명 로그인 |
| `signOut()` | `Future<void>` | 로그아웃 |
| `signInWithGoogle()` | `Future<GoogleSignInResult>` | Google 로그인 |
| `linkWithGoogle()` | `Future<LinkAccountResult>` | 익명 계정에 Google 연결 |
| `signInWithExistingGoogle(credential)` | `Future<GoogleSignInResult>` | 기존 Google 계정으로 로그인 |
| `signOutGoogle()` | `Future<void>` | Google 로그아웃만 수행 |

---

## UserLocalDataSource

**파일**: `lib/data/datasource/user_local_datasource.dart`
**저장소**: SharedPreferences

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `saveNickname(nickname)` | `Future<void>` | 닉네임 저장 |
| `getNickname()` | `Future<String?>` | 닉네임 조회 |
| `clearNickname()` | `Future<void>` | 닉네임 삭제 |
| `saveLocalUserId(id)` | `Future<void>` | 로컬 사용자 ID 저장 |
| `getLocalUserId()` | `Future<String?>` | 로컬 사용자 ID 조회 |
| `clearLocalUserId()` | `Future<void>` | 로컬 사용자 ID 삭제 |

---

## UserRemoteDataSource

**파일**: `lib/data/datasource/user_remote_datasource.dart`
**저장소**: Firebase Firestore (`users` 컬렉션)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `saveNickname(userId, nickname)` | `Future<void>` | 원격에 닉네임 저장 |
| `getNickname(userId)` | `Future<String?>` | 원격에서 닉네임 조회 |

---

## GroupLocalDataSource

**파일**: `lib/data/datasource/group_local_datasource.dart`
**저장소**: Drift (`subscription_groups` 테이블)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<GroupDto>>` | 모든 그룹 조회 |
| `getByCode(code)` | `Future<GroupDto?>` | 코드로 그룹 조회 |
| `insert(dto)` | `Future<void>` | 그룹 삽입 |
| `update(dto)` | `Future<void>` | 그룹 수정 |
| `delete(code)` | `Future<void>` | 그룹 삭제 |
| `existsByName(name)` | `Future<bool>` | 이름으로 존재 여부 확인 |
| `updateDisplayName(code, displayName)` | `Future<void>` | 표시명 변경 |
| `watchAll()` | `Stream<List<GroupDto>>` | 모든 그룹 감시 |
| `watchByCode(code)` | `Stream<GroupDto?>` | 특정 그룹 감시 |
| `deleteAll()` | `Future<void>` | 모든 그룹 삭제 |

---

## GroupRemoteDataSource

**파일**: `lib/data/datasource/group_remote_datasource.dart`
**저장소**: Firebase Firestore (`groups` 컬렉션)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `saveGroup(dto, {ownerNickname})` | `Future<void>` | 그룹 저장 |
| `fetchGroup(code)` | `Future<GroupDto?>` | 그룹 조회 |
| `watchGroup(code)` | `Stream<GroupDto?>` | 그룹 감시 |
| `deleteGroup(code)` | `Future<void>` | 그룹 삭제 |
| `leaveGroup(code, userId)` | `Future<void>` | 멤버 제거 (마지막이면 삭제) |
| `addMember(code, userId, {nickname})` | `Future<void>` | 멤버 추가 |
| `fetchGroupsByUserId(userId)` | `Future<List<GroupDto>>` | 사용자의 모든 그룹 조회 |
| `watchGroupsByUserId(userId)` | `Stream<List<GroupDto>>` | 사용자의 모든 그룹 감시 |
| `updateMemberNickname(groupCode, userId, nickname)` | `Future<void>` | 멤버 닉네임 변경 |
| `updateMemberNicknameInGroups(groupCodes, userId, nickname)` | `Future<void>` | 여러 그룹에서 멤버 닉네임 변경 |

---

## SubscriptionLocalDataSource

**파일**: `lib/data/datasource/subscription_local_datasource.dart`
**저장소**: Drift (`user_subscriptions` 테이블)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<SubscriptionDto>>` | 모든 구독 조회 |
| `getById(id)` | `Future<SubscriptionDto?>` | ID로 구독 조회 |
| `insert(dto)` | `Future<void>` | 구독 삽입 |
| `update(dto)` | `Future<void>` | 구독 수정 |
| `delete(id)` | `Future<void>` | 구독 삭제 |
| `deleteByGroupCode(groupCode)` | `Future<void>` | 그룹별 구독 삭제 |
| `watchAll()` | `Stream<List<SubscriptionDto>>` | 모든 구독 감시 |
| `deleteAll()` | `Future<void>` | 모든 구독 삭제 |

---

## SubscriptionRemoteDataSource

**파일**: `lib/data/datasource/subscription_remote_datasource.dart`
**저장소**: Firebase Firestore (`groups/{groupCode}/subscriptions` 서브컬렉션)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `saveSubscription(dto)` | `Future<void>` | 구독 저장 |
| `fetchSubscription(groupCode, subscriptionId)` | `Future<SubscriptionDto?>` | 단일 구독 조회 |
| `fetchSubscriptions(groupCode)` | `Future<List<SubscriptionDto>>` | 그룹 구독 목록 조회 |
| `watchSubscriptions(groupCode)` | `Stream<List<SubscriptionDto>>` | 그룹 구독 목록 감시 |
| `deleteSubscription(groupCode, subscriptionId)` | `Future<void>` | 구독 삭제 |

---

## SettingsLocalDataSource

**파일**: `lib/data/datasource/settings_local_datasource.dart`
**저장소**: SharedPreferences

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getThemeMode()` | `Future<String?>` | 테마 모드 조회 |
| `setThemeMode(mode)` | `Future<void>` | 테마 모드 저장 |
| `getDefaultCurrency()` | `Future<String?>` | 기본 통화 조회 |
| `setDefaultCurrency(currencyCode)` | `Future<void>` | 기본 통화 저장 |
| `isNotificationEnabled()` | `Future<bool?>` | 알림 활성화 여부 조회 |
| `setNotificationEnabled(enabled)` | `Future<void>` | 알림 활성화 설정 |
| `getLastSelectedGroupCode()` | `Future<String?>` | 마지막 선택 그룹 코드 조회 |
| `setLastSelectedGroupCode(code)` | `Future<void>` | 마지막 선택 그룹 코드 저장 |

---

## OnboardingLocalDataSource

**파일**: `lib/data/datasource/onboarding_local_datasource.dart`
**저장소**: SharedPreferences

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `isOnboardingCompleted()` | `Future<bool>` | 온보딩 완료 여부 |
| `setOnboardingCompleted(completed)` | `Future<void>` | 온보딩 완료 설정 |
| `getOnboardingType()` | `Future<String?>` | 온보딩 타입 조회 |
| `setOnboardingType(type)` | `Future<void>` | 온보딩 타입 설정 |
| `isTutorialCompleted()` | `Future<bool>` | 튜토리얼 완료 여부 |
| `setTutorialCompleted(completed)` | `Future<void>` | 튜토리얼 완료 설정 |
| `isSetupCompleted()` | `Future<bool>` | 초기 설정 완료 여부 |
| `setSetupCompleted(completed)` | `Future<void>` | 초기 설정 완료 설정 |

---

## PendingChangeLocalDataSource

**파일**: `lib/data/datasource/pending_change_local_datasource.dart`
**저장소**: Drift (`pending_changes` 테이블)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getAll()` | `Future<List<PendingChangeDto>>` | 모든 대기 변경 조회 |
| `getByEntityId(entityId)` | `Future<PendingChangeDto?>` | 엔티티 ID로 조회 |
| `upsert(dto)` | `Future<void>` | 대기 변경 저장/갱신 |
| `delete(entityId)` | `Future<void>` | 대기 변경 삭제 |
| `deleteAll()` | `Future<void>` | 모든 대기 변경 삭제 |
| `saveGroupChange(dto, action, entityId)` | `Future<void>` | 그룹 변경 저장 |
| `getGroupChanges()` | `Future<List<(PendingChangeDto, GroupDto?)>>` | 그룹 변경 목록 |
| `saveSubscriptionChange(dto, action, entityId)` | `Future<void>` | 구독 변경 저장 |
| `getSubscriptionChanges()` | `Future<List<(PendingChangeDto, SubscriptionDto?)>>` | 구독 변경 목록 |

---

## PresetLocalDataSource

**파일**: `lib/data/datasource/preset_local_datasource.dart`
**저장소**: Drift (`preset_cache` 테이블), SharedPreferences (버전)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getLocalVersion()` | `Future<int?>` | 캐시된 프리셋 버전 조회 |
| `saveLocalVersion(version)` | `Future<void>` | 프리셋 버전 저장 |
| `getAll()` | `Future<List<PresetCacheData>>` | 캐시된 프리셋 조회 |
| `cachePresets(presets)` | `Future<void>` | 프리셋 캐싱 |
| `clear()` | `Future<void>` | 캐시 삭제 |

---

## PresetRemoteDataSource

**파일**: `lib/data/datasource/preset_remote_datasource.dart`
**저장소**: Firebase Realtime Database (`presets_v2`, `version_v2`)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `fetchPresets()` | `Future<Map<String, dynamic>?>` | 원격 프리셋 조회 |
| `fetchVersion()` | `Future<int?>` | 원격 프리셋 버전 조회 |

---

## ExchangeRateLocalDataSource

**파일**: `lib/data/datasource/exchange_rate_local_datasource.dart`
**저장소**: Drift (`fx_rates_daily` 테이블)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `getByDate(dateKey)` | `Future<ExchangeRateDto?>` | 날짜별 환율 조회 |
| `save(dateKey, dto, source)` | `Future<void>` | 환율 저장 |

---

## ExchangeRateRemoteDataSource

**파일**: `lib/data/datasource/exchange_rate_remote_datasource.dart`
**저장소**: Firebase Realtime Database (`exchange_rates`)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `fetchExchangeRates()` | `Future<ExchangeRateDto?>` | 원격 환율 조회 |

---

## FcmTokenRemoteDataSource

**파일**: `lib/data/datasource/fcm_token_remote_datasource.dart`
**저장소**: Firebase Firestore (`users` 컬렉션)

| 메서드 | 반환 타입 | 설명 |
|--------|----------|------|
| `saveToken({userId, token})` | `Future<void>` | FCM 토큰 저장 |
| `deleteToken({userId, token})` | `Future<void>` | FCM 토큰 삭제 |
| `saveUserGroup({userId, groupCode})` | `Future<void>` | 사용자 그룹 추가 |
| `removeUserGroup({userId, groupCode})` | `Future<void>` | 사용자 그룹 제거 |

---

## 저장소별 요약

### SharedPreferences (Key-Value)

| DataSource | 키 | 용도 |
|------------|-----|------|
| UserLocalDataSource | `user_nickname` | 닉네임 |
| UserLocalDataSource | `local_user_id` | 로컬 사용자 ID |
| SettingsLocalDataSource | `theme_mode` | 테마 모드 |
| SettingsLocalDataSource | `default_currency` | 기본 통화 |
| SettingsLocalDataSource | `notification_enabled` | 알림 활성화 |
| SettingsLocalDataSource | `last_selected_group_code` | 마지막 선택 그룹 |
| OnboardingLocalDataSource | `onboarding_completed` | 온보딩 완료 |
| OnboardingLocalDataSource | `onboarding_type` | 온보딩 타입 |
| OnboardingLocalDataSource | `coach_mark_completed` | 튜토리얼 완료 |
| OnboardingLocalDataSource | `setup_completed` | 초기 설정 완료 |
| PresetLocalDataSource | `preset_version` | 프리셋 버전 |

### Drift (SQLite)

| 테이블 | DataSource | 용도 |
|--------|------------|------|
| `subscription_groups` | GroupLocalDataSource | 그룹 정보 |
| `user_subscriptions` | SubscriptionLocalDataSource | 구독 정보 |
| `pending_changes` | PendingChangeLocalDataSource | 오프라인 변경 |
| `preset_cache` | PresetLocalDataSource | 프리셋 캐시 |
| `fx_rates_daily` | ExchangeRateLocalDataSource | 환율 캐시 |

### Firebase Firestore

| 컬렉션 | DataSource | 용도 |
|--------|------------|------|
| `users` | UserRemoteDataSource, FcmTokenRemoteDataSource | 사용자 정보 |
| `groups` | GroupRemoteDataSource | 그룹 정보 |
| `groups/{code}/subscriptions` | SubscriptionRemoteDataSource | 구독 정보 |

### Firebase Realtime Database

| 경로 | DataSource | 용도 |
|------|------------|------|
| `presets_v2` | PresetRemoteDataSource | 프리셋 데이터 |
| `version_v2` | PresetRemoteDataSource | 프리셋 버전 |
| `exchange_rates` | ExchangeRateRemoteDataSource | 환율 정보 |
