part of auth0_flutter;

class CredentialsManager {
  final MethodChannel _channel;

  final Map<String, dynamic> _parameters;

  CredentialsManager(
      {@required String clientId,
      @required String domain,
      String storeKey,
      @required MethodChannel channel})
      : _channel = channel,
        _parameters = {
          'clientId': clientId,
          'domain': domain,
          'storeKey': storeKey
        };

  Future<void> enableBiometrics(
      {@required String title,
      String cancelTitle,
      String fallbackTitle}) async {
    assert(title != null);

    final args = Map.fromEntries(_parameters.entries);
    args['title'] = title;
    args['cancelTitle'] = cancelTitle;
    args['fallbackTitle'] = fallbackTitle;

    await _channel.invokeMapMethod<String, dynamic>(
        CredentialsManagerMethod.enableBioMetrics, args);
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final args = Map.fromEntries(_parameters.entries);
    args['credentials'] = credentials.toJSON();

    final result = await _channel.invokeMethod<bool>(
        CredentialsManagerMethod.storeCredentials, args);

    return result;
  }

  Future<bool> clearCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await _channel.invokeMethod<bool>(
        CredentialsManagerMethod.clearCredentials, args);

    return result;
  }

  Future<bool> hasValidCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await _channel.invokeMethod<bool>(
        CredentialsManagerMethod.hasValidCredentials, args);

    return result;
  }

  Future<Credentials> getCredentials({String scope}) async {
    final args = Map.fromEntries(_parameters.entries);
    args['scope'] = scope;

    final result = await _channel.invokeMapMethod<String, dynamic>(
        CredentialsManagerMethod.getCredentials, args);

    return Credentials.fromJSON(result);
  }
}
