class Auth0Method {
  static const getPlatformVersion = 'getPlatformVersion';

  Auth0Method._();
}

class WebAuthMethod {
  static const start = 'start';
  static const clearSession = 'clearSession';

  WebAuthMethod._();
}

class AuthenticationMethod {
  static const login = 'login';
  static const loginWithOTP = 'loginWithOtp';
  static const loginDefaultDirectory = 'loginDefaultDirectory';
  static const createUser = 'createUser';
  static const resetPassword = 'resetPassword';
  static const startEmailPasswordless = 'startEmailPasswordless';
  static const startPhoneNumberPasswordless = 'startPhoneNumberPasswordless';
  static const userInfoWithToken = 'userInfoWithToken';
  static const userInfoWithAccessToken = 'userInfoWithAccessToken';
  static const loginSocial = 'loginSocial';
  static const tokenExchangeWithParameters = 'tokenExchangeWithParams';
  static const tokenExchangeWithCode = 'tokenExchangeWithCode';
  static const appleTokenExchange = 'appleTokenExchange';
  static const renew = 'renew';
  static const revoke = 'revoke';
  static const delegation = 'delegation';

  AuthenticationMethod._();
}

class CredentialsManagerMethod {
  static const enableBioMetrics = 'enableBioMetrics';
  static const storeCredentials = 'storeCredentials';
  static const clearCredentials = 'clearCredentials';
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
