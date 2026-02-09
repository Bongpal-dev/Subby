import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';

class ServicePickerSheet extends ConsumerStatefulWidget {
  const ServicePickerSheet({super.key});

  @override
  ConsumerState<ServicePickerSheet> createState() => _ServicePickerSheetState();
}

class _ServicePickerSheetState extends ConsumerState<ServicePickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionAddViewModelProvider);
    final vm = ref.read(subscriptionAddViewModelProvider.notifier);
    final colors = context.subbyColor;
    final locale = Localizations.localeOf(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: AppRadius.xlTop,
      ),
      child: Column(
        children: [
          _buildHandle(colors),
          const SizedBox(height: AppSpacing.s4),
          _buildSearchField(vm, locale, colors),
          const SizedBox(height: AppSpacing.s4),
          Expanded(
            child: state.isLoadingPresets
                ? const Center(child: CircularProgressIndicator())
                : _buildServiceList(state, vm, locale, colors),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(SubbyColor colors) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.s3),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colors.outlineVariant,
        borderRadius: AppRadius.fullAll,
      ),
    );
  }

  Widget _buildSearchField(
    SubscriptionAddViewModel vm,
    Locale locale,
    SubbyColor colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: AppTextField(
        hint: '서비스 검색...',
        controller: _searchController,
        prefix: AppIcon(AppIconType.search, size: 20, color: colors.onSurfaceVariant),
        onChanged: (value) => vm.filterPresets(value, locale),
      ),
    );
  }

  Widget _buildServiceList(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    Locale locale,
    SubbyColor colors,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
      children: [
        ...state.filteredPresets.map((preset) => _ServiceItem(
              preset: preset,
              locale: locale,
              colors: colors,
              onTap: () {
                vm.selectPreset(preset, locale);
                Navigator.pop(context);
              },
            )),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s2,
          ),
          child: Divider(color: colors.outlineVariant),
        ),
        _ServiceItem(
          isManualInput: true,
          locale: locale,
          colors: colors,
          onTap: () {
            vm.selectManualInput();
            Navigator.pop(context);
            _showManualInputDialog(vm);
          },
        ),
      ],
    );
  }

  Future<void> _showManualInputDialog(SubscriptionAddViewModel vm) async {
    final result = await showSubbyTextInputDialog(
      context: context,
      title: '서비스명 입력',
      hint: '예: Netflix, Spotify',
      confirmLabel: '확인',
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '서비스명을 입력해주세요';
        }
        return null;
      },
    );

    if (result != null) {
      vm.setName(result);
    }
  }
}

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({
    this.preset,
    this.isManualInput = false,
    required this.locale,
    required this.colors,
    required this.onTap,
  });

  final SubscriptionPreset? preset;
  final bool isManualInput;
  final Locale locale;
  final SubbyColor colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.surfaceContainerHighest),
                child: Center(
                  child: isManualInput
                      ? AppIcon(AppIconType.plus, size: 20, color: colors.onSurfaceVariant)
                      : Text(
                          preset?.displayName(locale).substring(0, 1) ?? 'S',
                          style: AppTypography.title.copyWith(color: colors.onSurfaceVariant),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  isManualInput ? '직접 입력' : preset!.displayName(locale),
                  style: AppTypography.body.copyWith(color: colors.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
