import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bongpal/firebase_options.dart';
import 'package:bongpal/core/theme/app_theme.dart';
import 'package:bongpal/data/database/database.dart';
import 'package:bongpal/data/datasource/preset_local_datasource.dart';
import 'package:bongpal/data/datasource/preset_remote_datasource.dart';
import 'package:bongpal/data/repository/preset_repository.dart';
import 'package:bongpal/data/repository/subscription_repository_impl.dart';
import 'package:bongpal/domain/usecase/add_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/get_presets_usecase.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/watch_subscriptions_usecase.dart';
import 'package:bongpal/presentation/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final db = AppDatabase();
  final subscriptionRepository = SubscriptionRepositoryImpl(db);
  final presetRepository = PresetRepositoryImpl(
    remoteDataSource: PresetRemoteDataSource(),
    localDataSource: PresetLocalDataSource(db),
  );

  final watchSubscriptions = WatchSubscriptionsUseCase(subscriptionRepository);
  final addSubscription = AddSubscriptionUseCase(subscriptionRepository);
  final getSubscriptionById = GetSubscriptionByIdUseCase(subscriptionRepository);
  final updateSubscription = UpdateSubscriptionUseCase(subscriptionRepository);
  final deleteSubscription = DeleteSubscriptionUseCase(subscriptionRepository);
  final getPresets = GetPresetsUseCase(presetRepository);

  runApp(SubbyApp(
    watchSubscriptions: watchSubscriptions,
    addSubscription: addSubscription,
    getSubscriptionById: getSubscriptionById,
    updateSubscription: updateSubscription,
    deleteSubscription: deleteSubscription,
    getPresets: getPresets,
  ));
}

class SubbyApp extends StatelessWidget {
  final WatchSubscriptionsUseCase watchSubscriptions;
  final AddSubscriptionUseCase addSubscription;
  final GetSubscriptionByIdUseCase getSubscriptionById;
  final UpdateSubscriptionUseCase updateSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;
  final GetPresetsUseCase getPresets;

  const SubbyApp({
    super.key,
    required this.watchSubscriptions,
    required this.addSubscription,
    required this.getSubscriptionById,
    required this.updateSubscription,
    required this.deleteSubscription,
    required this.getPresets,
  });

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
      home: HomeScreen(
        watchSubscriptions: watchSubscriptions,
        addSubscription: addSubscription,
        getSubscriptionById: getSubscriptionById,
        updateSubscription: updateSubscription,
        deleteSubscription: deleteSubscription,
        getPresets: getPresets,
      ),
    );
  }
}
