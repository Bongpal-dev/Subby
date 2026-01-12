class InviteLinkGenerator {
  static const _scheme = 'subby';
  static const _host = 'join';
  static const _codeParam = 'code';
  static const _webHost = 'subby-91b88.web.app';

  /// 공유용 HTTPS 링크 생성
  static String generate(String groupCode) {
    return 'https://$_webHost/join?$_codeParam=$groupCode';
  }

  /// 앱 내부용 딥링크 생성
  static String generateDeepLink(String groupCode) {
    return '$_scheme://$_host?$_codeParam=$groupCode';
  }

  /// 딥링크에서 그룹 코드 파싱
  static String? parseGroupCode(Uri uri) {
    // subby:// 스킴
    if (uri.scheme == _scheme && uri.host == _host) {
      return uri.queryParameters[_codeParam];
    }

    // https:// 웹 링크
    if (uri.scheme == 'https' && uri.host == _webHost && uri.path == '/join') {
      return uri.queryParameters[_codeParam];
    }

    return null;
  }
}
