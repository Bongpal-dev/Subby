import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';

/// 앱 초기화 래퍼
/// 초기화 완료 전까지 로딩 화면 표시
class AppInitializationWrapper extends ConsumerWidget {
  final Widget child;

  const AppInitializationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInit = ref.watch(appInitializedProvider);

    return appInit.when(
      data: (_) => child,
      loading: () => const _LoadingScreen(),
      error: (error, stack) => _ErrorScreen(error: error),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('로딩 중...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends ConsumerWidget {
  final Object error;

  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('앱 초기화 실패'),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(appInitializedProvider);
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
