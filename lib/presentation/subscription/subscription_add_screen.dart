import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/subby_app_bar.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';

class SubscriptionAddScreen extends ConsumerStatefulWidget {
  const SubscriptionAddScreen({super.key});

  @override
  ConsumerState<SubscriptionAddScreen> createState() => _SubscriptionAddScreenState();
}

class _SubscriptionAddScreenState extends ConsumerState<SubscriptionAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _memoController = TextEditingController();
  final _amountController = TextEditingController(text: '0');
  final _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionAddViewModelProvider);
    final vm = ref.read(subscriptionAddViewModelProvider.notifier);

    return Scaffold(
      appBar: const SubbyAppBar(title: '구독 추가'),
      body: state.isServiceSelected
          ? _buildForm(state, vm)
          : _ServicePickerContent(
              state: state,
              vm: vm,
            ),
    );
  }

  Widget _buildForm(SubscriptionAddState state, SubscriptionAddViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);

    // Sync controllers with state
    if (_nameController.text != state.name) {
      _nameController.text = state.name;
    }
    if (_memoController.text != state.memo) {
      _memoController.text = state.memo;
    }

    // Sync amount controller (only when not focused)
    if (!_amountFocusNode.hasFocus) {
      final amountText = state.currency == 'KRW'
          ? state.amount.toInt().toString()
          : state.amount.toString();
      if (_amountController.text != amountText) {
        _amountController.text = amountText;
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.lg),
              children: [
                // 선택된 서비스 표시
                AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      state.selectedPreset != null ? Icons.check_circle : Icons.edit,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      state.selectedPreset?.displayName(locale) ?? '직접 입력',
                      style: AppTypography.titleLarge,
                    ),
                    subtitle: state.selectedPreset != null
                        ? Text(_categoryLabel(state.selectedPreset!.category))
                        : const Text('서비스 정보를 직접 입력합니다'),
                    trailing: TextButton(
                      onPressed: () => vm.resetSelection(),
                      child: const Text('변경'),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),

                // 직접 입력인 경우에만 서비스명 입력 가능
                if (state.selectedPreset == null) ...[
                  AppCard(
                    child: AppTextField(
                      label: '서비스명',
                      hint: '예: Netflix, Spotify',
                      controller: _nameController,
                      onChanged: vm.setName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '서비스명을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],

                // 요금제가 있는 프리셋인 경우: 요금제 + 결제금액 통합 카드
                if (state.selectedPreset != null && state.selectedPreset!.hasPlans) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 요금제 선택 (가로 스크롤, 금액 없이 항목명만)
                        Text('요금제', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: state.selectedPreset!.plans.map((plan) => Padding(
                              padding: EdgeInsets.only(right: AppSpacing.sm),
                              child: ChoiceChip(
                                label: Text(plan.displayName(locale)),
                                selected: state.selectedPlan == plan,
                                onSelected: (_) => vm.selectPlan(plan),
                                selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: state.selectedPlan == plan
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            )).toList(),
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        // 결제 금액
                        Text('결제 금액', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.sm),
                        _buildAmountTextField(state, vm, colorScheme),
                      ],
                    ),
                  ),
                ] else ...[
                  // 요금제가 없는 경우: 기존 통화 + 금액 카드
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('통화', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.sm),
                        SegmentedSelector(
                          options: const ['KRW', 'USD'],
                          labels: const ['\u20a9 원화', '\$ 달러'],
                          selected: state.currency,
                          onChanged: vm.setCurrency,
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Text('금액', style: Theme.of(context).textTheme.labelSmall),
                        SizedBox(height: AppSpacing.md),
                        _buildAmountTextField(state, vm, colorScheme),
                        SizedBox(height: AppSpacing.md),
                        AmountAdder(
                          currency: state.currency,
                          onAdd: (step) => vm.setAmount(state.amount + step),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.md),

                // 결제일 + 결제 주기 그룹
                AppCard(
                  child: Row(
                    children: [
                      // 결제일
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('결제일', style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(height: AppSpacing.sm),
                            GestureDetector(
                              onTap: () async {
                              final result = await showDayPickerDialog(
                                context: context,
                                initialDay: state.billingDay,
                              );

                              if (result != null) {
                                vm.setBillingDay(result);
                              }
                            },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '매월 ${state.billingDay}일',
                                    style: AppTypography.titleLarge.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      // 결제 주기
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('결제 주기', style: Theme.of(context).textTheme.labelSmall),
                            SizedBox(height: AppSpacing.sm),
                            SegmentedSelector(
                              options: const ['MONTHLY', 'YEARLY'],
                              labels: const ['매월', '매년'],
                              selected: state.period,
                              onChanged: vm.setPeriod,
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md),

                // 메모
                AppCard(
                  child: AppTextField(
                    label: '메모 (선택)',
                    hint: '메모를 입력하세요',
                    controller: _memoController,
                    onChanged: vm.setMemo,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // 저장 버튼 - 하단 고정
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: SafeArea(
              child: FilledButton(
                onPressed: state.isSaving ? null : () => _onSave(vm),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('저장', style: AppTypography.titleLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountTextField(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    ColorScheme colorScheme,
  ) {
    final prefix = state.currency == 'KRW' ? '\u20a9 ' : '\$ ';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _amountController,
        focusNode: _amountFocusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: AppTypography.displaySmall.copyWith(
          color: colorScheme.primary,
        ),
        decoration: InputDecoration(
          prefixText: prefix,
          prefixStyle: AppTypography.displaySmall.copyWith(
            color: colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppSpacing.lg),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            _amountController.text = '0';
            _amountController.selection = TextSelection.fromPosition(
              const TextPosition(offset: 1),
            );
            vm.setAmount(0);
            return;
          }

          // '0'으로 시작하고 두 번째가 숫자면 앞의 '0' 제거
          if (value.length >= 2 &&
              value.startsWith('0') &&
              value[1] != '.') {
            final newValue = value.substring(1);
            _amountController.text = newValue;
            _amountController.selection = TextSelection.fromPosition(
              TextPosition(offset: newValue.length),
            );
            final parsed = double.tryParse(newValue) ?? 0;
            if (state.currency == 'KRW') {
              vm.setAmount(parsed.roundToDouble());
            } else {
              vm.setAmount((parsed * 100).round() / 100);
            }
            return;
          }

          final parsed = double.tryParse(value) ?? 0;
          if (state.currency == 'KRW') {
            vm.setAmount(parsed.roundToDouble());
          } else {
            vm.setAmount((parsed * 100).round() / 100);
          }
        },
      ),
    );
  }

  String _categoryLabel(PresetCategory category) {
    switch (category) {
      case PresetCategory.VIDEO:
        return '영상';
      case PresetCategory.MUSIC:
        return '음악';
      case PresetCategory.GAME:
        return '게임';
      case PresetCategory.AI:
        return 'AI';
      case PresetCategory.DEV:
        return '개발';
      case PresetCategory.CLOUD:
        return '클라우드';
      case PresetCategory.PRODUCTIVITY:
        return '생산성';
      case PresetCategory.EDUCATION:
        return '교육';
      case PresetCategory.DESIGN:
        return '디자인';
      case PresetCategory.FINANCE:
        return '금융';
    }
  }

  String _formatDisplayAmount(double amount, String currency) {
    if (currency == 'KRW') {
      return '₩${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else {
      return '\$${amount.toStringAsFixed(amount == amount.toInt() ? 0 : 2)}';
    }
  }

  Future<void> _onSave(SubscriptionAddViewModel vm) async {
    if (_formKey.currentState!.validate()) {
      if (ref.read(subscriptionAddViewModelProvider).amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금액을 입력해주세요')),
        );
        return;
      }

      final success = await vm.save();
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _ServicePickerContent extends ConsumerStatefulWidget {
  final SubscriptionAddState state;
  final SubscriptionAddViewModel vm;

  const _ServicePickerContent({
    required this.state,
    required this.vm,
  });

  @override
  ConsumerState<_ServicePickerContent> createState() => _ServicePickerContentState();
}

class _ServicePickerContentState extends ConsumerState<_ServicePickerContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);

    return Column(
      children: [
        // 검색창
        Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '서비스 검색...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.vm.filterPresets('', locale);
                      },
                    )
                  : null,
            ),
            onChanged: (value) => widget.vm.filterPresets(value, locale),
          ),
        ),

        // 카테고리 필터
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            children: [
              _CategoryChip(
                label: '전체',
                selected: widget.state.selectedCategory == null,
                onTap: () => widget.vm.selectCategory(null, locale),
              ),
              ...PresetCategory.values.map((cat) => _CategoryChip(
                    label: _categoryLabel(cat),
                    selected: widget.state.selectedCategory == cat,
                    onTap: () => widget.vm.selectCategory(cat, locale),
                  )),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // 직접 입력 옵션
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ListTile(
            leading: Icon(Icons.edit_outlined, color: colorScheme.primary),
            title: const Text('직접 입력'),
            subtitle: const Text('목록에 없는 서비스 추가'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            onTap: () => widget.vm.selectManualInput(),
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // 결과 목록
        Expanded(
          child: widget.state.isLoadingPresets
              ? const Center(child: CircularProgressIndicator())
              : widget.state.filteredPresets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          TextButton(
                            onPressed: () => widget.vm.selectManualInput(),
                            child: const Text('직접 입력하기'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.state.filteredPresets.length,
                      itemBuilder: (context, index) {
                        final preset = widget.state.filteredPresets[index];
                        return ListTile(
                          title: Text(preset.displayName(locale)),
                          subtitle: Text(
                            '${_categoryLabel(preset.category)} \u00b7 ${preset.defaultCurrency}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          trailing: Icon(
                            Icons.add_circle_outline,
                            color: colorScheme.primary,
                          ),
                          onTap: () => widget.vm.selectPreset(preset, locale),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  String _categoryLabel(PresetCategory category) {
    switch (category) {
      case PresetCategory.VIDEO:
        return '영상';
      case PresetCategory.MUSIC:
        return '음악';
      case PresetCategory.GAME:
        return '게임';
      case PresetCategory.AI:
        return 'AI';
      case PresetCategory.DEV:
        return '개발';
      case PresetCategory.CLOUD:
        return '클라우드';
      case PresetCategory.PRODUCTIVITY:
        return '생산성';
      case PresetCategory.EDUCATION:
        return '교육';
      case PresetCategory.DESIGN:
        return '디자인';
      case PresetCategory.FINANCE:
        return '금융';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: colorScheme.primary.withValues(alpha: 0.2),
        checkmarkColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: selected ? colorScheme.primary : colorScheme.onSurface,
          fontSize: 12,
        ),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  final PlanOption plan;
  final Locale locale;
  final bool selected;
  final VoidCallback onTap;

  const _PlanChip({
    required this.plan,
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priceText = _formatPrice(plan.price, plan.currency);

    return ChoiceChip(
      label: Text('${plan.displayName(locale)} $priceText'),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? colorScheme.primary : colorScheme.onSurface,
      ),
    );
  }

  String _formatPrice(double price, String currency) {
    if (currency == 'KRW') {
      return '₩${price.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else {
      return '\$${price.toStringAsFixed(price == price.toInt() ? 0 : 2)}';
    }
  }
}
