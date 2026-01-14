import 'package:firebase_database/firebase_database.dart';

import '../dto/exchange_rate_dto.dart';

class ExchangeRateRemoteDataSource {
  final DatabaseReference _dbRef;

  ExchangeRateRemoteDataSource()
      : _dbRef = FirebaseDatabase.instanceFor(
          app: FirebaseDatabase.instance.app,
          databaseURL:
              'https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app',
        ).ref();

  Future<ExchangeRateDto?> fetchExchangeRates() async {
    final snapshot = await _dbRef.child('exchange_rates').get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return ExchangeRateDto.fromJson(data);
  }
}
