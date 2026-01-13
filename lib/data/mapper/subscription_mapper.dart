import 'package:subby/data/dto/subscription_dto.dart';
import 'package:subby/data/response/subscription_response.dart';
import 'package:subby/domain/model/user_subscription.dart';

extension SubscriptionDtoToDomain on SubscriptionDto {
  UserSubscription toDomain() {
    return UserSubscription(
      id: id,
      groupCode: groupCode,
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      period: period,
      category: category,
      memo: memo,
      feeRatePercent: feeRatePercent,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserSubscriptionToDto on UserSubscription {
  SubscriptionDto toDto() {
    return SubscriptionDto(
      id: id,
      groupCode: groupCode,
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      period: period,
      category: category,
      memo: memo,
      feeRatePercent: feeRatePercent,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension SubscriptionResponseToDto on SubscriptionResponse {
  SubscriptionDto toDto() {
    return SubscriptionDto(
      id: id,
      groupCode: groupCode,
      name: name,
      amount: amount,
      currency: currency,
      billingDay: billingDay,
      period: period,
      category: category,
      memo: memo,
      feeRatePercent: feeRatePercent,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: updatedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(updatedAt!)
          : null,
    );
  }
}
