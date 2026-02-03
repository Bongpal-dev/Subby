import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/domain/usecase_providers.dart';
import 'package:subby/core/util/invite_link_generator.dart';
import 'package:subby/presentation/common/group_actions.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';
import 'package:subby/presentation/common/providers/deep_link_provider.dart';

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
    extends ConsumerState<AppInitializationWrapper>
    with WidgetsBindingObserver {
  bool _initialLinkHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _restartSync();
    }
  }

  void _restartSync() {
    final groupCode = ref.read(currentGroupCodeProvider);

    if (groupCode == null) return;

    final restartSync = ref.read(restartSubscriptionSyncUseCaseProvider);
    restartSync(groupCode);
  }

  @override
  Widget build(BuildContext context) {
    // sync, 딥링크 활성화 (FCM은 온보딩 완료 후 HomeScreen에서 초기화)
    ref.watch(realtimeSyncProvider);
    ref.watch(pendingSyncProvider);

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
  }

  Future<void> _handleDeepLink(Uri uri) async {
    final groupCode = InviteLinkGenerator.parseGroupCode(uri);

    if (groupCode == null || !mounted) return;

    await joinGroupWithConfirmation(
      context: context,
      ref: ref,
      groupCode: groupCode,
    );
  }
}
