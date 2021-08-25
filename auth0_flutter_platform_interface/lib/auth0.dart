export 'src/authentication/authentication_platform_interface.dart';
export 'src/credentials/credentials_manager_platform_interface.dart';
export 'src/users/users_platform_interface.dart';
export 'src/web_auth/web_auth_platform_interface.dart';

class Auth0 {
  final String clientId;
  final String domain;

  Auth0._({required this.clientId, required this.domain});

  static Auth0? _instance;

  static void initialize({
    required String clientId,
    required String domain,
  }) {
    _instance = Auth0._(clientId: clientId, domain: domain);
  }

  static Auth0 get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError(
        'You must call Auth0.initialize() before calling any methods in library');
  }
}

// abstract class UsersPlatform extends PlatformInterface {
//   final Auth0 auth0;

//   UsersPlatform(this.auth0) : super(token: _token);

//   static final Object _token = Object();
// }

// abstract class CredentialsManagerPlatform extends PlatformInterface {
//   final Auth0 auth0;

//   CredentialsManagerPlatform(this.auth0) : super(token: _token);

//   static final Object _token = Object();
// }
