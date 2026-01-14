import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:subby/data/datasource/fcm_token_remote_datasource.dart';

/// 백그라운드 메시지 핸들러 (top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드에서 알림 처리
  // Firebase가 자동으로 시스템 알림을 표시하므로 별도 처리 불필요
}

class FcmService {
  final FirebaseMessaging _messaging;
  final FcmTokenRemoteDataSource _tokenDataSource;
  final FlutterLocalNotificationsPlugin _localNotifications;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  String? _currentUserId;

  FcmService(this._tokenDataSource)
      : _messaging = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin();

  /// FCM 초기화
  Future<void> initialize(String userId) async {
    _currentUserId = userId;

    // 알림 권한 요청
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      return;
    }

    // 로컬 알림 초기화 (Android)
    await _initializeLocalNotifications();

    // FCM 토큰 가져오기 및 저장
    final token = await _messaging.getToken();

    if (token != null) {
      await _tokenDataSource.saveToken(userId: userId, token: token);
    }

    // 토큰 갱신 리스너
    _messaging.onTokenRefresh.listen((newToken) {
      if (_currentUserId != null) {
        _tokenDataSource.saveToken(userId: _currentUserId!, token: newToken);
      }
    });

    // 포그라운드 메시지 리스너 (앱이 열려있을 때)
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 백그라운드에서 알림 탭하여 앱 열었을 때
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // 앱이 종료된 상태에서 알림 탭하여 열었을 때
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // Android 알림 채널 생성
    const androidChannel = AndroidNotificationChannel(
      'subby_sync_channel',
      '구독 동기화 알림',
      description: '그룹 구독 변경 알림',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // 포그라운드에서는 스낵바로 처리하므로 여기서는 무시
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // 알림 탭 시 특정 화면으로 이동 (필요시 구현)
  }

  /// 토큰 삭제 (로그아웃 시)
  Future<void> deleteToken() async {
    if (_currentUserId == null) return;

    final token = await _messaging.getToken();

    if (token != null) {
      await _tokenDataSource.deleteToken(
        userId: _currentUserId!,
        token: token,
      );
    }
  }

  void dispose() {
    _foregroundSubscription?.cancel();
  }
}
