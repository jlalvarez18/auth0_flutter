part of auth0_flutter;

class CredentialsManager {
  final String? storeKey;

  CredentialsManager._({this.storeKey});

  // Cached and lazily loaded instance of [CredentialsManagerPlatform] to avoid
  // creating a [CredentialsManagerMethodChannel] when not needed or creating an
  // instance with the default app before a user specifies an app.
  CredentialsManagerPlatform? _delegatePackingProperty;

  CredentialsManagerPlatform get _delegate {
    _delegatePackingProperty ??=
        CredentialsManagerPlatform.instanceWith(storeKey: storeKey);

    return _delegatePackingProperty!;
  }

  static String _defaultStoreKey = "default";
  static Map<String, CredentialsManager> _instances = {};

  static CredentialsManager instanceWith({String? storeKey}) {
    final cacheKey = storeKey ?? _defaultStoreKey;
    if (_instances.containsKey(cacheKey)) {
      return _instances[cacheKey]!;
    }

    final newInstance = CredentialsManager._(storeKey: storeKey);

    _instances[cacheKey] = newInstance;

    return newInstance;
  }

  Future<bool> enableBiometrics({
    required String title,
    required BiometricsOptions options,
  }) =>
      _delegate.enableBiometrics(title: title, options: options.toMap());

  Future<bool> storeCredentials(Credentials credentials) =>
      _delegate.storeCredentials(credentials);

  Future<bool> clearCredentials() => _delegate.clearCredentials();

  Future<bool> revokeCredentials() => _delegate.revokeCredentials();

  Future<bool> hasValidCredentials() => _delegate.hasValidCredentials();

  Future<Credentials?> getCredentials({String? scope}) =>
      _delegate.getCredentials(scope: scope);
}
