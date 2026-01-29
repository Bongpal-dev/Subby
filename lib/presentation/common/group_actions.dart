import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';

Future<void> showCreateGroupFlow(BuildContext context, WidgetRef ref) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final createGroup = ref.read(createGroupUseCaseProvider);
  final homeViewModel = ref.read(homeViewModelProvider.notifier);

  final groupName = await showAppTextInputDialog(
    context: context,
    title: '새 그룹 만들기',
    hint: '예: 가족 구독, 친구들',
    maxLength: 10,
    confirmLabel: '만들기',
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '그룹 이름을 입력해주세요';
      }
      return null;
    },
  );

  if (groupName != null) {
    try {
      final groupCode = await createGroup(groupName);
      homeViewModel.selectGroup(groupCode);
    } on Exception catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }
}

Future<void> showJoinGroupFlow(BuildContext context, WidgetRef ref) async {
  final groupCode = await showAppTextInputDialog(
    context: context,
    title: '초대 코드로 참여',
    description: '전달받은 초대 코드를 입력해\n그룹에 참여합니다',
    hint: '초대 코드를 입력해 주세요',
    maxLength: 12,
    confirmLabel: '참여하기',
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '그룹 코드를 입력해주세요';
      }

      final code = value.trim().toUpperCase();

      if (code.length != 12) {
        return '12자리 코드를 입력해주세요';
      }
      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
        return '영문 대문자와 숫자만 입력해주세요';
      }

      return null;
    },
  );

  if (groupCode == null) return;

  final code = groupCode.trim().toUpperCase();

  if (context.mounted) {
    showJoinGroupDialog(
      context: context,
      groupCode: code,
    );
  }
}
