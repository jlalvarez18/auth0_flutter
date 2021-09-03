part of auth0_flutter;

class Auth0 {
  // Ensures end-users cannot initialize the class.
  Auth0._();

  static Auth0 _instance = Auth0._();

  static Auth0 get instance => _instance;

  // Cached & lazily loaded instance of [Auth0Platform].
  // The property is visible for testing to allow tests to set a mock
  // instance directly as a static property since the class is not initialized.
  @visibleForTesting
  // ignore: public_member_api_docs
  static Auth0Platform? delegatePackingProperty;

  static Auth0Platform get _delegate {
    return delegatePackingProperty ??= Auth0Platform.instance;
  }

  static Future<void> initialize({Auth0Options? options}) async =>
      _delegate.initialize(options: options);

  Auth0Options? get options => _delegate.options;

  WebAuth webAuth() => WebAuth.instance;

  Authentication authentication() => Authentication.instance;

  Users users({required String token}) => Users.instanceWith(token: token);

  CredentialsManager credentialsManager({String? storeKey = 'credentials'}) =>
      CredentialsManager.instanceWith(storeKey: storeKey);
}
