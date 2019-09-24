part of auth0_flutter;

// String types code, link, link_ios, link_android
enum PasswordlessType { code, link, iosLink, androidLink }

String _passwordlessTypeToString(PasswordlessType type) {
  switch (type) {
    case PasswordlessType.code:
      return 'code';
    case PasswordlessType.link:
      return 'link';
    case PasswordlessType.iosLink:
      return 'link_ios';
    case PasswordlessType.androidLink:
      return 'link_android';
  }

  return '';
}

class Authentication {
  final String clientId;
  final String domain;
  final MethodChannel _channel;

  Authentication._(
      {@required this.clientId, @required this.domain, MethodChannel channel})
      : _channel = channel;

  Future<Credentials> login(
      {@required String usernameOrEmail,
      @required String password,
      @required String realm,
      String audience,
      String scope,
      Map<String, dynamic> parameters}) async {
    final args = <String, dynamic>{
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'realm': realm,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.login, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<Credentials> loginWithOTP(String otp,
      {@required String mfaToken}) async {
    assert(otp != null);

    final args = {'otp': otp, 'mfaToken': mfaToken};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.loginWithOTP, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<Credentials> loginDefaultDirectory(
      {@required String username,
      @required String password,
      String audience,
      String scope,
      Map<String, dynamic> parameters}) async {
    final args = <String, dynamic>{
      'username': username,
      'password': password,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.loginDefaultDirectory, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<DatabaseUser> createUser(
      {@required String email,
      String username,
      @required String password,
      @required String connection,
      Map<String, dynamic> userMetadata,
      Map<String, dynamic> rootAttributes}) async {
    final args = <String, dynamic>{
      'email': email,
      'username': username,
      'password': password,
      'connection': connection,
      'userMetadata': userMetadata,
      'rootAttributes': rootAttributes
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.createUser, args);

    _processJSONForErrors(result);

    return DatabaseUser.fromJSON(result);
  }

  Future<void> resetPassword(
      {@required String email, @required String connection}) async {
    final args = {'email': email, 'connection': connection};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.resetPassword, args);

    _processJSONForErrors(result);
  }

  Future<void> startEmailPasswordless(
      {@required String email,
      PasswordlessType type = PasswordlessType.code,
      String connection = 'email',
      Map<String, dynamic> parameters}) async {
    final args = <String, dynamic>{
      'email': email,
      'type': _passwordlessTypeToString(type),
      'connection': connection,
      'parameters': parameters
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.startEmailPasswordless, args);

    _processJSONForErrors(result);
  }

  Future<void> startPhoneNumberPasswordless(
      {@required String phoneNumber,
      PasswordlessType type = PasswordlessType.code,
      String connection = 'sms'}) async {
    final args = {
      'phoneNumber': phoneNumber,
      'type': _passwordlessTypeToString(type),
      'connection': connection
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.startPhoneNumberPasswordless, args);

    _processJSONForErrors(result);
  }

  /// Returns user information by performing a request to /userinfo endpoint.
  /// - warning: for OIDC-conformant clients please use `userInfo(withAccessToken accessToken:)`
  Future<Profile> userInfoWithToken(String token) async {
    final args = {'token': token};

    final result = await _channel.invokeMapMethod<String, dynamic>(
      AuthenticationMethod.userInfoWithToken,
      args,
    );

    _processJSONForErrors(result);

    return Profile.fromJSON(result);
  }

  /// Returns OIDC standard claims information by performing a request
  ///  to /userinfo endpoint.
  /// - important: This method should be used for OIDC Conformant clients.
  Future<UserInfo> userInfoWithAccessToken(String accessToken) async {
    final args = {'accessToken': accessToken};

    final result = await _channel.invokeMapMethod<String, dynamic>(
      AuthenticationMethod.userInfoWithAccessToken,
      args,
    );

    _processJSONForErrors(result);

    return UserInfo.fromJSON(result);
  }

  Future<Credentials> loginSocial(
      {@required String token,
      @required String connection,
      String scope = 'openid',
      Map<String, dynamic> parameters}) async {
    final args = {
      'token': token,
      'connection': connection,
      'scope': scope,
      'parameters': parameters
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.loginSocial, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<Credentials> tokenExchangeWithParameters(
      Map<String, dynamic> parameters) async {
    final args = {'parameters': parameters};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.tokenExchangeWithParameters, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<Credentials> tokenExchangeWithCode(String code,
      {String codeVerifier, String redirectURI}) async {
    final args = {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectURI': redirectURI
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.tokenExchangeWithCode, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  void appleTokenExchange(
      {@required String authCode, String scope, String audience}) {}

  Future<Credentials> renew(
      {@required String refreshToken, String scope}) async {
    final args = {'refreshToken': refreshToken, 'scope': scope};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.renew, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }

  Future<void> revoke({String refreshToken}) async {
    final args = {'refreshToken': refreshToken};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.revoke, args);

    _processJSONForErrors(result);
  }

  Future<Map<String, dynamic>> delegation(
      Map<String, dynamic> parameters) async {
    final args = {'parameters': parameters};

    final result = await _channel.invokeMapMethod<String, dynamic>(
        AuthenticationMethod.delegation, args);

    _processJSONForErrors(result);

    return result;
  }

  WebAuth webAuthWithConnection(String connection) {
    return WebAuth._(clientId: clientId, domain: domain, channel: _channel)
        .connection(connection);
  }
}
