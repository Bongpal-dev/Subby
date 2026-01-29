import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/model/subscription_group.dart';
import 'package:subby/domain/model/user_subscription.dart';
import 'package:subby/presentation/common/providers/app_state_providers.dart';

class HomeState {
  final List<UserSubscription> subscriptions;
  final List<UserSubscription> filteredSubscriptions;
  final List<SubscriptionGroup> groups;
  final String? selectedGroupCode;
  final String? selectedCategory; // null이면 '전체'
  final bool isLoading;
  final double totalKrw;

  const HomeState({
    this.subscriptions = const [],
    this.filteredSubscriptions = const [],
    this.groups = const [],
    this.selectedGroupCode,
    this.selectedCategory,
    this.isLoading = true,
    this.totalKrw = 0,
  });

  String get currentGroupName {
    if (selectedGroupCode == null) return '내 구독';
    final group = groups.where((g) => g.code == selectedGroupCode).firstOrNull;
    return group?.effectiveName ?? '내 구독';
  }

  /// 구독 목록에서 고유한 카테고리 목록 추출
  List<String> get categories {
    final cats = subscriptions
        .map((s) => s.category)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  HomeState copyWith({
    List<UserSubscription>? subscriptions,
    List<UserSubscription>? filteredSubscriptions,
    List<SubscriptionGroup>? groups,
    String? selectedGroupCode,
    bool clearSelectedGroup = false,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    bool? isLoading,
    double? totalKrw,
  }) {
    return HomeState(
      subscriptions: subscriptions ?? this.subscriptions,
      filteredSubscriptions: filteredSubscriptions ?? this.filteredSubscriptions,
      groups: groups ?? this.groups,
      selectedGroupCode: clearSelectedGroup ? null : (selectedGroupCode ?? this.selectedGroupCode),
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
      totalKrw: totalKrw ?? this.totalKrw,
    );
  }
}

class HomeViewModel extends Notifier<HomeState> {
  StreamSubscription<List<SubscriptionGroup>>? _remoteGroupsSubscription;

  @override
  HomeState build() {
    _watchGroups();
    _watchSubscriptions();
    _watchRemoteGroups();
    return const HomeState();
  }

  void _watchGroups() {
    final groupRepository = ref.read(groupRepositoryProvider);
    groupRepository.watchAll().listen((groups) {
      // 선택된 그룹이 삭제되었으면 다른 그룹으로 전환
      final selectedExists = groups.any((g) => g.code == state.selectedGroupCode);
      final newGroupCode = selectedExists ? state.selectedGroupCode : groups.firstOrNull?.code;

      state = state.copyWith(
        groups: groups,
        selectedGroupCode: newGroupCode,
        clearSelectedGroup: newGroupCode == null,
        isLoading: false,
      );

      // currentGroupCodeProvider 동기화
      if (newGroupCode != null) {
        ref.read(currentGroupCodeProvider.notifier).state = newGroupCode;
      }
    });
  }

  /// Firestore 실시간 감시 - 그룹 멤버 변경 등 반영
  void _watchRemoteGroups() {
    final authDataSource = ref.read(firebaseAuthDataSourceProvider);
    final userId = authDataSource.currentUserId;
    if (userId == null) return;

    final groupRepository = ref.read(groupRepositoryProvider);

    _remoteGroupsSubscription?.cancel();
    _remoteGroupsSubscription = groupRepository
        .watchRemoteGroupsByUserId(userId)
        .listen((remoteGroups) async {
      // 원격 그룹 변경 시 로컬 DB 업데이트
      final localGroups = await groupRepository.getAll();

      for (final remoteGroup in remoteGroups) {
        final localGroup = localGroups.where((g) => g.code == remoteGroup.code).firstOrNull;

        if (localGroup != null) {
          // displayName은 로컬 값 유지, 나머지는 원격 값으로 업데이트
          final updatedGroup = remoteGroup.copyWith(
            displayName: localGroup.displayName,
          );
          await groupRepository.update(updatedGroup);
        }
      }
    });
  }

  void _watchSubscriptions() {
    final watchUseCase = ref.read(watchSubscriptionsUseCaseProvider);
    watchUseCase().listen((subscriptions) {
      final groupFiltered = _filterByGroup(subscriptions);
      final categoryFiltered = _filterByCategory(groupFiltered);
      final total = _calculateTotal(categoryFiltered);
      state = state.copyWith(
        subscriptions: groupFiltered,
        filteredSubscriptions: categoryFiltered,
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

  List<UserSubscription> _filterByCategory(List<UserSubscription> subscriptions) {
    final category = state.selectedCategory;
    if (category == null) return subscriptions;
    return subscriptions.where((s) => s.category == category).toList();
  }

  void selectGroup(String? groupCode) {
    state = state.copyWith(
      selectedGroupCode: groupCode,
      clearSelectedGroup: groupCode == null,
      clearSelectedCategory: true, // 그룹 변경 시 카테고리 필터 초기화
    );

    // currentGroupCodeProvider 동기화
    ref.read(currentGroupCodeProvider.notifier).state = groupCode;

    _watchSubscriptions();
  }

  void selectCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
    );
    _applyFilters();
  }

  void _applyFilters() {
    final categoryFiltered = _filterByCategory(state.subscriptions);
    final total = _calculateTotal(categoryFiltered);
    state = state.copyWith(
      filteredSubscriptions: categoryFiltered,
      totalKrw: total,
    );
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

  Future<bool> deleteSubscription(String subscriptionId) async {
    try {
      final deleteUseCase = ref.read(deleteSubscriptionUseCaseProvider);
      await deleteUseCase(subscriptionId);
      ref.read(pendingSyncTriggerProvider.notifier).state++;
      return true;
    } catch (e) {
      return false;
    }
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
