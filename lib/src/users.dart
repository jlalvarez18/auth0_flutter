part of auth0_flutter;

class Users {
  static const MethodChannel _channel =
      MethodChannel('plugins.auth0_flutter.io/users');

  UsersError _errorHandler(PlatformException e) => UsersError.from(e);

  final String token;
  final String domain;

  Users._({this.token, this.domain});

  Future<Map<String, dynamic>> get(
      {@required String identifier,
      List<String> fields = const [],
      bool include = true}) async {
    assert(identifier != null);

    final arguments = _generateArguments(
        {'identifier': identifier, 'fields': fields, 'include': include});

    final result = await invokeMapMethod<String, dynamic>(
        channel: _channel,
        method: UsersMethod.get,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<Map<String, dynamic>> patch(
      {@required String identifier,
      @required UserPatchAttributes attributes}) async {
    assert(identifier != null);
    assert(attributes != null);

    final arguments = _generateArguments(
        {'identifier': identifier, 'attributes': attributes._dictionary});

    final result = await invokeMapMethod<String, dynamic>(
        channel: _channel,
        method: UsersMethod.patchAttributes,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<Map<String, dynamic>> patchWithUserMetadata(
      {@required String identifier,
      @required Map<String, dynamic> userMetadata}) async {
    assert(identifier != null);
    assert(userMetadata != null);

    final arguments = _generateArguments(
        {'identifier': identifier, 'userMetadata': userMetadata});

    final result = await invokeMapMethod<String, dynamic>(
        channel: _channel,
        method: UsersMethod.patchUserMetadata,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<List<Map<String, dynamic>>> linkWithOtherUserToken(
      {@required String identifier, @required String token}) async {
    assert(identifier != null);
    assert(token != null);

    final arguments =
        _generateArguments({'identifier': identifier, 'token': token});

    final result = await invokeListMethod<Map<String, dynamic>>(
        channel: _channel,
        method: UsersMethod.linkWithOtherUserToken,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<List<Map<String, dynamic>>> linkWithUserId(
      {@required String identifier,
      @required String userId,
      @required String provider,
      String connectionId}) async {
    assert(identifier != null);
    assert(userId != null);
    assert(provider != null);

    final arguments = _generateArguments({
      'identifier': identifier,
      'userId': userId,
      'provider': provider,
      'connectionId': connectionId
    });

    final result = await invokeListMethod<Map<String, dynamic>>(
        channel: _channel,
        method: UsersMethod.linkWithUserId,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Future<List<Map<String, dynamic>>> unlink(
      {@required String identityId,
      @required String provider,
      @required String fromUserId}) async {
    assert(identityId != null);
    assert(provider != null);
    assert(fromUserId != null);

    final arguments = _generateArguments({
      'identityId': identityId,
      'provider': provider,
      'fromUserId': fromUserId
    });

    final result = await invokeListMethod<Map<String, dynamic>>(
        channel: _channel,
        method: UsersMethod.unlink,
        arguments: arguments,
        exceptionHandler: _errorHandler);

    return result;
  }

  Map<String, dynamic> _generateArguments(Map<String, dynamic> other) {
    final args = {'token': token, 'domain': domain};

    if (other != null) {
      args.addAll(other);
    }

    return args;
  }
}
