part of auth0_flutter;

class CredentialsManager {
  static const _channel =
      const MethodChannel('plugins.auth0_flutter.io/credentials_manager');

  final Map<String, dynamic> _parameters;

  CredentialsManager(
      {@required String clientId, @required String domain, String storeKey})
      : _parameters = {
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

    await _performMethod(() async {
      await _channel.invokeMapMethod<String, dynamic>(
          CredentialsManagerMethod.enableBioMetrics, args);
    });
  }

  Future<bool> storeCredentials(Credentials credentials) async {
    final args = Map.fromEntries(_parameters.entries);
    args['credentials'] = credentials.toJSON();

    return await _performMethod(() async {
      final result = await _channel.invokeMethod<bool>(
          CredentialsManagerMethod.storeCredentials, args);

      return result;
    });
  }

  Future<bool> clearCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    return await _performMethod(() async {
      final result = await _channel.invokeMethod<bool>(
          CredentialsManagerMethod.clearCredentials, args);

      return result;
    });
  }

  Future<bool> hasValidCredentials() async {
    final args = Map.fromEntries(_parameters.entries);

    return await _performMethod(() async {
      final result = await _channel.invokeMethod<bool>(
          CredentialsManagerMethod.hasValidCredentials, args);

      return result;
    });
  }

  Future<Credentials> getCredentials({String scope}) async {
    final args = Map.fromEntries(_parameters.entries);
    args['scope'] = scope;

    return await _performMethod(() async {
      final result = await _channel.invokeMapMethod<String, dynamic>(
          CredentialsManagerMethod.getCredentials, args);

      return Credentials.fromJSON(result);
    });
  }

  Future<T> _performMethod<T>(AsyncValueGetter<T> block) async {
    try {
      final result = await block();

      return result;
    } on PlatformException catch (e) {
      final details = Map<String, dynamic>.from(e.details);
      throw CredentialsManagerError.fromJSON(details);
    }
  }
}
