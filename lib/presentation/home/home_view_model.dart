import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';

class HomeState {
  final List<UserSubscription> subscriptions;
  final List<SubscriptionGroup> groups;
  final String? selectedGroupCode;
  final bool isLoading;
  final double totalKrw;

  const HomeState({
    this.subscriptions = const [],
    this.groups = const [],
    this.selectedGroupCode,
    this.isLoading = true,
    this.totalKrw = 0,
  });

  String get currentGroupName {
    if (selectedGroupCode == null) return '내 구독';
    final group = groups.where((g) => g.code == selectedGroupCode).firstOrNull;
    return group?.effectiveName ?? '내 구독';
  }

  HomeState copyWith({
    List<UserSubscription>? subscriptions,
    List<SubscriptionGroup>? groups,
    String? selectedGroupCode,
    bool clearSelectedGroup = false,
    bool? isLoading,
    double? totalKrw,
  }) {
    return HomeState(
      subscriptions: subscriptions ?? this.subscriptions,
      groups: groups ?? this.groups,
      selectedGroupCode: clearSelectedGroup ? null : (selectedGroupCode ?? this.selectedGroupCode),
      isLoading: isLoading ?? this.isLoading,
      totalKrw: totalKrw ?? this.totalKrw,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    _watchGroups();
    _watchSubscriptions();
    return const HomeState();
  }

  void _watchGroups() {
    final groupRepository = ref.read(groupRepositoryProvider);
    groupRepository.watchAll().listen((groups) {
      final newGroupCode = state.selectedGroupCode ?? groups.firstOrNull?.code;

      state = state.copyWith(
        groups: groups,
        selectedGroupCode: newGroupCode,
      );

      // currentGroupCodeProvider 동기화
      if (newGroupCode != null) {
        ref.read(currentGroupCodeProvider.notifier).state = newGroupCode;
      }
    });
  }

  void _watchSubscriptions() {
    final watchUseCase = ref.read(watchSubscriptionsUseCaseProvider);
    watchUseCase().listen((subscriptions) {
      final filtered = _filterByGroup(subscriptions);
      final total = _calculateTotal(filtered);
      state = state.copyWith(
        subscriptions: filtered,
        isLoading: false,
        totalKrw: total,
      );
    });
  }

  List<UserSubscription> _filterByGroup(List<UserSubscription> subscriptions) {
    final groupCode = state.selectedGroupCode;
    if (groupCode == null) return subscriptions;
    return subscriptions.where((s) => s.groupCode == groupCode).toList();
  }

  void selectGroup(String? groupCode) {
    state = state.copyWith(
      selectedGroupCode: groupCode,
      clearSelectedGroup: groupCode == null,
    );

    // currentGroupCodeProvider 동기화
    ref.read(currentGroupCodeProvider.notifier).state = groupCode;

    _watchSubscriptions();
  }

  double _calculateTotal(List<UserSubscription> subscriptions) {
    final exchangeRate = ref.read(exchangeRateProvider).valueOrNull;

    double total = 0;
    for (final sub in subscriptions) {
      if (sub.currency == 'KRW') {
        total += sub.amount;
      } else if (exchangeRate != null) {
        total += exchangeRate.convert(sub.amount, sub.currency, 'KRW');
      } else {
        // 환율 없으면 기본값 사용
        total += sub.amount * 1400;
      }
    }

    return total;
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
