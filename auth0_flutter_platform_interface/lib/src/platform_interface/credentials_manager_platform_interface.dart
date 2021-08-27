import 'package:auth0_platform_interface/src/method_channel/credentials_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/auth0_app.dart';
import '../models/credentials.dart';

abstract class CredentialsManagerPlatform extends PlatformInterface {
  final Auth0App app;
  final String? storeKey;

  CredentialsManagerPlatform({required this.app, this.storeKey})
      : super(token: _token);

  static final Object _token = Object();

  factory CredentialsManagerPlatform.instanceFor({
    required Auth0App app,
    String? storeKey,
  }) {
    return CredentialsManagerPlatform.instance
        .delegateFor(app: app, storeKey: storeKey);
  }

  static CredentialsManagerPlatform? _instance;

  static CredentialsManagerPlatform get instance {
    return _instance ??= CredentialsManagerMethodChannel(
        app: Auth0App(clientId: "", domain: ""));
  }

  static set instance(CredentialsManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  CredentialsManagerPlatform delegateFor({
    required Auth0App app,
    String? storeKey,
  }) {
    throw UnimplementedError('delegateFor() is not implemented');
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
