import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/usecase/join_group_usecase.dart';
import 'package:subby/presentation/common/widgets/widgets.dart';
import 'package:subby/presentation/home/home_view_model.dart';

Future<void> showCreateGroupFlow(BuildContext context, WidgetRef ref) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final createGroup = ref.read(createGroupUseCaseProvider);
  final homeViewModel = ref.read(homeViewModelProvider.notifier);

  final groupName = await showSubbyTextInputDialog(
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
  final groupCode = await showSubbyTextInputDialog(
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
    await joinGroupWithConfirmation(
      context: context,
      ref: ref,
      groupCode: code,
    );
  }
}

/// 그룹 참여 확인 다이얼로그 표시 후 참여 처리
Future<bool> joinGroupWithConfirmation({
  required BuildContext context,
  required WidgetRef ref,
  required String groupCode,
  String? groupName,
}) async {
  final displayName = groupName ?? groupCode;

  final confirmed = await showSubbyDialog<bool>(
    context: context,
    title: '그룹 참여하기',
    description: '"$displayName" 그룹에 참여하시겠습니까?',
    actions: [
      SubbyDialogAction(
        label: '취소',
        onPressed: () => Navigator.pop(context, false),
      ),
      SubbyDialogAction(
        label: '참여하기',
        isPrimary: true,
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  );

  if (confirmed != true || !context.mounted) return false;

  final joinGroup = ref.read(joinGroupUseCaseProvider);
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final homeViewModel = ref.read(homeViewModelProvider.notifier);

  final (result, group) = await joinGroup(groupCode);

  if (!context.mounted) return false;

  switch (result) {
    case JoinGroupResult.success:
      final resultGroupName = group?.effectiveName ?? '그룹';
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('"$resultGroupName" 그룹에 참여했습니다')),
      );
      homeViewModel.selectGroup(groupCode);
      return true;

    case JoinGroupResult.alreadyJoined:
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('이미 참여 중인 그룹입니다')),
      );
      homeViewModel.selectGroup(groupCode);
      return false;

    case JoinGroupResult.notFound:
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('존재하지 않는 그룹입니다')),
      );
      return false;

    case JoinGroupResult.error:
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('그룹 참여 중 오류가 발생했습니다')),
      );
      return false;
  }
}
