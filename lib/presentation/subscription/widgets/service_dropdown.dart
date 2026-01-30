import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/widgets/app_text_field.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';

/// 서비스 검색/선택 드롭다운
/// - 텍스트 입력 시 검색 결과 드롭다운 표시
/// - 프리셋 선택 시 로고 + 이름 표시
class ServiceDropdown extends ConsumerStatefulWidget {
  const ServiceDropdown({super.key});

  @override
  ConsumerState<ServiceDropdown> createState() => _ServiceDropdownState();
}

class _ServiceDropdownState extends ConsumerState<ServiceDropdown> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

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
      // 포커스 잃으면 약간의 딜레이 후 닫기 (아이템 선택 가능하도록)
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
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: _ServiceDropdownMenu(
            onItemSelected: (preset) {
              final vm = ref.read(subscriptionAddViewModelProvider.notifier);
              final locale = Localizations.localeOf(this.context);
              vm.selectPreset(preset, locale);
              _controller.text = preset.displayName(locale);
              _removeOverlay();
              _focusNode.unfocus();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionAddViewModelProvider);
    final vm = ref.read(subscriptionAddViewModelProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final locale = Localizations.localeOf(context);

    // 프리셋 선택되면 컨트롤러 동기화
    if (state.selectedPreset != null && _controller.text != state.selectedPreset!.displayName(locale)) {
      _controller.text = state.selectedPreset!.displayName(locale);
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: AppTextField(
        label: '서비스',
        hint: '서비스 이름을 입력해 주세요',
        controller: _controller,
        focusNode: _focusNode,
        prefix: state.selectedPreset != null
            ? _ServiceLogo(preset: state.selectedPreset!, colors: colors)
            : AppIcon(AppIconType.search, size: 24, color: colors.iconSecondary),
        onChanged: (value) {
          vm.setName(value);
          vm.filterPresets(value, locale);
          _updateOverlay();
        },
      ),
    );
  }
}

/// 서비스 로고 위젯
class _ServiceLogo extends StatelessWidget {
  const _ServiceLogo({
    required this.preset,
    required this.colors,
  });

  final SubscriptionPreset preset;
  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final initial = preset.displayName(locale).isNotEmpty
        ? preset.displayName(locale).substring(0, 1).toUpperCase()
        : 'S';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: colors.buttonDisableBg),
      child: Center(
        child: Text(
          initial,
          style: AppTypography.title.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

/// 서비스 드롭다운 메뉴
class _ServiceDropdownMenu extends ConsumerWidget {
  const _ServiceDropdownMenu({
    required this.onItemSelected,
  });

  final void Function(SubscriptionPreset preset) onItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionAddViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final locale = Localizations.localeOf(context);

    // 검색 결과가 없으면 표시하지 않음
    if (state.filteredPresets.isEmpty && !state.isLoadingPresets) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
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
        child: state.isLoadingPresets
            ? const Padding(
                padding: EdgeInsets.all(AppSpacing.s4),
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppSpacing.s2),
                itemCount: state.filteredPresets.length,
                itemBuilder: (context, index) {
                  final preset = state.filteredPresets[index];
                  return _DropdownItem(
                    preset: preset,
                    locale: locale,
                    colors: colors,
                    onTap: () => onItemSelected(preset),
                  );
                },
              ),
      ),
    );
  }
}

/// 드롭다운 아이템
class _DropdownItem extends StatelessWidget {
  const _DropdownItem({
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
    final initial = preset.displayName(locale).isNotEmpty
        ? preset.displayName(locale).substring(0, 1).toUpperCase()
        : 'S';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3,
            vertical: AppSpacing.s2,
          ),
          child: Row(
            children: [
              // 로고
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colors.buttonDisableBg),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTypography.title.copyWith(color: colors.textSecondary),
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
