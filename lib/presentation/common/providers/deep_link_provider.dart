import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subby/data/service/deep_link_service.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService();
});

final initialDeepLinkProvider = FutureProvider<Uri?>((ref) async {
  final service = ref.watch(deepLinkServiceProvider);

  return await service.getInitialLink();
});

final deepLinkStreamProvider = StreamProvider<Uri>((ref) {
  final service = ref.watch(deepLinkServiceProvider);

  return service.onLink;
});
