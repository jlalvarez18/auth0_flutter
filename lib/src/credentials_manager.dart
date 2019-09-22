part of auth0_flutter;

class CredentialsManager {
  final Authentication auth;
  final String storeKey;
  final MethodChannel _channel;

  CredentialsManager({this.auth, this.storeKey, MethodChannel channel})
      : _channel = channel;

  Future<void> enableBiometrics(
      {@required String title,
      String cancelTitle,
      String fallbackTitle}) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
        'credentials_manager_enable_biometrics');

    _processJSONForErrors(result);
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final result = await _channel.invokeMethod<bool>(
        'credentials_manager_store_credentials', credentials.toJSON());

    return result;
  }

  Future<bool> clearCredentials() async {
    final result = await _channel
        .invokeMethod<bool>('credentials_manager_clear_credentials');

    return result;
  }

  Future<bool> hasValidCredentials() async {
    final result = await _channel
        .invokeMethod<bool>('credentials_manager_has_valid_credentials');

    return result;
  }

  Future<Credentials> getCredentials({String scope}) async {
    final args = {'scope': scope};
    final result = await _channel.invokeMapMethod<String, dynamic>(
        'credentials_manager_get_credentials', args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }
}
