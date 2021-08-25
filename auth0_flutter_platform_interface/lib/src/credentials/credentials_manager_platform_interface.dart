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
  });

  Future<bool> storeCredentials(Credentials credentials);

  Future<bool> clearCredentials();

  Future<bool> revokeCredentials();

  Future<bool> hasValidCredentials();

  Future<Credentials?> getCredentials({String? scope});
}
