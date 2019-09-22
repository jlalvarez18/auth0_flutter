part of auth0_flutter;

// String values: token, id_token, code
enum ResponseType { token, idToken, code }

class WebAuth {
  WebAuth._(
      {@required String clientId,
      @required String domain,
      @required MethodChannel channel})
      : _channel = channel,
        _arguments = {'clientId': clientId, 'domain': domain};

  final Map<String, dynamic> _arguments;
  final MethodChannel _channel;

  /// For redirect url instead of a custom scheme it will use `https` and iOS 9 Universal Links.
  /// Before enabling this flag you'll need to configure Universal Links
  WebAuth useUniversalLink(bool value) {
    _arguments['useUniversalLink'] = value;
    return this;
  }

  /// Specify a connection name to be used to authenticate.
  /// By default no connection is specified, so the hosted login page will be displayed
  WebAuth connection(String value) {
    _arguments['connection'] = value;
    return this;
  }

  /// Scopes that will be requested during auth
  /// a scope value like: `openid email`
  WebAuth scope(String value) {
    _arguments['scope'] = value;
    return this;
  }

  /// Provider scopes for oauth2/social connections. e.g. Facebook, Google etc
  /// oauth2/social comma separated scope list: `user_friends,email`
  WebAuth connectionScope(String value) {
    _arguments['connectionScope'] = value;
    return this;
  }

  /// State value that will be echoed after authentication
  /// in order to check that the response is from your request and not other.
  /// By default a random value is used.
  WebAuth state(String value) {
    _arguments['state'] = value;
    return this;
  }

  /// Send additional parameters for authentication.
  WebAuth parameters(Map<String, String> value) {
    _arguments['parameters'] = value;
    return this;
  }

  /// Setup the response types to be used for authentcation
  WebAuth responseType(List<ResponseType> value) {
    _arguments['responseType'] = value.map((v) => _responseTypeToString(v));
    return this;
  }

  /// Add nonce paramater for authentication, this is a requirement for
  /// when response type .id_token is specified.
  WebAuth nonce(String value) {
    _arguments['nonce'] = value;
    return this;
  }

  ///  Audience name of the API that your application will call using the `access_token` returned after Auth.
  ///  This value must match the one defined in Auth0 Dashboard [APIs Section](https://manage.auth0.com/#/apis)
  WebAuth audience(String value) {
    _arguments['audience'] = value;
    return this;
  }

  Future<Credentials> start() async {
    final Map<String, dynamic> result =
        await _channel.invokeMapMethod('web_auth_start', _arguments);

    return Credentials.fromJSON(result);
  }

  Future<bool> clearSession(bool federated) async {
    final arguments = {'federated': federated};

    final bool result =
        await _channel.invokeMethod('web_auth_clear_session', arguments);

    return result;
  }
}

String _responseTypeToString(ResponseType type) {
  switch (type) {
    case ResponseType.token:
      return 'token';
    case ResponseType.idToken:
      return 'idToken';
    case ResponseType.code:
      return 'code';
  }

  return '';
}
