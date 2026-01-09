import 'package:subby/domain/model/pending_change.dart';

abstract class PendingChangeRepository {
  Future<List<PendingChange>> getAll();
  Future<PendingChange?> getByEntityId(String entityId);
  Future<void> save(PendingChange change);
  Future<void> delete(String entityId);
  Future<void> deleteAll();
}
