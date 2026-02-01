import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:subby/presentation/home/home_screen.dart';
import 'package:subby/presentation/onboarding/onboarding_screen.dart';
import 'package:subby/presentation/settings/settings_screen.dart';
import 'package:subby/presentation/subscription/subscription_add_screen.dart';
import 'package:subby/presentation/subscription/subscription_detail_screen.dart';
import 'package:subby/presentation/subscription/subscription_edit_screen.dart';
import 'package:subby/presentation/webview/webview_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const onboarding = '/onboarding';
  static const settings = '/settings';
  static const subscriptionAdd = '/subscription/add';
  static const subscriptionDetail = '/subscription/:id';
  static const subscriptionEdit = 'edit';
  static const webview = '/webview';

  static String subscriptionDetailPath(String id) => '/subscription/$id';
  static String subscriptionEditPath(String id) => '/subscription/$id/edit';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.webview,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        return WebViewScreen(
          title: extra['title']!,
          url: extra['url']!,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.subscriptionAdd,
      builder: (context, state) => const SubscriptionAddScreen(),
    ),
    GoRoute(
      path: AppRoutes.subscriptionDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SubscriptionDetailScreen(subscriptionId: id);
      },
      routes: [
        GoRoute(
          path: AppRoutes.subscriptionEdit,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return SubscriptionEditScreen(subscriptionId: id);
          },
        ),
      ],
    ),
  ],
);
