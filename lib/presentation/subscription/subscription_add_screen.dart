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
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _feeController = TextEditingController();

  String _currency = 'KRW';
  int _billingDay = 1;
  String _period = 'MONTHLY';
  String? _category;

  // null: 아직 선택 안함, preset: 프리셋 선택됨
  SubscriptionPreset? _selectedPreset;
  bool _isServiceSelected = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  void _selectPreset(SubscriptionPreset preset) {
    setState(() {
      _selectedPreset = preset;
      _isServiceSelected = true;
      _nameController.text = preset.displayNameKo;
      _currency = preset.defaultCurrency;
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
      _period = 'MONTHLY';
      _category = null;
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedPreset = null;
      _isServiceSelected = false;
      _nameController.clear();
      _amountController.clear();
      _memoController.clear();
      _feeController.clear();
      _currency = 'KRW';
      _billingDay = 1;
      _period = 'MONTHLY';
      _category = null;
    });
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
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 선택된 서비스 표시
          Card(
            child: ListTile(
              leading: Icon(
                _selectedPreset != null ? Icons.check_circle : Icons.edit,
                color: colorScheme.primary,
              ),
              title: Text(
                _selectedPreset?.displayNameKo ?? '직접 입력',
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
          const SizedBox(height: 16),

          // 직접 입력인 경우에만 서비스명 입력 가능
          if (_selectedPreset == null) ...[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '서비스명',
                hintText: 'Netflix, Spotify 등',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '서비스명을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: '금액',
                  ),
                  keyboardType: TextInputType.number,
                  autofocus: _selectedPreset != null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '금액을 입력해주세요';
                    }
                    if (double.tryParse(value) == null) {
                      return '숫자만 입력해주세요';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: const InputDecoration(
                    labelText: '통화',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'KRW', child: Text('₩')),
                    DropdownMenuItem(value: 'USD', child: Text('\$')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _currency = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _billingDay,
                  decoration: const InputDecoration(
                    labelText: '결제일',
                  ),
                  items: List.generate(31, (i) => i + 1)
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text('$day일'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _billingDay = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _period,
                  decoration: const InputDecoration(
                    labelText: '결제 주기',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'MONTHLY', child: Text('매월')),
                    DropdownMenuItem(value: 'YEARLY', child: Text('매년')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _period = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 직접 입력인 경우에만 카테고리 선택 가능
          if (_selectedPreset == null) ...[
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: '카테고리 (선택)',
              ),
              items: const [
                DropdownMenuItem(value: '영상', child: Text('영상')),
                DropdownMenuItem(value: '음악', child: Text('음악')),
                DropdownMenuItem(value: '게임', child: Text('게임')),
                DropdownMenuItem(value: '소프트웨어', child: Text('소프트웨어')),
                DropdownMenuItem(value: '교육', child: Text('교육')),
                DropdownMenuItem(value: '디자인', child: Text('디자인')),
                DropdownMenuItem(value: '금융', child: Text('금융')),
                DropdownMenuItem(value: '기타', child: Text('기타')),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: 16),
          ],

          TextFormField(
            controller: _memoController,
            decoration: const InputDecoration(
              labelText: '메모 (선택)',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          if (_currency == 'USD') ...[
            TextFormField(
              controller: _feeController,
              decoration: const InputDecoration(
                labelText: '수수료 % (선택)',
                hintText: '해외결제 수수료 등',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
          ],

          const SizedBox(height: 8),

          FilledButton(
            onPressed: _onSave,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('저장', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
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
      final subscription = Subscription(
        id: const Uuid().v4(),
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        currency: _currency,
        billingDay: _billingDay,
        period: _period,
        category: _category,
        memo: _memoController.text.isEmpty ? null : _memoController.text,
        feeRatePercent: _feeController.text.isEmpty
            ? null
            : double.tryParse(_feeController.text),
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

  @override
  void initState() {
    super.initState();
    _filterAndSort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAndSort() {
    final query = _searchController.text.toLowerCase();

    var filtered = subscriptionPresets.where((preset) {
      final matchesCategory =
          _selectedCategory == null || preset.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          preset.displayNameKo.toLowerCase().contains(query) ||
          (preset.displayNameEn?.toLowerCase().contains(query) ?? false) ||
          preset.aliases.any((a) => a.toLowerCase().contains(query));
      return matchesCategory && matchesQuery;
    }).toList();

    // 가나다순 정렬
    filtered.sort((a, b) => a.displayNameKo.compareTo(b.displayNameKo));

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
                    return ListTile(
                      title: Text(preset.displayNameKo),
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
