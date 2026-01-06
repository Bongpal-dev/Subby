import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:bongpal/domain/model/subscription.dart';
import 'package:bongpal/domain/model/subscription_preset.dart';
import 'package:bongpal/domain/usecase/add_subscription_usecase.dart';
import 'package:bongpal/data/preset/subscription_presets.dart';
import 'package:bongpal/presentation/common/subby_app_bar.dart';

class SubscriptionAddScreen extends StatefulWidget {
  final AddSubscriptionUseCase addSubscription;

  const SubscriptionAddScreen({super.key, required this.addSubscription});

  @override
  State<SubscriptionAddScreen> createState() => _SubscriptionAddScreenState();
}

class _SubscriptionAddScreenState extends State<SubscriptionAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _memoController = TextEditingController();

  String _currency = 'KRW';
  double _amount = 0;
  int _amountStepKRW = 1000;
  double _amountStepUSD = 1;
  int _billingDay = 15;
  String _period = 'MONTHLY';
  String? _category;

  // null: 아직 선택 안함, preset: 프리셋 선택됨
  SubscriptionPreset? _selectedPreset;
  bool _isServiceSelected = false;

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _selectPreset(SubscriptionPreset preset) {
    final locale = Localizations.localeOf(context);
    setState(() {
      _selectedPreset = preset;
      _isServiceSelected = true;
      _nameController.text = preset.displayName(locale);
      _currency = preset.defaultCurrency;
      _amount = 0;
      _period = preset.defaultPeriod;
      _category = _mapPresetCategory(preset.category);
    });
  }

  void _selectManualInput() {
    setState(() {
      _selectedPreset = null;
      _isServiceSelected = true;
      _nameController.clear();
      _currency = 'KRW';
      _amount = 0;
      _period = 'MONTHLY';
      _category = null;
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedPreset = null;
      _isServiceSelected = false;
      _nameController.clear();
      _memoController.clear();
      _currency = 'KRW';
      _amount = 0;
      _billingDay = 15;
      _period = 'MONTHLY';
      _category = null;
    });
  }

  void _changeAmount(int direction) {
    setState(() {
      if (_currency == 'KRW') {
        _amount = (_amount + direction * _amountStepKRW).clamp(0, double.infinity);
      } else {
        _amount = ((_amount + direction * _amountStepUSD) * 100).round() / 100;
        _amount = _amount.clamp(0, double.infinity);
      }
    });
  }

  String _formatAmount() {
    if (_currency == 'KRW') {
      return '₩${_amount.toInt().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else {
      return '\$${_amount.toStringAsFixed(2)}';
    }
  }

  void _showAmountInput() {
    final controller = TextEditingController(
      text: _amount > 0 ? (_currency == 'KRW' ? _amount.toInt().toString() : _amount.toString()) : '',
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
            prefixText: _currency == 'KRW' ? '₩ ' : '\$ ',
            hintText: _currency == 'KRW' ? '0' : '0.00',
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
              setState(() {
                if (_currency == 'KRW') {
                  _amount = value.roundToDouble();
                } else {
                  _amount = (value * 100).round() / 100;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDayPicker() {
    int tempDay = _billingDay;
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
                          setState(() => _billingDay = tempDay);
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

  String _mapPresetCategory(PresetCategory category) {
    switch (category) {
      case PresetCategory.VIDEO:
        return '영상';
      case PresetCategory.MUSIC:
        return '음악';
      case PresetCategory.GAME:
        return '게임';
      case PresetCategory.AI:
      case PresetCategory.DEV:
      case PresetCategory.CLOUD:
      case PresetCategory.PRODUCTIVITY:
        return '소프트웨어';
      case PresetCategory.EDUCATION:
        return '교육';
      case PresetCategory.DESIGN:
        return '디자인';
      case PresetCategory.FINANCE:
        return '금융';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SubbyAppBar(title: '구독 추가'),
      body: _isServiceSelected
          ? _buildForm()
          : _ServicePickerContent(
              onSelectPreset: _selectPreset,
              onSelectManual: _selectManualInput,
            ),
    );
  }

  Widget _buildForm() {
    final colorScheme = Theme.of(context).colorScheme;

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
                      _selectedPreset != null ? Icons.check_circle : Icons.edit,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      _selectedPreset?.displayName(Localizations.localeOf(context)) ?? '직접 입력',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: _selectedPreset != null
                        ? Text(_categoryLabel(_selectedPreset!.category))
                        : const Text('서비스 정보를 직접 입력합니다'),
                    trailing: TextButton(
                      onPressed: _resetSelection,
                      child: const Text('변경'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 직접 입력인 경우에만 서비스명 입력 가능
                if (_selectedPreset == null) ...[
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
                        labels: const ['₩ 원화', '\$ 달러'],
                        selected: _currency,
                        onChanged: (value) {
                          setState(() {
                            _currency = value;
                            _amount = 0;
                          });
                        },
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
                            onTap: () => _changeAmount(-1),
                            isPrimary: false,
                          ),
                          const SizedBox(width: 12),
                          // 금액 표시 (터치하면 직접 입력)
                          Expanded(
                            child: GestureDetector(
                              onTap: _showAmountInput,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatAmount(),
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
                            onTap: () => _changeAmount(1),
                            isPrimary: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 단위 선택
                      _buildStepSelector(),
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
                              onTap: _showDayPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '매월 $_billingDay일',
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
                              selected: _period,
                              onChanged: (value) => setState(() => _period = value),
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
                onPressed: _onSave,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('저장', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildStepSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = _currency == 'KRW'
        ? [100, 1000, 10000]
        : [0.1, 1.0, 10.0];
    final currentStep = _currency == 'KRW' ? _amountStepKRW : _amountStepUSD;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: steps.map((step) {
          final isSelected = (_currency == 'KRW' && step == currentStep) ||
              (_currency == 'USD' && step == currentStep);
          final label = _currency == 'KRW'
              ? '₩${(step as int).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
              : '\$${(step as double).toString().replaceAll(RegExp(r'\.0$'), '')}';

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_currency == 'KRW') {
                    _amountStepKRW = step as int;
                  } else {
                    _amountStepUSD = step as double;
                  }
                });
              },
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

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      if (_amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('금액을 입력해주세요')),
        );
        return;
      }

      final subscription = Subscription(
        id: const Uuid().v4(),
        name: _nameController.text,
        amount: _amount,
        currency: _currency,
        billingDay: _billingDay,
        period: _period,
        category: _category,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
        createdAt: DateTime.now(),
      );

      await widget.addSubscription(subscription);
      if (mounted) Navigator.pop(context);
    }
  }
}

class _ServicePickerContent extends StatefulWidget {
  final void Function(SubscriptionPreset) onSelectPreset;
  final VoidCallback onSelectManual;

  const _ServicePickerContent({
    required this.onSelectPreset,
    required this.onSelectManual,
  });

  @override
  State<_ServicePickerContent> createState() => _ServicePickerContentState();
}

class _ServicePickerContentState extends State<_ServicePickerContent> {
  final _searchController = TextEditingController();
  PresetCategory? _selectedCategory;
  List<SubscriptionPreset> _filteredPresets = [];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _filterAndSort();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAndSort() {
    final query = _searchController.text.toLowerCase();
    final locale = Localizations.localeOf(context);

    var filtered = subscriptionPresets.where((preset) {
      final matchesCategory =
          _selectedCategory == null || preset.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          preset.displayName(locale).toLowerCase().contains(query) ||
          preset.displayNameKo.toLowerCase().contains(query) ||
          (preset.displayNameEn?.toLowerCase().contains(query) ?? false) ||
          preset.aliases.any((a) => a.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    // 정렬: 현재 로케일 기준 이름으로
    filtered.sort((a, b) => a.displayName(locale).compareTo(b.displayName(locale)));

    setState(() {
      _filteredPresets = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                        _filterAndSort();
                      },
                    )
                  : null,
            ),
            onChanged: (_) => _filterAndSort(),
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
                selected: _selectedCategory == null,
                onTap: () {
                  setState(() => _selectedCategory = null);
                  _filterAndSort();
                },
              ),
              ...PresetCategory.values.map((cat) => _CategoryChip(
                    label: _categoryLabel(cat),
                    selected: _selectedCategory == cat,
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      _filterAndSort();
                    },
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
            onTap: widget.onSelectManual,
          ),
        ),
        const SizedBox(height: 12),

        // 결과 목록
        Expanded(
          child: _filteredPresets.isEmpty
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
                        onPressed: widget.onSelectManual,
                        child: const Text('직접 입력하기'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredPresets.length,
                  itemBuilder: (context, index) {
                    final preset = _filteredPresets[index];
                    final locale = Localizations.localeOf(context);
                    return ListTile(
                      title: Text(preset.displayName(locale)),
                      subtitle: Text(
                        '${_categoryLabel(preset.category)} · ${preset.defaultCurrency}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      trailing: Icon(
                        Icons.add_circle_outline,
                        color: colorScheme.primary,
                      ),
                      onTap: () => widget.onSelectPreset(preset),
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
