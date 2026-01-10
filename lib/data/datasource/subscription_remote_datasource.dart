import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subby/data/dto/subscription_dto.dart';
import 'package:subby/data/mapper/subscription_mapper.dart';
import 'package:subby/data/response/subscription_response.dart';

class SubscriptionRemoteDataSource {
  final FirebaseFirestore _firestore;

  SubscriptionRemoteDataSource() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _subscriptionsRef(
    String groupCode,
  ) =>
      _firestore.collection('groups').doc(groupCode).collection('subscriptions');

  Future<void> saveSubscription(SubscriptionDto dto) async {
    final response = SubscriptionResponse(
      id: dto.id,
      groupCode: dto.groupCode,
      name: dto.name,
      amount: dto.amount,
      currency: dto.currency,
      billingDay: dto.billingDay,
      period: dto.period,
      category: dto.category,
      memo: dto.memo,
      feeRatePercent: dto.feeRatePercent,
      createdAt: dto.createdAt.millisecondsSinceEpoch,
    );

    await _subscriptionsRef(dto.groupCode).doc(dto.id).set(response.toJson());
  }

  Future<SubscriptionDto?> getSubscription(
    String groupCode,
    String subscriptionId,
  ) async {
    final doc = await _subscriptionsRef(groupCode).doc(subscriptionId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    final response = SubscriptionResponse.fromJson(doc.data()!);

    return response.toDto();
  }

  Future<void> deleteSubscription(
    String groupCode,
    String subscriptionId,
  ) async {
    await _subscriptionsRef(groupCode).doc(subscriptionId).delete();
  }
}
