class InviteLinkGenerator {
  static const _scheme = 'subby';
  static const _host = 'join';
  static const _codeParam = 'code';

  static String generate(String groupCode) {
    return '$_scheme://$_host?$_codeParam=$groupCode';
  }

  static String? parseGroupCode(Uri uri) {
    if (uri.scheme != _scheme || uri.host != _host) {
      return null;
    }

    return uri.queryParameters[_codeParam];
  }
}
