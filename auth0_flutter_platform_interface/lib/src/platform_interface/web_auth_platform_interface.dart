import 'package:auth0_platform_interface/src/method_channel/web_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/credentials.dart';

// String values: token, id_token, code
enum ResponseType { token, idToken, code }

abstract class WebAuthPlatform extends PlatformInterface {
  WebAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebAuthPlatform? _instance;

  static WebAuthPlatform get instance {
    _instance ??= WebAuthMethodChannel.instance;

    return _instance!;
  }

  static set instance(WebAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  /// Turn on/off Auth0.swift debug logging of HTTP requests and OAuth2 flow (iOS only).
  WebAuthPlatform logging({required bool enabled}) {
    throw UnimplementedError('logging() has not been implemented.');
  }

  /// For redirect url instead of a custom scheme it will use `https` and iOS 9 Universal Links.
  /// Before enabling this flag you'll need to configure Universal Links
  WebAuthPlatform useUniversalLink() {
    throw UnimplementedError('useUniversalLink() has not been implemented.');
  }

  // Specify a custom Scheme to use on the Callback Uri. Default scheme is 'https'
  // Used for Android client.
  // No-op on iOS
  WebAuthPlatform scheme(String value) {
    throw UnimplementedError('scheme() has not been implemented.');
  }

  /// Specify a connection name to be used to authenticate.
  /// By default no connection is specified, so the hosted login page will be displayed
  WebAuthPlatform connection(String value) {
    throw UnimplementedError('connection() has not been implemented.');
  }

  /// Scopes that will be requested during auth
  /// a scope value like: `openid email`
  WebAuthPlatform scope(String value) {
    throw UnimplementedError('scope() has not been implemented.');
  }

  /// Provider scopes for oauth2/social connections. e.g. Facebook, Google etc
  /// oauth2/social comma separated scope list: `user_friends,email`
  WebAuthPlatform connectionScope(String value) {
    throw UnimplementedError('connectionScope() has not been implemented.');
  }

  /// State value that will be echoed after authentication
  /// in order to check that the response is from your request and not other.
  /// By default a random value is used.
  WebAuthPlatform state(String value) {
    throw UnimplementedError('state() has not been implemented.');
  }

  /// Send additional parameters for authentication.
  WebAuthPlatform parameters(Map<String, String> value) {
    throw UnimplementedError('parameters() has not been implemented.');
  }

  /// Setup the response types to be used for authentication
  /// No longer used in Android v2 SDK
  WebAuthPlatform responseType(List<ResponseType> value) {
    throw UnimplementedError('responseType() has not been implemented.');
  }

  /// Add nonce paramater for authentication, this is a requirement for
  /// when response type .id_token is specified.
  WebAuthPlatform nonce(String value) {
    throw UnimplementedError('nonce() has not been implemented.');
  }

  ///  Audience name of the API that your application will call using the `access_token` returned after Auth.
  ///  This value must match the one defined in Auth0 Dashboard [APIs Section](https://manage.auth0.com/#/apis)
  WebAuthPlatform audience(String value) {
    throw UnimplementedError('audience() has not been implemented.');
  }

  Future<Credentials> start() {
    throw UnimplementedError('start() has not been implemented.');
  }

  Future<bool> clearSession(bool federated) {
    throw UnimplementedError('clearSession() has not been implemented.');
  }
}
