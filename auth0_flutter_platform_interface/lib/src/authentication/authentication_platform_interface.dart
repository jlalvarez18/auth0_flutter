import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../credentials/credentials.dart';
import '../web_auth/web_auth_platform_interface.dart';
import 'database_user.dart';
import 'profile.dart';
import 'user_info.dart';

// String types code, link, link_ios, link_android
enum PasswordlessType { code, link, iosLink, androidLink }

abstract class AuthenticationPlatform extends PlatformInterface {
  final String clientId;
  final String domain;

  AuthenticationPlatform({
    required this.clientId,
    required this.domain,
  }) : super(token: _token);

  static final Object _token = Object();

  AuthenticationPlatform logging({required bool enabled});

  Future<Credentials> login({
    required String usernameOrEmail,
    required String password,
    required String realm,
    String? audience,
    String? scope,
    Map<String, String>? parameters,
  });

  Future<Credentials> loginWithOTP(String otp, {required String mfaToken});

  Future<Credentials> loginDefaultDirectory({
    required String username,
    required String password,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  });

  Future<DatabaseUser> createUser({
    required String email,
    String? username,
    required String password,
    required String connection,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? rootAttributes,
  });

  Future<void> resetPassword({
    required String email,
    required String connection,
  });

  Future<void> startEmailPasswordless({
    required String email,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'email',
    required Map<String, dynamic> parameters,
  });

  Future<Credentials> loginWithEmailPasswordless({
    required String email,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  });

  Future<void> startPhoneNumberPasswordless({
    required String phoneNumber,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'sms',
  });

  Future<Credentials> loginWithPhoneNumberPasswordless({
    required String phoneNumber,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  });

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
  });

  Future<Credentials> tokenExchangeWithParameters({
    required Map<String, dynamic> parameters,
  });

  Future<Credentials> tokenExchangeWithCode({
    required String code,
    required String codeVerifier,
    required String redirectURI,
  });

  Future<Credentials> appleTokenExchange({
    required String authCode,
    String? scope,
    String? audience,
  });

  Future<Credentials> renew({
    required String refreshToken,
    String? scope,
  });

  Future<void> revoke({required String refreshToken});

  Future<Map<String, dynamic>> delegation({
    required Map<String, dynamic> parameters,
  });

  WebAuthPlatform webAuthWithConnection(String connection);
}
