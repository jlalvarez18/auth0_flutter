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
        CredentialsManagerMethod.enableBioMetrics);

    _processJSONForErrors(result);
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final result = await _channel.invokeMethod<bool>(
        CredentialsManagerMethod.storeCredentials, credentials.toJSON());

    return result;
  }

  Future<bool> clearCredentials() async {
    final result = await _channel
        .invokeMethod<bool>(CredentialsManagerMethod.clearCredentials);

    return result;
  }

  Future<bool> hasValidCredentials() async {
    final result = await _channel
        .invokeMethod<bool>(CredentialsManagerMethod.hasValidCredentials);

    return result;
  }

  Future<Credentials> getCredentials({String scope}) async {
    final args = {'scope': scope};
    final result = await _channel.invokeMapMethod<String, dynamic>(
        CredentialsManagerMethod.getCredentials, args);

    _processJSONForErrors(result);

    return Credentials.fromJSON(result);
  }
}
