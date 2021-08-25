import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'credentials.dart';

abstract class CredentialsManagerPlatform extends PlatformInterface {
  final String clientId;
  final String domain;

  CredentialsManagerPlatform({
    required this.clientId,
    required this.domain,
  }) : super(token: _token);

  static final Object _token = Object();

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
