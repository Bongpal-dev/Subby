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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final locale = Localizations.localeOf(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.bgSecondary,
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

  Widget _buildHandle(AppColorScheme colors) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.s3),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colors.borderSecondary,
        borderRadius: AppRadius.fullAll,
      ),
    );
  }

  Widget _buildSearchField(
    SubscriptionAddViewModel vm,
    Locale locale,
    AppColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: AppTextField(
        hint: '서비스 검색...',
        controller: _searchController,
        prefix: AppIcon(AppIconType.search, size: 20, color: colors.iconSecondary),
        onChanged: (value) => vm.filterPresets(value, locale),
      ),
    );
  }

  Widget _buildServiceList(
    SubscriptionAddState state,
    SubscriptionAddViewModel vm,
    Locale locale,
    AppColorScheme colors,
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
          child: Divider(color: colors.borderSecondary),
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

  void _showManualInputDialog(SubscriptionAddViewModel vm) {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgSecondary,
        title: Text('서비스명 입력', style: AppTypography.title),
        content: AppTextField(
          hint: '예: Netflix, Spotify',
          controller: controller,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              vm.setName(value);
              Navigator.pop(ctx);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('취소', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                vm.setName(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: Text('확인', style: TextStyle(color: colors.textAccent)),
          ),
        ],
      ),
    );
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
  final AppColorScheme colors;
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
                decoration: BoxDecoration(color: colors.buttonDisableBg),
                child: Center(
                  child: isManualInput
                      ? AppIcon(AppIconType.plus, size: 20, color: colors.iconSecondary)
                      : Text(
                          preset?.displayName(locale).substring(0, 1) ?? 'S',
                          style: AppTypography.title.copyWith(color: colors.textSecondary),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  isManualInput ? '직접 입력' : preset!.displayName(locale),
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
