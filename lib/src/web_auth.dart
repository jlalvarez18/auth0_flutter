part of auth0_flutter;

// String values: token, id_token, code
enum ResponseType { token, idToken, code }

class WebAuth {
  /// id of your Auth0 client
  final String clientId;

  /// name of your Auth0 domain
  final String domain;

  /// For redirect url instead of a custom scheme it will use `https` and iOS 9 Universal Links.
  /// Before enabling this flag you'll need to configure Universal Links
  bool useUniversalLink = false;

  /// Specify a connection name to be used to authenticate.
  /// By default no connection is specified, so the hosted login page will be displayed
  String connection;

  /// Scopes that will be requested during auth
  /// a scope value like: `openid email`
  String scope;

  /// Provider scopes for oauth2/social connections. e.g. Facebook, Google etc
  /// oauth2/social comma separated scope list: `user_friends,email`
  String connectionScope;

  /// State value that will be echoed after authentication
  /// in order to check that the response is from your request and not other.
  /// By default a random value is used.
  String state;

  /// Send additional parameters for authentication.
  Map<String, String> parameters;

  /// Setup the response types to be used for authentcation
  List<ResponseType> responseType;

  /// Add nonce paramater for authentication, this is a requirement for
  /// when response type .id_token is specified.
  String nonce;

  ///  Audience name of the API that your application will call using the `access_token` returned after Auth.
  ///  This value must match the one defined in Auth0 Dashboard [APIs Section](https://manage.auth0.com/#/apis)
  String audience;

  final MethodChannel _channel;

  WebAuth._(
      {@required this.clientId, @required this.domain, MethodChannel channel})
      : _channel = channel;

  Future<Credentials> start() async {
    final arguments = _arguments();

    final Map<String, dynamic> result =
        await _channel.invokeMapMethod('web_auth_start', arguments);

    return Credentials.fromJSON(result);
  }

  Future<bool> clearSession(bool federated) async {
    final arguments = {'federated': federated};

    final bool result =
        await _channel.invokeMethod('web_auth_clear_session', arguments);

    return result;
  }

  Map<String, dynamic> _arguments() {
    return <String, dynamic>{
      'clientId': clientId,
      'domain': domain,
      'useUniversalLink': useUniversalLink,
      'connection': connection,
      'scope': scope,
      'connectionScope': connectionScope,
      'state': state,
      'parameters': parameters,
      'responseType': responseType.map((v) => _responseTypeToString(v)),
      'nonce': nonce,
      'audience': audience
    };
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
