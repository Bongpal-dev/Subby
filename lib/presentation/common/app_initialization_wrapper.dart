import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/core/util/invite_link_generator.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/providers/deep_link_provider.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';

class AppInitializationWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const AppInitializationWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppInitializationWrapper> createState() =>
      _AppInitializationWrapperState();
}

class _AppInitializationWrapperState
    extends ConsumerState<AppInitializationWrapper> {
  bool _initialLinkHandled = false;

  @override
  Widget build(BuildContext context) {
    final appInit = ref.watch(appInitializedProvider);

    return appInit.when(
      data: (_) {
        ref.watch(realtimeSyncProvider);
        ref.watch(networkSyncProvider);

        if (!_initialLinkHandled) {
          _initialLinkHandled = true;
          ref.listen(initialDeepLinkProvider, (prev, next) {
            next.whenData((uri) {
              if (uri != null) _handleDeepLink(uri);
            });
          });
        }

        ref.listen(deepLinkStreamProvider, (prev, next) {
          next.whenData((uri) => _handleDeepLink(uri));
        });

        return widget.child;
      },
      loading: () => const _LoadingScreen(),
      error: (error, stack) => _ErrorScreen(error: error),
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    final groupCode = InviteLinkGenerator.parseGroupCode(uri);

    if (groupCode == null || !mounted) return;

    // 참여 확인 다이얼로그 표시
    showJoinGroupDialog(
      context: context,
      groupCode: groupCode,
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
