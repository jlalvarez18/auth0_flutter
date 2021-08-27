import 'package:auth0_platform_interface/auth0_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel/authentication_method_channel.dart';
import '../method_channel/credentials_manager_method_channel.dart';
import '../method_channel/users_method_channel.dart';
import '../method_channel/web_auth_method_channel.dart';
import '../models/auth0_app.dart';
import 'authentication_platform_interface.dart';
import 'credentials_manager_platform_interface.dart';
import 'users_platform_interface.dart';
import 'web_auth_platform_interface.dart';

class Auth0Platform extends PlatformInterface {
  final Auth0App app;

  Auth0Platform._({required this.app}) : super(token: _token);

  static Auth0Platform initialize({required Auth0App options}) {
    final instance = _instance ?? Auth0Platform._(app: options);

    return instance;
  }

  static final Object _token = Object();

  static Auth0Platform? _instance;

  static Auth0Platform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError("You must call initialze() first!");
  }

  static set instance(Auth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// The default instance of [WebAuthPlatform] to use.
  ///
  /// Defaults to [WebAuthMethodChannel].
  WebAuthPlatform webAuth() {
    throw UnimplementedError('webAuth() has not been implemented.');
  }

  /// The default instance of [AuthenticationPlatform] to use.
  ///
  /// Defaults to [AuthenticationMethodChannel].
  AuthenticationPlatform authentication() {
    throw UnimplementedError('authentication() has not been implemented.');
  }

  /// The default instance of [UsersPlatform] to use.
  ///
  /// Defaults to [UsersMethodChannel].
  UsersPlatform users({required String token}) {
    throw UnimplementedError('users() has not been implemented.');
  }

  /// The default instance of [CredentialsManagerPlatform] to use.
  ///
  /// Defaults to [CredentialsManagerMethodChannel].
  CredentialsManagerPlatform credentialsManager({
    String? storeKey = 'credentials',
  }) {
    throw UnimplementedError('credentialsManager() has not been implemented.');
  }
}
