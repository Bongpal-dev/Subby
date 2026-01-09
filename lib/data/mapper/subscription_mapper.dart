import 'package:subby/data/dto/subscription_dto.dart';
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
    );
  }
}
