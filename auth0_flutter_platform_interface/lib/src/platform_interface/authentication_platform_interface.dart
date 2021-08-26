import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/auth0_app.dart';
import '../models/credentials.dart';
import '../models/database_user.dart';
import '../models/profile.dart';
import '../models/user_info.dart';
import '../platform_interface/web_auth_platform_interface.dart';

// String types code, link, link_ios, link_android
enum PasswordlessType { code, link, iosLink, androidLink }

abstract class AuthenticationPlatform extends PlatformInterface {
  final Auth0App app;

  AuthenticationPlatform({required this.app}) : super(token: _token);

  static final Object _token = Object();

  static AuthenticationPlatform? _instance;

  static AuthenticationPlatform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError('AuthenticationPlatform.instance has not been set.');
  }

  static set instance(AuthenticationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  AuthenticationPlatform logging({required bool enabled}) {
    throw UnimplementedError('logging() has not been implemented.');
  }

  Future<Credentials> login({
    required String usernameOrEmail,
    required String password,
    required String realm,
    String? audience,
    String? scope,
    Map<String, String>? parameters,
  }) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<Credentials> loginWithOTP(String otp, {required String mfaToken}) {
    throw UnimplementedError('loginWithOTP() has not been implemented.');
  }

  Future<Credentials> loginDefaultDirectory({
    required String username,
    required String password,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) {
    throw UnimplementedError(
        'loginDefaultDirectory() has not been implemented.');
  }

  Future<DatabaseUser> createUser({
    required String email,
    String? username,
    required String password,
    required String connection,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? rootAttributes,
  }) {
    throw UnimplementedError('createUser() has not been implemented.');
  }

  Future<void> resetPassword({
    required String email,
    required String connection,
  }) {
    throw UnimplementedError('resetPassword() has not been implemented.');
  }

  Future<void> startEmailPasswordless({
    required String email,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'email',
    required Map<String, dynamic> parameters,
  }) {
    throw UnimplementedError(
        'startEmailPasswordless() has not been implemented.');
  }

  Future<Credentials> loginWithEmailPasswordless({
    required String email,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) {
    throw UnimplementedError(
        'loginWithEmailPasswordless() has not been implemented.');
  }

  Future<void> startPhoneNumberPasswordless({
    required String phoneNumber,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'sms',
  }) {
    throw UnimplementedError(
        'startPhoneNumberPasswordless() has not been implemented.');
  }

  Future<Credentials> loginWithPhoneNumberPasswordless({
    required String phoneNumber,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) {
    throw UnimplementedError(
        'loginWithPhoneNumberPasswordless() has not been implemented.');
  }

  /// Returns user information by performing a request to /userinfo endpoint.
  /// - warning: for OIDC-conformant clients please use `userInfo(withAccessToken accessToken:)`
  @Deprecated(
      'Please use userInfoWithAccessToken. OIDC conformance is now default.')
  Future<Profile> userInfoWithToken(String token) async {
    throw AssertionError();
  }

  /// Returns OIDC standard claims information by performing a request
  ///  to /userinfo endpoint.
  /// - important: This method should be used for OIDC Conformant clients.
  Future<UserInfo> userInfoWithAccessToken(String accessToken) {
    throw AssertionError();
  }

  @Deprecated('Use loginFacebook for Facebook login instead')
  Future<Credentials> loginSocial({
    required String token,
    required String connection,
    String scope = 'openid',
    required Map<String, dynamic> parameters,
  }) async {
    throw AssertionError();
  }

  Future<Credentials> loginFacebook({
    required String sessionAccessToken,
    required Map<String, dynamic> profile,
    String scope = 'openid profile offline_access',
    String? audience,
  }) {
    throw UnimplementedError('loginFacebook() has not been implemented.');
  }

  Future<Credentials> tokenExchangeWithParameters({
    required Map<String, dynamic> parameters,
  }) {
    throw UnimplementedError(
        'tokenExchangeWithParameters() has not been implemented.');
  }

  Future<Credentials> tokenExchangeWithCode({
    required String code,
    required String codeVerifier,
    required String redirectURI,
  }) {
    throw UnimplementedError(
        'tokenExchangeWithCode() has not been implemented.');
  }

  Future<Credentials> appleTokenExchange({
    required String authCode,
    String? scope,
    String? audience,
  }) {
    throw UnimplementedError('appleTokenExchange() has not been implemented.');
  }

  Future<Credentials> renew({
    required String refreshToken,
    String? scope,
  }) {
    throw UnimplementedError('renew() has not been implemented.');
  }

  Future<void> revoke({required String refreshToken}) {
    throw UnimplementedError('revoke() has not been implemented.');
  }

  Future<Map<String, dynamic>> delegation({
    required Map<String, dynamic> parameters,
  }) {
    throw UnimplementedError('delegation() has not been implemented.');
  }

  WebAuthPlatform webAuthWithConnection(String connection) {
    throw UnimplementedError(
        'webAuthWithConnection() has not been implemented.');
  }
}
