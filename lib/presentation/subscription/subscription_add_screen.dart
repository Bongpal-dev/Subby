import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/subby_app_bar.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 선택된 서비스 표시
                _buildCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      state.selectedPreset != null ? Icons.check_circle : Icons.edit,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      state.selectedPreset?.displayName(locale) ?? '직접 입력',
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
                const SizedBox(height: 12),

                // 직접 입력인 경우에만 서비스명 입력 가능
                if (state.selectedPreset == null) ...[
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('서비스명'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: '예: Netflix, Spotify',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          onChanged: vm.setName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '서비스명을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // 통화 + 금액 그룹
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 통화 선택
                      _buildLabel('통화'),
                      const SizedBox(height: 8),
                      _buildSegmentedButton(
                        options: const ['KRW', 'USD'],
                        labels: const ['\u20a9 원화', '\$ 달러'],
                        selected: state.currency,
                        onChanged: vm.setCurrency,
                      ),
                      const SizedBox(height: 20),

                      // 금액
                      _buildLabel('금액'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // 마이너스 버튼
                          _buildAmountButton(
                            icon: Icons.remove,
                            onTap: () => vm.changeAmount(-1),
                            isPrimary: false,
                          ),
                          const SizedBox(width: 12),
                          // 금액 표시 (터치하면 직접 입력)
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showAmountInput(state, vm),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    vm.formatAmount(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // 플러스 버튼
                          _buildAmountButton(
                            icon: Icons.add,
                            onTap: () => vm.changeAmount(1),
                            isPrimary: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 단위 선택
                      _buildStepSelector(state, vm),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 결제일 + 결제 주기 그룹
                _buildCard(
                  child: Row(
                    children: [
                      // 결제일
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('결제일'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showDayPicker(state, vm),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '매월 ${state.billingDay}일',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 결제 주기
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('결제 주기'),
                            const SizedBox(height: 8),
                            _buildSegmentedButton(
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
                const SizedBox(height: 12),

                // 메모
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('메모 (선택)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _memoController,
                        decoration: const InputDecoration(
                          hintText: '메모를 입력하세요',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 3,
                        onChanged: vm.setMemo,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // 저장 버튼 - 하단 고정
          Container(
            padding: const EdgeInsets.all(16),
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
                    : const Text('저장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildSegmentedButton({
    required List<String> options,
    required List<String> labels,
    required String selected,
    required void Function(String) onChanged,
    bool compact = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = selected == options[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(options[index]),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: compact ? 10 : 12),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: compact ? 13 : 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAmountButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isPrimary ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 28,
          color: isPrimary ? Colors.white : colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildStepSelector(SubscriptionAddState state, SubscriptionAddViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = state.currency == 'KRW'
        ? [100, 1000, 10000]
        : [0.1, 1.0, 10.0];
    final currentStep = state.currency == 'KRW' ? state.amountStepKRW : state.amountStepUSD;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: steps.map((step) {
          final isSelected = (state.currency == 'KRW' && step == currentStep) ||
              (state.currency == 'USD' && step == currentStep);
          final label = state.currency == 'KRW'
              ? '\u20a9${(step as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
              : '\$${(step as double).toString().replaceAll(RegExp(r'\.0$'), '')}';

          return Expanded(
            child: GestureDetector(
              onTap: () => vm.setAmountStep(step),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showAmountInput(SubscriptionAddState state, SubscriptionAddViewModel vm) {
    final controller = TextEditingController(
      text: state.amount > 0 ? (state.currency == 'KRW' ? state.amount.toInt().toString() : state.amount.toString()) : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('금액 입력'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: InputDecoration(
            prefixText: state.currency == 'KRW' ? '\u20a9 ' : '\$ ',
            hintText: state.currency == 'KRW' ? '0' : '0.00',
          ),
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text) ?? 0;
              if (state.currency == 'KRW') {
                vm.setAmount(value.roundToDouble());
              } else {
                vm.setAmount((value * 100).round() / 100);
              }
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker(SubscriptionAddState state, SubscriptionAddViewModel vm) {
    int tempDay = state.billingDay;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '결제일 선택',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                // 날짜 그리드
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 44,
                  ),
                  itemCount: 31,
                  itemBuilder: (context, index) {
                    final day = index + 1;
                    final isSelected = tempDay == day;
                    return GestureDetector(
                      onTap: () => setDialogState(() => tempDay = day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // 선택된 날짜 표시
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '매월 $tempDay일',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 버튼들
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          vm.setBillingDay(tempDay);
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
          padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
        const SizedBox(height: 12),

        // 직접 입력 옵션
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
        const SizedBox(height: 12),

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
                          const SizedBox(height: 8),
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
      padding: const EdgeInsets.only(right: 8),
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
