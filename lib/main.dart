import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:subby/firebase_options.dart';
import 'package:subby/core/theme/app_theme.dart';
import 'package:subby/data/service/fcm_service.dart';
import 'package:subby/presentation/common/app_initialization_wrapper.dart';
import 'package:subby/presentation/common/widgets/conflict_listener.dart';
import 'package:subby/presentation/common/widgets/sync_notification_listener.dart';
import 'package:subby/presentation/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FCM 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: SubbyApp()));
}

class SubbyApp extends StatelessWidget {
  const SubbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subby',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      home: const AppInitializationWrapper(
        child: ConflictListener(
          child: SyncNotificationListener(
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
