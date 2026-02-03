import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/core/di/data/service_providers.dart';
import 'package:subby/core/utils/currency_converter.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/exchange_rate.dart';
import 'package:subby/domain/model/currency.dart';
import 'package:subby/presentation/common/providers/conflict_state_provider.dart';

final authStateProvider = StreamProvider<String?>((ref) {
  final watchAuthState = ref.watch(watchAuthStateUseCaseProvider);

  return watchAuthState();
});

/// 현재 사용자가 익명인지 여부를 실시간으로 감지
final isAnonymousStateProvider = StreamProvider<bool>((ref) {
  final watchIsAnonymous = ref.watch(watchIsAnonymousUseCaseProvider);
  return watchIsAnonymous();
});

/// 현재 사용자 닉네임
final currentNicknameStateProvider = FutureProvider<String?>((ref) async {
  final getCurrentNickname = ref.watch(getCurrentNicknameUseCaseProvider);
  return getCurrentNickname();
});

final onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
        OnboardingCompletedNotifier.new);

class OnboardingCompletedNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final checkOnboardingCompleted =
        ref.read(checkOnboardingCompletedUseCaseProvider);
    state = await checkOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    final completeOnboarding = ref.read(completeOnboardingUseCaseProvider);
    await completeOnboarding();
    state = true;
  }
}

final tutorialCompletedProvider =
    NotifierProvider<TutorialCompletedNotifier, bool>(
        TutorialCompletedNotifier.new);

class TutorialCompletedNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final checkTutorialCompleted =
        ref.read(checkTutorialCompletedUseCaseProvider);
    state = await checkTutorialCompleted();
  }

  Future<void> completeTutorial() async {
    final completeTutorial = ref.read(completeTutorialUseCaseProvider);
    await completeTutorial();
    state = true;
  }
}

final setupCompletedProvider =
    NotifierProvider<SetupCompletedNotifier, bool>(SetupCompletedNotifier.new);

class SetupCompletedNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final checkSetupCompleted = ref.read(checkSetupCompletedUseCaseProvider);
    state = await checkSetupCompleted();
  }

  Future<void> completeSetup() async {
    final completeSetup = ref.read(completeSetupUseCaseProvider);
    await completeSetup();
    state = true;
  }
}

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.valueOrNull;
});

final appInitializedProvider = FutureProvider<void>((ref) async {
  // 비어있음 - onboardingCompletedProvider가 SharedPreferences 체크
});

/// 마지막 선택 그룹 코드 Provider (영구 저장)
final lastSelectedGroupCodeProvider =
    NotifierProvider<LastSelectedGroupCodeNotifier, String?>(
        LastSelectedGroupCodeNotifier.new);

class LastSelectedGroupCodeNotifier extends Notifier<String?> {
  @override
  String? build() {
    _load();
    return null;
  }

  Future<void> _load() async {
    final getLastSelectedGroupCode =
        ref.read(getLastSelectedGroupCodeUseCaseProvider);
    state = await getLastSelectedGroupCode();
  }

  Future<void> setGroupCode(String? code) async {
    state = code;
    final saveLastSelectedGroupCode =
        ref.read(saveLastSelectedGroupCodeUseCaseProvider);
    await saveLastSelectedGroupCode(code);
  }
}

/// 현재 선택된 그룹 코드 (런타임 상태)
final currentGroupCodeProvider = StateProvider<String?>((ref) => null);

final currentGroupProvider = StreamProvider((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);

  if (groupCode == null) return const Stream.empty();

  final watchGroupByCode = ref.watch(watchGroupByCodeUseCaseProvider);

  return watchGroupByCode(groupCode);
});

final realtimeSyncProvider = Provider<void>((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);

  if (groupCode == null) return;

  final syncService = ref.read(realtimeSyncServiceProvider);
  syncService.startSync(groupCode);
});

final pendingSyncTriggerProvider = StateProvider<int>((ref) => 0);

final pendingSyncProvider = Provider<void>((ref) {
  final processPendingChanges = ref.read(processPendingChangesUseCaseProvider);
  final conflictNotifier = ref.read(conflictStateProvider.notifier);

  Future<ConflictResolution?> onConflict(conflict) async {
    final completer = Completer<ConflictResolution>();

    conflictNotifier.setConflict(conflict, (resolution) {
      completer.complete(resolution);
    });

    return completer.future;
  }

  // 데이터 변동 시 트리거
  ref.watch(pendingSyncTriggerProvider);

  // 앱 시작 시 1회 실행
  processPendingChanges(onConflict: onConflict);

  // 네트워크 상태 변경 감지
  bool wasOffline = false;
  final subscription = Connectivity().onConnectivityChanged.listen((result) {
    final isOffline = result.contains(ConnectivityResult.none);

    if (wasOffline && !isOffline) {
      print('[Conflict] Network restored, triggering pending sync');
      processPendingChanges(onConflict: onConflict);
    }

    wasOffline = isOffline;
  });

  ref.onDispose(() {
    subscription.cancel();
  });
});

final exchangeRateProvider = FutureProvider<ExchangeRate?>((ref) async {
  final getExchangeRate = ref.watch(getExchangeRateUseCaseProvider);

  return getExchangeRate();
});

final currencyConverterProvider = Provider<CurrencyConverter?>((ref) {
  final exchangeRate = ref.watch(exchangeRateProvider).valueOrNull;

  if (exchangeRate == null) return null;

  return CurrencyConverter(exchangeRate);
});

/// FCM 초기화 Provider
final fcmInitializedProvider = FutureProvider<void>((ref) async {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) return;

  final fcmService = ref.read(fcmServiceProvider);

  await fcmService.initialize(userId);
});

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final getThemeMode = ref.read(getThemeModeUseCaseProvider);
    state = await getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final setThemeModeUseCase = ref.read(setThemeModeUseCaseProvider);
    await setThemeModeUseCase(mode);
    state = mode;
  }
}

String themeModeToLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return '시스템 설정';
    case ThemeMode.light:
      return '라이트';
    case ThemeMode.dark:
      return '다크';
  }
}

final defaultCurrencyProvider =
    NotifierProvider<DefaultCurrencyNotifier, Currency>(
        DefaultCurrencyNotifier.new);

class DefaultCurrencyNotifier extends Notifier<Currency> {
  @override
  Currency build() {
    _load();
    return Currency.KRW;
  }

  Future<void> _load() async {
    final getDefaultCurrency = ref.read(getDefaultCurrencyUseCaseProvider);
    state = await getDefaultCurrency();
  }

  Future<void> setCurrency(Currency currency) async {
    final setDefaultCurrency = ref.read(setDefaultCurrencyUseCaseProvider);
    await setDefaultCurrency(currency);
    state = currency;
  }
}

String currencyToLabel(Currency currency) {
  return '${currency.code}  ${currency.name}(${currency.symbol})';
}

final notificationEnabledProvider =
    NotifierProvider<NotificationEnabledNotifier, bool>(
        NotificationEnabledNotifier.new);

class NotificationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final checkNotificationEnabled =
        ref.read(checkNotificationEnabledUseCaseProvider);
    state = await checkNotificationEnabled();
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final setNotificationEnabledUseCase =
        ref.read(setNotificationEnabledUseCaseProvider);
    await setNotificationEnabledUseCase(enabled);
    state = enabled;

    final fcmService = ref.read(fcmServiceProvider);
    final userId = ref.read(currentUserIdProvider);

    if (userId != null) {
      if (enabled) {
        await fcmService.registerToken(userId);
      } else {
        await fcmService.deleteToken();
      }
    }
  }
}
