import 'package:flutter/material.dart';
import 'package:bongpal/core/theme/app_theme.dart';
import 'package:bongpal/data/database/database.dart';
import 'package:bongpal/data/repository/subscription_repository_impl.dart';
import 'package:bongpal/domain/usecase/add_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/delete_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/get_subscription_by_id_usecase.dart';
import 'package:bongpal/domain/usecase/update_subscription_usecase.dart';
import 'package:bongpal/domain/usecase/watch_subscriptions_usecase.dart';
import 'package:bongpal/presentation/home/home_screen.dart';

void main() {
  final db = AppDatabase();
  final repository = SubscriptionRepositoryImpl(db);

  final watchSubscriptions = WatchSubscriptionsUseCase(repository);
  final addSubscription = AddSubscriptionUseCase(repository);
  final getSubscriptionById = GetSubscriptionByIdUseCase(repository);
  final updateSubscription = UpdateSubscriptionUseCase(repository);
  final deleteSubscription = DeleteSubscriptionUseCase(repository);

  runApp(SubbyApp(
    watchSubscriptions: watchSubscriptions,
    addSubscription: addSubscription,
    getSubscriptionById: getSubscriptionById,
    updateSubscription: updateSubscription,
    deleteSubscription: deleteSubscription,
  ));
}

class SubbyApp extends StatelessWidget {
  final WatchSubscriptionsUseCase watchSubscriptions;
  final AddSubscriptionUseCase addSubscription;
  final GetSubscriptionByIdUseCase getSubscriptionById;
  final UpdateSubscriptionUseCase updateSubscription;
  final DeleteSubscriptionUseCase deleteSubscription;

  const SubbyApp({
    super.key,
    required this.watchSubscriptions,
    required this.addSubscription,
    required this.getSubscriptionById,
    required this.updateSubscription,
    required this.deleteSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subby',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: HomeScreen(
        watchSubscriptions: watchSubscriptions,
        addSubscription: addSubscription,
        getSubscriptionById: getSubscriptionById,
        updateSubscription: updateSubscription,
        deleteSubscription: deleteSubscription,
      ),
    );
  }
}
