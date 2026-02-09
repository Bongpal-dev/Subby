import 'package:cloud_functions/cloud_functions.dart';

enum SendInquiryResult {
  success,
  error,
}

class SendInquiryUseCase {
  final FirebaseFunctions _functions;

  SendInquiryUseCase({
    FirebaseFunctions? functions,
  }) : _functions = functions ?? FirebaseFunctions.instance;

  Future<SendInquiryResult> call({
    required String category,
    required String title,
    required String content,
    required String deviceModel,
    required String osVersion,
    required String appVersion,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendInquiry');
      final result = await callable.call({
        'category': category,
        'title': title,
        'content': content,
        'deviceModel': deviceModel,
        'osVersion': osVersion,
        'appVersion': appVersion,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      final success = data['success'] as bool;

      return success ? SendInquiryResult.success : SendInquiryResult.error;
    } on FirebaseFunctionsException catch (_) {
      return SendInquiryResult.error;
    } catch (_) {
      return SendInquiryResult.error;
    }
  }
}
