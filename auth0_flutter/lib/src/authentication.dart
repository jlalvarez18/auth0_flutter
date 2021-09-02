part of auth0_flutter;

class Authentication {
  Authentication._();

  AuthenticationPlatform? _delegatePackingProperty;

  AuthenticationPlatform get _delegate {
    _delegatePackingProperty ??= AuthenticationPlatform.instance;

    return _delegatePackingProperty!;
  }

  static Authentication _instance = Authentication._();
  static Authentication get instance => _instance;

  AuthenticationPlatform logging({required bool enabled}) =>
      _delegate.logging(enabled: enabled);

  Future<Credentials> login({
    required String usernameOrEmail,
    required String password,
    required String realm,
    String? audience,
    String? scope,
    Map<String, String>? parameters,
  }) =>
      _delegate.login(
        usernameOrEmail: usernameOrEmail,
        password: password,
        realm: realm,
        audience: audience,
        scope: scope,
        parameters: parameters,
      );

  Future<Credentials> loginWithOTP(String otp, {required String mfaToken}) =>
      _delegate.loginWithOTP(otp, mfaToken: mfaToken);

  Future<Credentials> loginDefaultDirectory({
    required String username,
    required String password,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) =>
      _delegate.loginDefaultDirectory(
        username: username,
        password: password,
        audience: audience,
        scope: scope,
        parameters: parameters,
      );

  Future<DatabaseUser> createUser({
    required String email,
    required String password,
    required String connection,
    String? username,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? rootAttributes,
  }) =>
      _delegate.createUser(
        email: email,
        password: password,
        connection: connection,
        username: username,
        userMetadata: userMetadata,
        rootAttributes: rootAttributes,
      );

  Future<void> resetPassword({
    required String email,
    required String connection,
  }) =>
      _delegate.resetPassword(email: email, connection: connection);

  Future<void> startEmailPasswordless({
    required String email,
    required Map<String, dynamic> parameters,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'email',
  }) =>
      _delegate.startEmailPasswordless(
        email: email,
        parameters: parameters,
        type: type,
        connection: connection,
      );

  Future<Credentials> loginWithEmailPasswordless({
    required String email,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) =>
      _delegate.loginWithEmailPasswordless(
        email: email,
        otpCode: otpCode,
        audience: audience,
        scope: scope,
        parameters: parameters,
      );

  Future<void> startPhoneNumberPasswordless({
    required String phoneNumber,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'sms',
  }) =>
      _delegate.startPhoneNumberPasswordless(
        phoneNumber: phoneNumber,
        type: type,
        connection: connection,
      );

  Future<Credentials> loginWithPhoneNumberPasswordless({
    required String phoneNumber,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) =>
      _delegate.loginWithPhoneNumberPasswordless(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
        audience: audience,
        scope: scope,
        parameters: parameters,
      );

  /// Returns user information by performing a request to /userinfo endpoint.
  /// - warning: for OIDC-conformant clients please use `userInfo(withAccessToken accessToken:)`
  @Deprecated(
      'Please use userInfoWithAccessToken. OIDC conformance is now default.')
  Future<Profile> userInfoWithToken(String token) =>
      _delegate.userInfoWithToken(token);

  /// Returns OIDC standard claims information by performing a request
  ///  to /userinfo endpoint.
  /// - important: This method should be used for OIDC Conformant clients.
  Future<UserInfo> userInfoWithAccessToken(String accessToken) =>
      _delegate.userInfoWithAccessToken(accessToken);

  @Deprecated('Use loginFacebook for Facebook login instead')
  Future<Credentials> loginSocial({
    required String token,
    required String connection,
    required Map<String, dynamic> parameters,
    String scope = 'openid',
  }) async {
    throw AssertionError('Use loginFacebook for Facebook login instead');
  }

  Future<Credentials> loginFacebook({
    required String sessionAccessToken,
    required Map<String, dynamic> profile,
    String scope = 'openid profile offline_access',
    String? audience,
  }) =>
      _delegate.loginFacebook(
        sessionAccessToken: sessionAccessToken,
        profile: profile,
        scope: scope,
        audience: audience,
      );

  Future<Credentials> tokenExchangeWithParameters({
    required Map<String, dynamic> parameters,
  }) =>
      _delegate.tokenExchangeWithParameters(parameters: parameters);

  Future<Credentials> tokenExchangeWithCode({
    required String code,
    required String codeVerifier,
    required String redirectURI,
  }) =>
      _delegate.tokenExchangeWithCode(
        code: code,
        codeVerifier: codeVerifier,
        redirectURI: redirectURI,
      );

  Future<Credentials> appleTokenExchange({
    required String authCode,
    String? scope,
    String? audience,
  }) =>
      _delegate.appleTokenExchange(
        authCode: authCode,
        scope: scope,
        audience: audience,
      );

  Future<Credentials> renew({
    required String refreshToken,
    String? scope,
  }) =>
      _delegate.renew(
        refreshToken: refreshToken,
        scope: scope,
      );

  Future<void> revoke({required String refreshToken}) =>
      _delegate.revoke(refreshToken: refreshToken);

  Future<Map<String, dynamic>> delegation({
    required Map<String, dynamic> parameters,
  }) =>
      _delegate.delegation(parameters: parameters);

  WebAuthPlatform webAuthWithConnection(String connection) =>
      _delegate.webAuthWithConnection(connection);
}
