import 'package:auth0_platform_interface/auth0_platform_interface.dart';

import 'src/credentials_manager.dart';

class Auth0 {
  final Auth0App app;

  Auth0({required this.app}) {
    Auth0Platform.instance = Auth0Platform.initialize(options: app);
  }

  static Auth0Platform get _delegate => Auth0Platform.instance;

  WebAuthPlatform webAuth() => _delegate.webAuth();

  AuthenticationPlatform authentication() => _delegate.authentication();

  UsersPlatform users({required String token}) => _delegate.users(token: token);

  CredentialsManager credentialsManager({String? storeKey = 'credentials'}) =>
      CredentialsManager.instanceFor(app: app, storeKey: storeKey);
}
