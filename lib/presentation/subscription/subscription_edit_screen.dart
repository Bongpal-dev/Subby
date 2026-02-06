import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_edit_view_model.dart';

class SubscriptionEditScreen extends ConsumerStatefulWidget {
  final String subscriptionId;

  const SubscriptionEditScreen({
    super.key,
    required this.subscriptionId,
  });

  @override
  ConsumerState<SubscriptionEditScreen> createState() => _SubscriptionEditScreenState();
}

class _SubscriptionEditScreenState extends ConsumerState<SubscriptionEditScreen> {
  final _focusSink = FocusNode(skipTraversal: true);

  @override
  void dispose() {
    _focusSink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(subscriptionEditViewModelProvider(widget.subscriptionId));

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: colors.bgPrimary,
        appBar: const SubbyAppBar(title: '구독 수정', showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () => _focusSink.requestFocus(),
      child: Focus(
        focusNode: _focusSink,
        child: Scaffold(
          backgroundColor: colors.bgPrimary,
          appBar: const SubbyAppBar(
            title: '구독 수정',
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.s6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ServiceDropdownEdit(subscriptionId: widget.subscriptionId),
                      const SizedBox(height: AppSpacing.s6),
                      _PlanSection(
                        subscriptionId: widget.subscriptionId,
                        focusSink: _focusSink,
                      ),
                      _AmountCurrencySection(subscriptionId: widget.subscriptionId),
                      const SizedBox(height: AppSpacing.s6),
                      _BillingDaySection(
                        subscriptionId: widget.subscriptionId,
                        focusSink: _focusSink,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _PeriodSection(
                        subscriptionId: widget.subscriptionId,
                        focusSink: _focusSink,
                      ),
                      const SizedBox(height: AppSpacing.s6),
                      _CategorySection(subscriptionId: widget.subscriptionId),
                      const SizedBox(height: AppSpacing.s6),
                      _MemoSection(subscriptionId: widget.subscriptionId),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _SaveButton(subscriptionId: widget.subscriptionId),
            ],
          ),
        ),
      ),
    );
  }
}

/// 서비스 드롭다운 (Edit용)
class _ServiceDropdownEdit extends ConsumerStatefulWidget {
  final String subscriptionId;

  const _ServiceDropdownEdit({required this.subscriptionId});

  @override
  ConsumerState<_ServiceDropdownEdit> createState() => _ServiceDropdownEditState();
}

class _ServiceDropdownEditState extends ConsumerState<_ServiceDropdownEdit> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showDropdown();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isDropdownOpen = false);
    }
  }

  void _showDropdown() {
    if (_isDropdownOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, size.height + 4),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: size.width,
            child: _ServiceDropdownMenuEdit(
              subscriptionId: widget.subscriptionId,
              onPresetSelected: (preset) {
                final vm = ref.read(subscriptionEditViewModelProvider(widget.subscriptionId).notifier);
                final locale = Localizations.localeOf(this.context);
                vm.selectPreset(preset, locale);
                _controller.text = preset.displayName(locale);
                _removeOverlay();
                _focusNode.unfocus();
              },
              onManualInputSelected: () {
                final vm = ref.read(subscriptionEditViewModelProvider(widget.subscriptionId).notifier);
                vm.selectManualInput();
                _removeOverlay();
                _focusNode.unfocus();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionEditViewModelProvider(widget.subscriptionId);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    // 초기값 동기화 (한 번만)
    if (!_initialized && state.name.isNotEmpty) {
      _controller.text = state.name;
      _initialized = true;
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: SubbyTextField(
        label: '서비스',
        hint: '서비스 이름을 입력해 주세요',
        controller: _controller,
        focusNode: _focusNode,
        prefix: state.isServiceSelected
            ? _ServiceLogo(colors: colors)
            : AppIcon(AppIconType.search, size: 24, color: colors.iconSecondary),
        onChanged: (value) {
          vm.setName(value);
          vm.clearPresetSelection();
          vm.filterPresets(value, locale);
          _updateOverlay();
        },
      ),
    );
  }
}

/// 서비스 로고 플레이스홀더
class _ServiceLogo extends StatelessWidget {
  const _ServiceLogo({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors.buttonDisableBg,
        borderRadius: BorderRadius.circular(AppSpacing.s3),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        'assets/icons/subby_place_holder.svg',
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          colors.buttonDisableText,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// 서비스 드롭다운 메뉴 (Edit용)
class _ServiceDropdownMenuEdit extends ConsumerWidget {
  const _ServiceDropdownMenuEdit({
    required this.subscriptionId,
    required this.onPresetSelected,
    required this.onManualInputSelected,
  });

  final String subscriptionId;
  final void Function(SubscriptionPreset preset) onPresetSelected;
  final VoidCallback onManualInputSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionEditViewModelProvider(subscriptionId));
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: colors.borderSecondary),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.isLoadingPresets)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.s4),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.filteredPresets.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 176),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(AppSpacing.s2),
                  itemCount: state.filteredPresets.length,
                  itemBuilder: (context, index) {
                    final preset = state.filteredPresets[index];
                    return _PresetDropdownItem(
                      preset: preset,
                      locale: locale,
                      colors: colors,
                      onTap: () => onPresetSelected(preset),
                    );
                  },
                ),
              ),
            _ManualInputItem(
              colors: colors,
              showDivider: state.filteredPresets.isNotEmpty,
              onTap: onManualInputSelected,
            ),
          ],
        ),
      ),
    );
  }
}

/// 프리셋 드롭다운 아이템
class _PresetDropdownItem extends StatelessWidget {
  const _PresetDropdownItem({
    required this.preset,
    required this.locale,
    required this.colors,
    required this.onTap,
  });

  final SubscriptionPreset preset;
  final Locale locale;
  final AppColorScheme colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.s2),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.buttonDisableBg,
                  borderRadius: BorderRadius.circular(AppSpacing.s3),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/subby_place_holder.svg',
                  width: 28,
                  height: 28,
                  colorFilter: ColorFilter.mode(
                    colors.buttonDisableText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  preset.displayName(locale),
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 직접 입력 아이템
class _ManualInputItem extends StatelessWidget {
  const _ManualInputItem({
    required this.colors,
    required this.showDivider,
    required this.onTap,
  });

  final AppColorScheme colors;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
            child: Divider(
              height: 1,
              thickness: 1,
              color: colors.borderSecondary,
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.s2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppSpacing.s2),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
                child: Row(
                  children: [
                    AppIcon(
                      AppIconType.plus,
                      size: 24,
                      color: colors.iconSecondary,
                    ),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Text(
                        '직접 입력',
                        style: AppTypography.body.copyWith(color: colors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 요금제 섹션
class _PlanSection extends ConsumerWidget {
  final String subscriptionId;
  final FocusNode focusSink;

  const _PlanSection({
    required this.subscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final selectedPreset = ref.watch(provider.select((s) => s.selectedPreset));
    final selectedPlan = ref.watch(provider.select((s) => s.selectedPlan));
    final period = ref.watch(provider.select((s) => s.period));

    if (selectedPreset?.hasPlans != true) {
      return const SizedBox.shrink();
    }

    final vm = ref.read(provider.notifier);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    // 현재 선택된 결제주기에 맞는 요금제만 필터링
    final plans = selectedPreset!.plans.where((p) => p.period == period).toList();

    if (plans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('요금제', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: plans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            return Padding(
              padding: EdgeInsets.only(right: index < plans.length - 1 ? AppSpacing.s2 : 0),
              child: SubbyChip(
                label: plan.displayName(locale),
                isSelected: selectedPlan == plan,
                onTap: () {
                  focusSink.requestFocus();
                  vm.selectPlan(plan);
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.s6),
      ],
    );
  }
}

/// 금액/통화 섹션
class _AmountCurrencySection extends ConsumerStatefulWidget {
  final String subscriptionId;

  const _AmountCurrencySection({required this.subscriptionId});

  @override
  ConsumerState<_AmountCurrencySection> createState() => _AmountCurrencySectionState();
}

class _AmountCurrencySectionState extends ConsumerState<_AmountCurrencySection> {
  final _amountController = TextEditingController(text: '0');
  final _amountFocusNode = FocusNode();
  bool _initialized = false;

  static const _currencies = ['KRW', 'USD', 'JPY', 'EUR'];
  static const _currencyLabels = {
    'KRW': 'KRW  원 (₩)',
    'USD': 'USD  달러 (\$)',
    'JPY': 'JPY  엔 (¥)',
    'EUR': 'EUR  유로 (€)',
  };

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _syncAmountController(double amount, String currency) {
    if (!_amountFocusNode.hasFocus) {
      final text = currency == 'KRW'
          ? amount.toInt().toString()
          : amount.toString();
      if (_amountController.text != text) {
        _amountController.text = text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionEditViewModelProvider(widget.subscriptionId);
    final amount = ref.watch(provider.select((s) => s.amount));
    final currency = ref.watch(provider.select((s) => s.currency));
    final vm = ref.read(provider.notifier);

    final colors = context.colors;

    // 초기값 동기화
    if (!_initialized && amount > 0) {
      _syncAmountController(amount, currency);
      _initialized = true;
    } else {
      _syncAmountController(amount, currency);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('금액', style: AppTypography.label.copyWith(color: colors.textPrimary)),
              const SizedBox(height: AppSpacing.s2),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.bgTertiary,
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: colors.borderSecondary),
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.mdAll,
                  child: TextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(color: colors.textPrimary),
                    decoration: const InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.s4,
                        vertical: AppSpacing.s4,
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0;
                      vm.setAmount(currency == 'KRW'
                          ? parsed.roundToDouble()
                          : (parsed * 100).round() / 100);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: SubbyDropdown<String>(
            label: '통화',
            items: _currencies,
            value: currency,
            onChanged: (value) {
              if (value != null) vm.setCurrency(value);
            },
            itemBuilder: (item) => SubbyDropdownItem(
              label: _currencyLabels[item] ?? item,
              isSelected: currency == item,
            ),
          ),
        ),
      ],
    );
  }
}

/// 결제일 섹션
class _BillingDaySection extends ConsumerWidget {
  final String subscriptionId;
  final FocusNode focusSink;

  const _BillingDaySection({
    required this.subscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final billingDay = ref.watch(provider.select((s) => s.billingDay));
    final billingMonth = ref.watch(provider.select((s) => s.billingMonth));
    final period = ref.watch(provider.select((s) => s.period));
    final vm = ref.read(provider.notifier);

    final colors = context.colors;
    final isYearly = period == 'YEARLY';

    // 표시 텍스트
    final displayText = isYearly && billingMonth != null
        ? '매년 $billingMonth월 $billingDay일'
        : '매월 $billingDay일';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제일', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        GestureDetector(
          onTap: () async {
            focusSink.requestFocus();
            if (isYearly) {
              // 연간: 월/일 선택
              final result = await showMonthDayPickerDialog(
                context: context,
                initialMonth: billingMonth ?? DateTime.now().month,
                initialDay: billingDay,
              );
              if (result != null) {
                vm.setBillingMonth(result.month);
                vm.setBillingDay(result.day);
              }
            } else {
              // 월간: 일만 선택
              final result = await showDayPickerDialog(
                context: context,
                initialDay: billingDay,
              );
              if (result != null) vm.setBillingDay(result);
            }
          },
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            decoration: BoxDecoration(
              color: colors.bgTertiary,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: colors.borderSecondary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.body.copyWith(color: colors.textPrimary),
                  ),
                ),
                AppIcon(AppIconType.calendar, size: 24, color: colors.iconSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 결제 주기 섹션
class _PeriodSection extends ConsumerWidget {
  final String subscriptionId;
  final FocusNode focusSink;

  const _PeriodSection({
    required this.subscriptionId,
    required this.focusSink,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final period = ref.watch(provider.select((s) => s.period));
    final vm = ref.read(provider.notifier);

    final colors = context.colors;

    const periods = [('MONTHLY', '매월'), ('YEARLY', '매년')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 주기', style: AppTypography.label.copyWith(color: colors.textPrimary)),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: periods.map((p) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: p.$1 != 'YEARLY' ? AppSpacing.s2 : 0),
                child: SubbyChip(
                  label: p.$2,
                  isSelected: period == p.$1,
                  onTap: () {
                    focusSink.requestFocus();
                    vm.setPeriod(p.$1);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 카테고리 섹션
class _CategorySection extends ConsumerWidget {
  final String subscriptionId;

  const _CategorySection({required this.subscriptionId});

  static const _categories = ['영상', '음악', '게임', 'AI', '소프트웨어', '교육', '금융', '멤버십'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final category = ref.watch(provider.select((s) => s.category));
    final vm = ref.read(provider.notifier);

    return SubbyDropdown<String>(
      label: '카테고리',
      hint: '카테고리를 선택해 주세요',
      items: _categories,
      value: category,
      onChanged: (value) {
        if (value != null) vm.setCategory(value);
      },
      itemBuilder: (item) => SubbyDropdownItem(
        label: item,
        isSelected: category == item,
      ),
    );
  }
}

/// 메모 섹션
class _MemoSection extends ConsumerStatefulWidget {
  final String subscriptionId;

  const _MemoSection({required this.subscriptionId});

  @override
  ConsumerState<_MemoSection> createState() => _MemoSectionState();
}

class _MemoSectionState extends ConsumerState<_MemoSection> {
  final _controller = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = subscriptionEditViewModelProvider(widget.subscriptionId);
    final memo = ref.watch(provider.select((s) => s.memo));
    final vm = ref.read(provider.notifier);

    if (!_initialized && memo.isNotEmpty) {
      _controller.text = memo;
      _initialized = true;
    }

    return SubbyTextField(
      label: '메모',
      hint: '메모를 입력해 주세요',
      controller: _controller,
      onChanged: vm.setMemo,
    );
  }
}

/// 저장 버튼
class _SaveButton extends ConsumerWidget {
  final String subscriptionId;

  const _SaveButton({required this.subscriptionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final isSaving = ref.watch(provider.select((s) => s.isSaving));

    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(top: BorderSide(color: colors.borderSecondary)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
      ),
      child: SubbyButton(
        label: '저장하기',
        onPressed: isSaving ? null : () => _onSave(context, ref),
        isExpanded: true,
        isEnabled: !isSaving,
      ),
    );
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final provider = subscriptionEditViewModelProvider(subscriptionId);
    final state = ref.read(provider);
    final vm = ref.read(provider.notifier);

    if (state.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서비스를 선택해주세요')),
      );
      return;
    }
    if (state.amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('금액을 입력해주세요')),
      );
      return;
    }

    final success = await vm.save();
    if (success && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
