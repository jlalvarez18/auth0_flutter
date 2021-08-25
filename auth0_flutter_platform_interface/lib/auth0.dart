import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'src/authentication/authentication_method_channel.dart';
import 'src/authentication/authentication_platform_interface.dart';
import 'src/credentials/credentials_manager_method_channel.dart';
import 'src/credentials/credentials_manager_platform_interface.dart';
import 'src/users/users_method_channel.dart';
import 'src/users/users_platform_interface.dart';
import 'src/web_auth/web_auth_method_channel.dart';
import 'src/web_auth/web_auth_platform_interface.dart';

export 'src/authentication/authentication_error.dart';
export 'src/authentication/authentication_platform_interface.dart';
export 'src/authentication/database_user.dart';
export 'src/authentication/identity.dart';
export 'src/authentication/profile.dart';
export 'src/authentication/user_info.dart';
export 'src/credentials/credentials.dart';
export 'src/credentials/credentials_error.dart';
export 'src/credentials/credentials_manager_platform_interface.dart';
export 'src/users/user_patch_attributes.dart';
export 'src/users/users_error.dart';
export 'src/users/users_platform_interface.dart';
export 'src/web_auth/web_auth_error.dart';
export 'src/web_auth/web_auth_platform_interface.dart';

class Auth0Platform extends PlatformInterface {
  final String clientId;
  final String domain;

  Auth0Platform({required this.clientId, required this.domain})
      : super(token: _token);

  static final Object _token = Object();

  static void verifyExtends(Auth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
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
