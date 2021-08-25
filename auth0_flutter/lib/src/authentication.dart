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
}

class Authentication {
  static const _channel =
      const MethodChannel('plugins.auth0_flutter.io/authentication');

  AuthenticationError _errorHandler(PlatformException e) =>
      AuthenticationError.from(e);

  final String clientId;
  final String domain;

  bool _loggingEnabled = false;

  Authentication._({required this.clientId, required this.domain});

  /// Turn on/off Auth0.swift debug logging of HTTP requests and OAuth2 flow (iOS only).
  Authentication logging({required bool enabled}) {
    _loggingEnabled = enabled;
    return this;
  }

  Future<Credentials> login({
    required String usernameOrEmail,
    required String password,
    required String realm,
    String? audience,
    String? scope,
    Map<String, String>? parameters,
  }) async {
    final args = _generateArguments({
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'realm': realm,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.login,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> loginWithOTP(String otp,
      {required String mfaToken}) async {
    final args = _generateArguments({'otp': otp, 'mfaToken': mfaToken});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginWithOTP,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> loginDefaultDirectory({
    required String username,
    required String password,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'username': username,
      'password': password,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginDefaultDirectory,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<DatabaseUser> createUser({
    required String email,
    String? username,
    required String password,
    required String connection,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? rootAttributes,
  }) async {
    final args = _generateArguments({
      'email': email,
      'username': username,
      'password': password,
      'connection': connection,
      'userMetadata': userMetadata,
      'rootAttributes': rootAttributes
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.createUser,
      args,
    );

    return DatabaseUser.fromJSON(result);
  }

  Future<void> resetPassword({
    required String email,
    required String connection,
  }) async {
    final args = _generateArguments({'email': email, 'connection': connection});

    await _invokeMethod(
      AuthenticationMethod.resetPassword,
      args,
    );
  }

  Future<void> startEmailPasswordless({
    required String email,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'email',
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({
      'email': email,
      'type': _passwordlessTypeToString(type),
      'connection': connection,
      'parameters': parameters,
    });

    await _invokeMethod(
      AuthenticationMethod.startEmailPasswordless,
      args,
    );
  }

  Future<Credentials> loginWithEmailPasswordless({
    required String email,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'email': email,
      'code': otpCode,
      'audience': audience,
      'scope': scope,
      'parameters': parameters ?? {},
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginEmailPasswordless,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<void> startPhoneNumberPasswordless({
    required String phoneNumber,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'sms',
  }) async {
    final args = _generateArguments({
      'phoneNumber': phoneNumber,
      'type': _passwordlessTypeToString(type),
      'connection': connection
    });

    await _invokeMethod(
      AuthenticationMethod.startPhoneNumberPasswordless,
      args,
    );
  }

  Future<Credentials> loginWithPhoneNumberPasswordless({
    required String phoneNumber,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'phoneNumber': phoneNumber,
      'code': otpCode,
      'audience': audience,
      'scope': scope,
      'parameters': parameters ?? {},
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginPhoneNumberPasswordless,
      args,
    );

    return Credentials.fromJSON(result);
  }

  /// Returns user information by performing a request to /userinfo endpoint.
  /// - warning: for OIDC-conformant clients please use `userInfo(withAccessToken accessToken:)`
  @Deprecated(
      'Please use userInfoWithAccessToken. OIDC conformance is now default.')
  Future<Profile> userInfoWithToken(String token) async {
    throw PlatformException(code: 'code');
  }

  /// Returns OIDC standard claims information by performing a request
  ///  to /userinfo endpoint.
  /// - important: This method should be used for OIDC Conformant clients.
  Future<UserInfo> userInfoWithAccessToken(String accessToken) async {
    final args = _generateArguments({'accessToken': accessToken});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.userInfoWithAccessToken,
      args,
    );

    return UserInfo.fromJSON(result);
  }

  @Deprecated('Use loginFacebook for Facebook login instead')
  Future<Credentials> loginSocial({
    required String token,
    required String connection,
    String scope = 'openid',
    required Map<String, dynamic> parameters,
  }) async {
    throw PlatformException(code: '');
  }

  Future<Credentials> loginFacebook({
    required String sessionAccessToken,
    required Map<String, dynamic> profile,
    String scope = 'openid profile offline_access',
    String? audience,
  }) async {
    final args = _generateArguments({
      'sessionAccessToken': sessionAccessToken,
      'profile': profile,
      'scope': scope,
      'audience': audience,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginFacebook,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> tokenExchangeWithParameters({
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({'parameters': parameters});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.tokenExchangeWithParameters,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> tokenExchangeWithCode({
    required String code,
    required String codeVerifier,
    required String redirectURI,
  }) async {
    final args = _generateArguments({
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectURI': redirectURI
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.tokenExchangeWithCode,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> appleTokenExchange({
    required String authCode,
    String? scope,
    String? audience,
  }) async {
    final args = _generateArguments({
      'authCode': authCode,
      'scope': scope,
      'audience': audience,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.appleTokenExchange,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<Credentials> renew({
    required String refreshToken,
    String? scope,
  }) async {
    final args = _generateArguments({
      'refreshToken': refreshToken,
      'scope': scope,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.renew,
      args,
    );

    return Credentials.fromJSON(result);
  }

  Future<void> revoke({required String refreshToken}) async {
    final args = _generateArguments({'refreshToken': refreshToken});

    await _invokeMethod(
      AuthenticationMethod.revoke,
      args,
    );
  }

  Future<Map<String, dynamic>> delegation({
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({'parameters': parameters});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.delegation,
      args,
    );

    return result;
  }

  WebAuth webAuthWithConnection(String connection) {
    return WebAuth._(clientId: clientId, domain: domain).connection(connection);
  }

  Map<String, dynamic> _generateArguments(Map<String, dynamic>? other) {
    final args = <String, dynamic>{
      'clientId': clientId,
      'domain': domain,
      'loggingEnabled': _loggingEnabled,
    };

    if (other != null) {
      args.addAll(other);
    }

    return args;
  }

  Future<Map<K, V>> _invokeMapMethod<K, V>(
      AuthenticationMethod method, dynamic arguments) async {
    final value = await invokeMapMethod<K, V>(
      channel: _channel,
      method: method.stringValue,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    if (value == null) {
      throw Exception('Unknown Error');
    }

    return value;
  }

  Future<void> _invokeMethod(
    AuthenticationMethod method,
    dynamic arguments,
  ) async {
    return invokeMethod(
      channel: _channel,
      method: method.stringValue,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );
  }
}
