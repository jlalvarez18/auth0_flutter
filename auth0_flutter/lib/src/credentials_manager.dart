import 'dart:io';

import 'package:auth0_platform_interface/auth0_platform_interface.dart';

class CredentialsManager {
  final Auth0App app;
  final String? storeKey;

  CredentialsManager._({required this.app, this.storeKey});

  static final Map<String, CredentialsManager> _cachedInstances = {};

  CredentialsManagerPlatform? _delegatePackingProperty;

  CredentialsManagerPlatform get _delegate {
    return _delegatePackingProperty ??=
        CredentialsManagerPlatform.instanceFor(app: app, storeKey: storeKey);
  }

  static CredentialsManager instanceFor({
    required Auth0App app,
    String? storeKey,
  }) {
    final cacheKey = app.clientId;

    if (_cachedInstances.containsKey(cacheKey)) {
      return _cachedInstances[cacheKey]!;
    }

    final instance = CredentialsManager._(app: app, storeKey: storeKey);

    _cachedInstances[cacheKey] = instance;

    return instance;
  }

  Future<bool> enableBiometrics({
    required String title,
    required BiometricsOptions options,
  }) {
    return _delegate.enableBiometrics(title: title, options: options.toMap());
  }

  Future<bool> storeCredentials(Credentials credentials) {
    return _delegate.storeCredentials(credentials);
  }

  Future<bool> clearCredentials() {
    return _delegate.clearCredentials();
  }

  Future<bool> revokeCredentials() {
    return _delegate.revokeCredentials();
  }

  Future<bool> hasValidCredentials() {
    return _delegate.hasValidCredentials();
  }

  Future<Credentials?> getCredentials({String? scope}) {
    return _delegate.getCredentials(scope: scope);
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
