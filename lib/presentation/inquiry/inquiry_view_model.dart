import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:subby/core/di/providers.dart';
import 'package:subby/domain/usecase/send_inquiry_usecase.dart';

class InquiryState {
  final String category;
  final String title;
  final String content;
  final bool isSending;

  const InquiryState({
    this.category = '',
    this.title = '',
    this.content = '',
    this.isSending = false,
  });

  InquiryState copyWith({
    String? category,
    String? title,
    String? content,
    bool? isSending,
  }) {
    return InquiryState(
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      isSending: isSending ?? this.isSending,
    );
  }
}

class InquiryViewModel extends AutoDisposeNotifier<InquiryState> {
  @override
  InquiryState build() {
    return const InquiryState();
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setContent(String content) {
    state = state.copyWith(content: content);
  }

  Future<SendInquiryResult> send() async {
    state = state.copyWith(isSending: true);

    try {
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel;
      String osVersion;

      if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        deviceModel = '${android.manufacturer} ${android.model}';
        osVersion = 'Android ${android.version.release}';
      } else if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        deviceModel = ios.utsname.machine;
        osVersion = '${ios.systemName} ${ios.systemVersion}';
      } else {
        deviceModel = 'Unknown';
        osVersion = 'Unknown';
      }

      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';

      final useCase = ref.read(sendInquiryUseCaseProvider);
      final result = await useCase(
        category: state.category,
        title: state.title,
        content: state.content,
        deviceModel: deviceModel,
        osVersion: osVersion,
        appVersion: appVersion,
      );

      state = state.copyWith(isSending: false);
      return result;
    } catch (_) {
      state = state.copyWith(isSending: false);
      return SendInquiryResult.error;
    }
  }
}

final inquiryViewModelProvider =
    NotifierProvider.autoDispose<InquiryViewModel, InquiryState>(() {
  return InquiryViewModel();
});
