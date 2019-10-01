part of auth0_flutter;

class CredentialsManager {
  static const _channel =
      const MethodChannel('plugins.auth0_flutter.io/credentials_manager');

  final Map<String, dynamic> _parameters;

  CredentialsManagerError _errorHandler(PlatformException e) =>
      CredentialsManagerError.from(e);

  CredentialsManager(
      {@required String clientId, @required String domain, String storeKey})
      : _parameters = {
          'clientId': clientId,
          'domain': domain,
          'storeKey': storeKey
        };

  Future<bool> enableBiometrics(
      {@required String title,
      String cancelTitle,
      String fallbackTitle}) async {
    assert(title != null);

    final args = Map.fromEntries(_parameters.entries);
    args['title'] = title;
    args['cancelTitle'] = cancelTitle;
    args['fallbackTitle'] = fallbackTitle;

    final success = await invokeMethod<bool>(
        channel: _channel,
        method: CredentialsManagerMethod.enableBioMetrics,
        arguments: args,
        exceptionHandler: _errorHandler);

    return success;
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final args = Map.fromEntries(_parameters.entries);
    args['credentials'] = credentials.toJSON();

    final result = await invokeMethod<bool>(
        channel: _channel,
        method: CredentialsManagerMethod.storeCredentials,
        arguments: args,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<bool> clearCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await invokeMethod<bool>(
        channel: _channel,
        method: CredentialsManagerMethod.clearCredentials,
        arguments: args,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<bool> hasValidCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    final result = await invokeMethod<bool>(
        channel: _channel,
        method: CredentialsManagerMethod.hasValidCredentials,
        arguments: args,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<Credentials> getCredentials({String scope}) async {
    final args = Map.fromEntries(_parameters.entries);
    args['scope'] = scope;

    final result = await invokeMapMethod<String, dynamic>(
        channel: _channel,
        method: CredentialsManagerMethod.getCredentials,
        arguments: args,
        exceptionHandler: _errorHandler);

    return Credentials.fromJSON(result);
  }
}
