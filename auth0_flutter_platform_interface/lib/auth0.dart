import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/authentication/authentication_method_channel.dart';
import 'src/authentication/authentication_platform_interface.dart';
import 'src/credentials/credentials_manager_method_channel.dart';
import 'src/credentials/credentials_manager_platform_interface.dart';
import 'src/users/users_method_channel.dart';
import 'src/users/users_platform_interface.dart';
import 'src/web_auth/web_auth_method_channel.dart';
import 'src/web_auth/web_auth_platform_interface.dart';

export 'src/authentication/authentication_platform_interface.dart';
export 'src/credentials/credentials_manager_platform_interface.dart';
export 'src/users/users_platform_interface.dart';
export 'src/web_auth/web_auth_platform_interface.dart';

class Auth0Platform extends PlatformInterface {
  final String clientId;
  final String domain;

  Auth0Platform._({required this.clientId, required this.domain})
      : super(token: _token);

  static final Object _token = Object();

  static Auth0Platform? _instance;

  static Auth0Platform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError(
        'You must call Auth0.initialize() before calling Auth0Platform.instance');
  }

  static set instance(Auth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  static Auth0Platform initialize({
    required String clientId,
    required String domain,
  }) {
    _instance = Auth0Platform._(clientId: clientId, domain: domain);

    return _instance!;
  }

  /// The default instance of [WebAuthPlatform] to use.
  ///
  /// Defaults to [WebAuthMethodChannel].
  WebAuthPlatform webAuth() {
    return WebAuthMethodChannel(clientId: clientId, domain: domain);
  }

  /// The default instance of [AuthenticationPlatform] to use.
  ///
  /// Defaults to [AuthenticationMethodChannel].
  AuthenticationPlatform authentication() {
    return AuthenticationMethodChannel(clientId: clientId, domain: domain);
  }

  /// The default instance of [UsersPlatform] to use.
  ///
  /// Defaults to [UsersMethodChannel].
  UsersPlatform users({required String token}) {
    return UsersMethodChannel(token: token, domain: domain);
  }

  /// The default instance of [CredentialsManagerPlatform] to use.
  ///
  /// Defaults to [CredentialsManagerMethodChannel].
  CredentialsManagerPlatform credentialsManager() {
    return CredentialsManagerMethodChannel(clientId: clientId, domain: domain);
  }
}
