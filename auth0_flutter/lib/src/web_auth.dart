part of auth0_flutter;

class WebAuth {
  WebAuth._();

  WebAuthPlatform? _delegatePackingProperty;

  WebAuthPlatform get _delegate {
    _delegatePackingProperty ??= WebAuthPlatform.instance;

    return _delegatePackingProperty!;
  }

  static WebAuth _instance = WebAuth._();
  static WebAuth get instance => _instance;

  /// Turn on/off Auth0.swift debug logging of HTTP requests and OAuth2 flow (iOS only).
  WebAuth logging({required bool enabled}) {
    _delegate.logging(enabled: enabled);
    return this;
  }

  /// For redirect url instead of a custom scheme it will use `https` and iOS 9 Universal Links.
  /// Before enabling this flag you'll need to configure Universal Links
  WebAuth useUniversalLink() {
    _delegate.useUniversalLink();
    return this;
  }

  // Specify a custom Scheme to use on the Callback Uri. Default scheme is 'https'
  // Used for Android client.
  // No-op on iOS
  WebAuth scheme(String value) {
    _delegate.scheme(value);
    return this;
  }

  /// Specify a connection name to be used to authenticate.
  /// By default no connection is specified, so the hosted login page will be displayed
  WebAuth connection(String value) {
    _delegate.connection(value);
    return this;
  }

  /// Scopes that will be requested during auth
  /// a scope value like: `openid email`
  WebAuth scope(String value) {
    _delegate.scope(value);
    return this;
  }

  /// Provider scopes for oauth2/social connections. e.g. Facebook, Google etc
  /// oauth2/social comma separated scope list: `user_friends,email`
  WebAuth connectionScope(String value) {
    _delegate.connectionScope(value);
    return this;
  }

  /// State value that will be echoed after authentication
  /// in order to check that the response is from your request and not other.
  /// By default a random value is used.
  WebAuth state(String value) {
    _delegate.state(value);
    return this;
  }

  /// Send additional parameters for authentication.
  WebAuth parameters(Map<String, String> value) {
    _delegate.parameters(value);
    return this;
  }

  /// Setup the response types to be used for authentication
  /// No longer used in Android v2 SDK
  WebAuth responseType(List<ResponseType> value) {
    _delegate.responseType(value);
    return this;
  }

  /// Add nonce paramater for authentication, this is a requirement for
  /// when response type .id_token is specified.
  WebAuth nonce(String value) {
    _delegate.nonce(value);
    return this;
  }

  ///  Audience name of the API that your application will call using the `access_token` returned after Auth.
  ///  This value must match the one defined in Auth0 Dashboard [APIs Section](https://manage.auth0.com/#/apis)
  WebAuth audience(String value) {
    _delegate.audience(value);
    return this;
  }

  Future<Credentials> start() => _delegate.start();

  Future<bool> clearSession(bool federated) =>
      _delegate.clearSession(federated);
}
