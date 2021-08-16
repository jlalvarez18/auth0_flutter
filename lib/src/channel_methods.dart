import 'package:flutter/foundation.dart';

class Auth0Method {
  static const getPlatformVersion = 'getPlatformVersion';

  Auth0Method._();
}

class WebAuthMethod {
  static const start = 'start';
  static const clearSession = 'clearSession';

  WebAuthMethod._();
}

enum AuthenticationMethod {
  login,
  loginWithOTP,
  loginDefaultDirectory,
  createUser,
  resetPassword,
  startEmailPasswordless,
  startPhoneNumberPasswordless,
  loginEmailPasswordless,
  loginPhoneNumberPasswordless,
  userInfoWithAccessToken,
  loginWithNativeSocialToken,
  loginFacebook,
  tokenExchangeWithParameters,
  tokenExchangeWithCode,
  appleTokenExchange,
  renew,
  revoke,
  delegation,
}

extension AuthenticationMethodExt on AuthenticationMethod {
  String get stringValue {
    return describeEnum(this);
  }
}

class CredentialsManagerMethod {
  static const enableBioMetrics = 'enableBioMetrics';
  static const storeCredentials = 'storeCredentials';
  static const clearCredentials = 'clearCredentials';
  static const revokeCredentials = 'revokeCredentials';
  static const hasValidCredentials = 'hasValidCredentials';
  static const getCredentials = 'getCredentials';

  CredentialsManagerMethod._();
}

class UsersMethod {
  static const get = 'get';
  static const patchAttributes = 'patchAttributes';
  static const patchUserMetadata = 'patchUserMetadata';
  static const linkWithOtherUserToken = 'linkWithOtherUserToken';
  static const linkWithUserId = 'linkWithUserId';
  static const unlink = 'unlink';

  UsersMethod._();
}
