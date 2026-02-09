import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subby/core/theme/app_colors.dart';
import 'package:subby/core/theme/app_spacing.dart';
import 'package:subby/domain/usecase/send_inquiry_usecase.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/inquiry/inquiry_view_model.dart';

class InquiryScreen extends ConsumerStatefulWidget {
  const InquiryScreen({super.key});

  @override
  ConsumerState<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends ConsumerState<InquiryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _focusSink = FocusNode(skipTraversal: true);

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _focusSink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.subbyColor;
    final state = ref.watch(inquiryViewModelProvider);
    final vm = ref.read(inquiryViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => _focusSink.requestFocus(),
      child: Focus(
        focusNode: _focusSink,
        child: Scaffold(
          backgroundColor: colors.surface,
          appBar: const SubbyAppBar(
            title: '문의하기',
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
                      // 카테고리
                      SubbyDropdown<String>(
                        label: '카테고리',
                        hint: '카테고리를 선택해 주세요',
                        items: const ['버그 신고', '정보 수정 요청', '사용 문의', '기타'],
                        value: state.category.isEmpty ? null : state.category,
                        onChanged: (value) {
                          if (value != null) vm.setCategory(value);
                        },
                        itemBuilder: (item) => SubbyDropdownItem(
                          label: item,
                          isSelected: state.category == item,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s6),

                      // 제목
                      SubbyTextField(
                        label: '제목',
                        hint: '제목을 입력해 주세요',
                        controller: _titleController,
                        maxLength: 50,
                        onChanged: vm.setTitle,
                      ),
                      const SizedBox(height: AppSpacing.s6),

                      // 내용
                      SubbyTextField(
                        label: '내용',
                        hint: '내용을 입력해 주세요',
                        controller: _contentController,
                        maxLines: 6,
                        maxLength: 500,
                        height: 160,
                        onChanged: vm.setContent,
                      ),
                    ],
                  ),
                ),
              ),
              _SendButton(onSend: () => _onSend(context, ref)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSend(BuildContext context, WidgetRef ref) async {
    final state = ref.read(inquiryViewModelProvider);
    final vm = ref.read(inquiryViewModelProvider.notifier);

    if (state.category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카테고리를 선택해주세요')),
      );
      return;
    }
    if (state.title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }
    if (state.content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요')),
      );
      return;
    }

    final result = await vm.send();

    if (!context.mounted) return;

    if (result == SendInquiryResult.success) {
      Fluttertoast.showToast(
        msg: '문의가 전송되었습니다',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    } else {
      showSubbyDialog(
        context: context,
        title: '전송 실패',
        description: '문의 전송에 실패했습니다. 다시 시도해주세요.',
        actions: [
          SubbyDialogAction(
            label: '확인',
            isPrimary: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    }
  }
}

class _SendButton extends ConsumerWidget {
  final VoidCallback onSend;

  const _SendButton({required this.onSend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSending = ref.watch(
      inquiryViewModelProvider.select((s) => s.isSending),
    );
    final colors = context.subbyColor;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s4,
        top: AppSpacing.s4,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.s4,
      ),
      child: SubbyButton(
        label: '전송',
        onPressed: isSending ? null : onSend,
        isExpanded: true,
        isEnabled: !isSending,
      ),
    );
  }
}
