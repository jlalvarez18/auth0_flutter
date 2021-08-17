part of auth0_flutter;

class CredentialsManager {
  static const _channel =
      const MethodChannel('plugins.auth0_flutter.io/credentials_manager');

  final Map<String, dynamic> _parameters;

  CredentialsManagerError _errorHandler(PlatformException e) =>
      CredentialsManagerError.from(e);

  CredentialsManager({
    required String clientId,
    required String domain,
    String? storeKey,
  }) : _parameters = {
          'clientId': clientId,
          'domain': domain,
          'storeKey': storeKey
        };

  /// Enables biometrics (fingerprint, faceId, etc)
  ///
  /// Returns a [Future] which completes with a boolean indicating success
  Future<bool> enableBiometrics({
    required String title,
    required BiometricsOptions options,
  }) async {
    final args = Map.fromEntries(_parameters.entries);
    args['title'] = title;
    args.addEntries(options.toMap().entries);

    final success = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.enableBioMetrics,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return success ?? false;
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final args = Map.fromEntries(_parameters.entries);
    args['credentials'] = credentials.toJSON();

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.storeCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  Future<bool> clearCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.clearCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  Future<bool> revokeCredentials() async {
    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.revokeCredentials,
      arguments: null,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  Future<bool> hasValidCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await invokeMethod<bool>(
      channel: _channel,
      method: CredentialsManagerMethod.hasValidCredentials,
      arguments: args,
      exceptionHandler: _errorHandler,
    );

    return result ?? false;
  }

  Future<Credentials?> getCredentials({String? scope}) async {
    final args = Map.fromEntries(_parameters.entries);
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
}

class BiometricsOptions {
  final IOSBiometricsOptions? _ios;
  final AndroidBiometricsOptions _android;

  BiometricsOptions({
    required AndroidBiometricsOptions android,
    IOSBiometricsOptions? ios,
  })  : _android = android,
        _ios = ios;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (Platform.isIOS) {
      final iosMap = _ios?.toMap();
      if (iosMap != null) {
        map.addAll(iosMap);
      }
    }

    if (Platform.isAndroid) {
      map.addAll(_android.toMap());
    }

    return map;
  }
}

class IOSBiometricsOptions {
  final String? cancelTitle;
  final String? fallbackTitle;

  IOSBiometricsOptions({
    this.cancelTitle,
    this.fallbackTitle,
  });

  Map<String, dynamic> toMap() {
    return {
      'cancelTitle': cancelTitle,
      'fallbackTitle': fallbackTitle,
    };
  }
}

class AndroidBiometricsOptions {
  /// Must be a valid number between 1 an 255
  final int requestCode;

  /// the text to use as description in the authentication screen. On some Android versions it might not be shown. Passing null will result in using the OS's default value.
  final String? description;

  AndroidBiometricsOptions({
    required this.requestCode,
    this.description,
  }) : assert(requestCode >= 1 && requestCode <= 255);

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'requestCode': requestCode,
    };
  }
}
