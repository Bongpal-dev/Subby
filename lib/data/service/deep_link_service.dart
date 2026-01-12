import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  Future<Uri?> getInitialLink() async {
    return await _appLinks.getInitialLink();
  }

  Stream<Uri> get onLink => _appLinks.uriLinkStream;
}
