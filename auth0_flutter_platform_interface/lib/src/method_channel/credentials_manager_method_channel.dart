import 'package:flutter/services.dart';

import '../errors/credentials_error.dart';
import '../models/auth0_app.dart';
import '../models/credentials.dart';
import '../platform_interface/credentials_manager_platform_interface.dart';
import '../utils/channel_helper.dart';
import '../utils/channel_methods.dart';

const _channel =
    const MethodChannel('plugins.auth0_flutter.io/credentials_manager');

class CredentialsManagerMethodChannel extends CredentialsManagerPlatform {
  CredentialsManagerError _errorHandler(PlatformException e) =>
      CredentialsManagerError.from(e);

  CredentialsManagerMethodChannel({required Auth0App app, String? storeKey})
      : super(app: app, storeKey: storeKey);

  /// Enables biometrics (fingerprint, faceId, etc)
  ///
  /// Returns a [Future] which completes with a boolean indicating success
  @override
  Future<bool> enableBiometrics({
    required String title,
    required Map<String, dynamic> options,
  }) async {
    final args = _generateArguments();
    args['title'] = title;
    args.addEntries(options.entries);

    final success = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.enableBioMetrics,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return success ?? false;
  }

  @override
  Future<bool> storeCredentials(Credentials credentials) async {
    final args = _generateArguments();
    args['credentials'] = credentials.toJSON();

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.storeCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  @override
  Future<bool> clearCredentials() async {
    final args = _generateArguments();

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.clearCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  @override
  Future<bool> revokeCredentials() async {
    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.revokeCredentials,
      arguments: null,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  @override
  Future<bool> hasValidCredentials() async {
    final args = _generateArguments();

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.hasValidCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  @override
  Future<Credentials?> getCredentials({String? scope}) async {
    final args = _generateArguments();
    args['scope'] = scope;

    final result = await invokeMapMethod<String, dynamic>(
      channel: _channel,
      method: CredentialsManagerMethod.getCredentials,
      arguments: args,
      exceptionHandler: (exception) {
        final e = _errorHandler(exception);

        if (e.type == CredentialErrorType.noCredentials) {
          return null;
        }

        return e;
      },
    );

    if (result != null) {
      return Credentials.fromJSON(result);
    }

    return null;
  }

  Map<String, dynamic> _generateArguments() {
    return {
      'clientId': app.clientId,
      'domain': app.domain,
      'storeKey': storeKey,
    };
  }
}
