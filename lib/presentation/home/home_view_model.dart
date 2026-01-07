import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/model/subscription.dart';

class HomeState {
  final List<Subscription> subscriptions;
  final bool isLoading;
  final double totalKrw;

  const HomeState({
    this.subscriptions = const [],
    this.isLoading = true,
    this.totalKrw = 0,
  });

  HomeState copyWith({
    List<Subscription>? subscriptions,
    bool? isLoading,
    double? totalKrw,
  }) {
    return HomeState(
      subscriptions: subscriptions ?? this.subscriptions,
      isLoading: isLoading ?? this.isLoading,
      totalKrw: totalKrw ?? this.totalKrw,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    _watchSubscriptions();
    return const HomeState();
  }

  void _watchSubscriptions() {
    final watchUseCase = ref.read(watchSubscriptionsUseCaseProvider);
    watchUseCase().listen((subscriptions) {
      final total = _calculateTotal(subscriptions);
      state = state.copyWith(
        subscriptions: subscriptions,
        isLoading: false,
        totalKrw: total,
      );
    });
  }

  double _calculateTotal(List<Subscription> subscriptions) {
    double total = 0;
    for (final sub in subscriptions) {
      if (sub.currency == 'KRW') {
        total += sub.amount;
      } else {
        total += sub.amount * 1450; // TODO: 실제 환율 적용
      }
    }
    return total;
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
