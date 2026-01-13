import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/domain/model/conflict_resolution.dart';
import 'package:subby/domain/model/subscription_conflict.dart';

class ConflictState {
  final SubscriptionConflict? conflict;
  final void Function(ConflictResolution)? onResolved;

  const ConflictState({this.conflict, this.onResolved});

  bool get hasConflict => conflict != null;
}

class ConflictStateNotifier extends StateNotifier<ConflictState> {
  ConflictStateNotifier() : super(const ConflictState());

  void setConflict(
    SubscriptionConflict conflict,
    void Function(ConflictResolution) onResolved,
  ) {
    state = ConflictState(conflict: conflict, onResolved: onResolved);
  }

  void resolve(ConflictResolution resolution) {
    state.onResolved?.call(resolution);
    state = const ConflictState();
  }

  void clear() {
    state = const ConflictState();
  }
}

final conflictStateProvider =
    StateNotifierProvider<ConflictStateNotifier, ConflictState>((ref) {
  return ConflictStateNotifier();
});
