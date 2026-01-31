import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_icons.dart';
import 'package:subby/core/theme/app_radius.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/core/theme/app_typography.dart';
import 'package:subby/domain/model/subscription_preset.dart';
import 'package:subby/presentation/common/widgets/subby_text_field.dart';
import 'package:subby/presentation/subscription/subscription_add_view_model.dart';

/// 서비스 검색/선택 드롭다운
/// - 텍스트 입력 시 검색 결과 드롭다운 표시
/// - 프리셋 선택 시 로고 + 이름 표시
/// - 직접 입력 선택 시 입력한 텍스트가 서비스명이 됨
class ServiceDropdown extends ConsumerStatefulWidget {
  final String? editSubscriptionId;

  const ServiceDropdown({
    super.key,
    this.editSubscriptionId,
  });

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
      builder: (context) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: Offset(0, size.height + 4),
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: size.width,
            child: _ServiceDropdownMenu(
            editSubscriptionId: widget.editSubscriptionId,
            onPresetSelected: (preset) {
              final vm = ref.read(subscriptionAddViewModelProvider(widget.editSubscriptionId).notifier);
              final locale = Localizations.localeOf(this.context);
              vm.selectPreset(preset, locale);
              _controller.text = preset.displayName(locale);
              _removeOverlay();
              _focusNode.unfocus();
            },
            onManualInputSelected: () {
              final vm = ref.read(subscriptionAddViewModelProvider(widget.editSubscriptionId).notifier);
              // 현재 입력된 텍스트를 서비스명으로 사용
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
    final state = ref.watch(subscriptionAddViewModelProvider(widget.editSubscriptionId));
    final vm = ref.read(subscriptionAddViewModelProvider(widget.editSubscriptionId).notifier);
    final colors = context.colors;
    final locale = Localizations.localeOf(context);

    // 프리셋 선택 변경 감지하여 컨트롤러 동기화
    ref.listen(
      subscriptionAddViewModelProvider(widget.editSubscriptionId).select((s) => s.selectedPreset),
      (prev, next) {
        if (next != null) {
          _controller.text = next.displayName(locale);
        }
      },
    );

    // state.name → 컨트롤러 동기화 (컨트롤러가 비어있고 name이 있을 때)
    if (state.isServiceSelected && state.name.isNotEmpty && _controller.text.isEmpty) {
      _controller.text = state.name;
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
          vm.clearPresetSelection(); // 입력 시 프리셋 선택 해제
          vm.filterPresets(value, locale);
          _updateOverlay();
        },
      ),
    );
  }
}

/// 서비스 로고 플레이스홀더 위젯
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

/// 서비스 드롭다운 메뉴
class _ServiceDropdownMenu extends ConsumerWidget {
  const _ServiceDropdownMenu({
    required this.editSubscriptionId,
    required this.onPresetSelected,
    required this.onManualInputSelected,
  });

  final String? editSubscriptionId;
  final void Function(SubscriptionPreset preset) onPresetSelected;
  final VoidCallback onManualInputSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionAddViewModelProvider(editSubscriptionId));
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
            // 프리셋 목록 (스크롤 가능, 최대 176px)
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
            // 직접 입력 (항상 하단에 고정)
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
              // 로고 플레이스홀더
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
