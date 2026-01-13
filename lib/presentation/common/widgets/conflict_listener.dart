import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/presentation/common/providers/conflict_state_provider.dart';
import 'package:subby/presentation/common/widgets/conflict_resolution_dialog.dart';

/// 충돌 상태를 감지하고 다이얼로그를 표시하는 위젯
class ConflictListener extends ConsumerStatefulWidget {
  final Widget child;

  const ConflictListener({super.key, required this.child});

  @override
  ConsumerState<ConflictListener> createState() => _ConflictListenerState();
}

class _ConflictListenerState extends ConsumerState<ConflictListener> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<ConflictState>(conflictStateProvider, (previous, next) {
      if (next.hasConflict && !_isDialogShowing) {
        _showConflictDialog(next);
      }
    });

    return widget.child;
  }

  Future<void> _showConflictDialog(ConflictState state) async {
    if (state.conflict == null) return;

    _isDialogShowing = true;

    final resolution = await showConflictResolutionDialog(
      context: context,
      conflict: state.conflict!,
    );

    _isDialogShowing = false;

    if (resolution != null) {
      ref.read(conflictStateProvider.notifier).resolve(resolution);
    } else {
      ref.read(conflictStateProvider.notifier).clear();
    }
  }
}
