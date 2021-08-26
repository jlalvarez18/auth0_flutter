import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/auth0_app.dart';
import '../models/credentials.dart';

abstract class CredentialsManagerPlatform extends PlatformInterface {
  final String? storeKey;
  final Auth0App app;

  CredentialsManagerPlatform({required this.app, this.storeKey})
      : super(token: _token);

  static final Object _token = Object();

  static CredentialsManagerPlatform? _instance;

  static CredentialsManagerPlatform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError(
        'CredentialsManagerPlatform.instance has not been set.');
  }

  static set instance(CredentialsManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  Future<bool> enableBiometrics({
    required String title,
    required Map<String, dynamic> options,
  }) {
    throw UnimplementedError('enableBiometrics() has not been implemented.');
  }

  Future<bool> storeCredentials(Credentials credentials) {
    throw UnimplementedError('storeCredentials() has not been implemented.');
  }

  Future<bool> clearCredentials() {
    throw UnimplementedError('clearCredentials() has not been implemented.');
  }

  Future<bool> revokeCredentials() {
    throw UnimplementedError('revokeCredentials() has not been implemented.');
  }

  Future<bool> hasValidCredentials() {
    throw UnimplementedError('hasValidCredentials() has not been implemented.');
  }

  Future<Credentials?> getCredentials({String? scope}) {
    throw UnimplementedError('getCredentials() has not been implemented.');
  }
}
