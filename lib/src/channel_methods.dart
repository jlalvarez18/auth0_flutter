class Auth0Method {
  static const resumeAuth = 'auth0.resumeAuth';
  static const getPlatformVersion = 'auth0.getPlatformVersion';

  Auth0Method._();
}

class WebAuthMethod {
  static const start = 'webAuth.start';
  static const clearSession = 'webAuth.clearSession';

  WebAuthMethod._();
}

class AuthenticationMethod {
  static const login = 'authentication.login';
  static const loginWithOTP = 'authentication.loginWithOtp';
  static const loginDefaultDirectory = 'authentication.loginDefaultDirectory';
  static const createUser = 'authentication.createUser';
  static const resetPassword = 'authentication.resetPassword';
  static const startEmailPasswordless = 'authentication.startEmailPasswordless';
  static const startPhoneNumberPasswordless =
      'authentication.startPhoneNumberPasswordless';
  static const userInfoWithToken = 'authentication.userInfoWithToken';
  static const userInfoWithAccessToken =
      'authentication.userInfoWithAccessToken';
  static const loginSocial = 'authentication.loginSocial';
  static const tokenExchangeWithParameters =
      'authentication.tokenExchangeWithParams';
  static const tokenExchangeWithCode = 'authentication.tokenExchangeWithCode';
  static const appleTokenExchange = 'authentication.appleTokenExchange';
  static const renew = 'authentication.renew';
  static const revoke = 'authentication.revoke';
  static const delegation = 'authentication.delegation';

  AuthenticationMethod._();
}

class CredentialsManagerMethod {
  static const enableBioMetrics = 'credentialsManager.enableBioMetrics';
  static const storeCredentials = 'credentialsManager.storeCredentials';
  static const clearCredentials = 'credentialsManager.clearCredentials';
  static const hasValidCredentials = 'credentialsManager.hasValidCredentials';
  static const getCredentials = 'credentialsManager.getCredentials';

  CredentialsManagerMethod._();
}
