part of auth0_flutter;

class Users {
  static const MethodChannel _channel =
      MethodChannel('plugins.auth0_flutter.io/users');

  final String token;
  final String domain;

  Users._({this.token, this.domain});

  Future<Map<String, dynamic>> get(
      {@required String identifier,
      List<String> fields = const [],
      bool include = true}) async {
    final arguments = _generateArguments(
        {'identifier': identifier, 'fields': fields, 'include': include});

    return await _performMethod(() async {
      final result = await _channel.invokeMapMethod<String, dynamic>(
          UsersMethod.get, arguments);

      return result;
    });
  }

  Future<Map<String, dynamic>> patch(
      {@required String identifier,
      @required UserPatchAttributes attributes}) async {
    final arguments = _generateArguments(
        {'identifier': identifier, 'attributes': attributes._dictionary});

    return await _performMethod(() async {
      final result = await _channel.invokeMapMethod<String, dynamic>(
          UsersMethod.patchAttributes, arguments);

      return result;
    });
  }

  Future<Map<String, dynamic>> patchWithUserMetadata(
      {@required String identifier,
      @required Map<String, dynamic> userMetadata}) async {
    final arguments = _generateArguments(
        {'identifier': identifier, 'userMetadata': userMetadata});

    return await _performMethod(() async {
      final result = await _channel.invokeMapMethod<String, dynamic>(
          UsersMethod.patchUserMetadata, arguments);

      return result;
    });
  }

  Future<List<Map<String, dynamic>>> linkWithOtherUserToken(
      {@required String identifier, @required String token}) async {
    final arguments =
        _generateArguments({'identifier': identifier, 'token': token});

    return await _performMethod(() async {
      final result = await _channel.invokeListMethod<Map<String, dynamic>>(
          UsersMethod.linkWithOtherUserToken, arguments);

      return result;
    });
  }

  Future<List<Map<String, dynamic>>> linkWithUserId(
      {@required String identifier,
      @required String userId,
      @required String provider,
      String connectionId}) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'userId': userId,
      'provider': provider,
      'connectionId': connectionId
    });

    return await _performMethod(() async {
      final result = await _channel.invokeListMethod<Map<String, dynamic>>(
          UsersMethod.linkWithUserId, arguments);

      return result;
    });
  }

  Future<List<Map<String, dynamic>>> unlink(
      {@required String identityId,
      @required String provider,
      @required String fromUserId}) async {
    final arguments = _generateArguments({
      'identityId': identityId,
      'provider': provider,
      'fromUserId': fromUserId
    });

    return await _performMethod(() async {
      final result = await _channel.invokeListMethod<Map<String, dynamic>>(
          UsersMethod.unlink, arguments);

      return result;
    });
  }

  Map<String, dynamic> _generateArguments(Map<String, dynamic> other) {
    final args = {'token': token, 'domain': domain};

    if (other != null) {
      args.addAll(other);
    }

    return args;
  }

  Future<T> _performMethod<T>(AsyncValueGetter<T> block) async {
    try {
      final result = await block();

      return result;
    } on PlatformException catch (e) {
      throw UsersError.from(e);
    }
  }
}
