import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subby/core/di/domain/repository_providers.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/core/di/data/service_providers.dart';
import 'package:subby/core/utils/currency_converter.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/exchange_rate.dart';
import 'package:subby/domain/model/currency.dart';
import 'package:subby/presentation/common/providers/conflict_state_provider.dart';

final authStateProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.valueOrNull;
});

final appInitializedProvider = FutureProvider<void>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  await authRepository.signInAnonymously();
});

final currentGroupCodeProvider = StateProvider<String?>((ref) => null);

final currentGroupProvider = StreamProvider((ref) {
  final groupCode = ref.watch(currentGroupCodeProvider);

  if (groupCode == null) return const Stream.empty();

  final groupRepository = ref.watch(groupRepositoryProvider);

  return groupRepository.watchByCode(groupCode);
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
  final repository = ref.watch(exchangeRateRepositoryProvider);

  return repository.getExchangeRate();
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

/// 테마 모드 Provider
const _themeModeKey = 'theme_mode';

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeModeKey);
    if (value != null) {
      state = _stringToThemeMode(value);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeModeToString(mode));
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
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

/// 기본 통화 Provider
const _defaultCurrencyKey = 'default_currency';

final defaultCurrencyProvider =
    NotifierProvider<DefaultCurrencyNotifier, Currency>(
        DefaultCurrencyNotifier.new);

class DefaultCurrencyNotifier extends Notifier<Currency> {
  @override
  Currency build() {
    _loadCurrency();
    return Currency.KRW;
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_defaultCurrencyKey);
    if (code != null) {
      final currency = Currency.fromCode(code);
      if (currency != null) {
        state = currency;
      }
    }
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultCurrencyKey, currency.code);
  }
}

String currencyToLabel(Currency currency) {
  return '${currency.code}  ${currency.name}(${currency.symbol})';
}

/// 알림 설정 Provider
const _notificationEnabledKey = 'notification_enabled';

final notificationEnabledProvider =
    NotifierProvider<NotificationEnabledNotifier, bool>(
        NotificationEnabledNotifier.new);

class NotificationEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadNotificationEnabled();
    return true; // 기본값: 알림 활성화
  }

  Future<void> _loadNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_notificationEnabledKey);
    if (value != null) {
      state = value;
    }
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);

    // FCM 토큰 등록/삭제로 서버 푸시 제어
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
