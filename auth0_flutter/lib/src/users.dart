part of auth0_flutter;

class Users {
  final String token;

  Users._({required this.token});

  // Cached and lazily loaded instance of [UsersPlatform] to avoid
  // creating a [UsersMethodChannel] when not needed or creating an
  // instance with the default app before a user specifies an app.
  UsersPlatform? _delegatePackingProperty;

  UsersPlatform get _delegate {
    _delegatePackingProperty ??= UsersPlatform.instanceWith(token: token);

    return _delegatePackingProperty!;
  }

  static Map<String, Users> _instances = {};

  static Users instanceWith({required String token}) {
    if (_instances.containsKey(token)) {
      return _instances[token]!;
    }

    final newInstance = Users._(token: token);

    _instances[token] = newInstance;

    return newInstance;
  }

  Future<Map<String, dynamic>?> get({
    required String identifier,
    List<String> fields = const [],
    bool include = true,
  }) =>
      _delegate.get(
        identifier: identifier,
        fields: fields,
        include: include,
      );

  Future<Map<String, dynamic>?> patch({
    required String identifier,
    required UserPatchAttributes attributes,
  }) =>
      _delegate.patch(
        identifier: identifier,
        attributes: attributes,
      );

  Future<Map<String, dynamic>?> patchWithUserMetadata({
    required String identifier,
    required Map<String, dynamic> userMetadata,
  }) =>
      _delegate.patchWithUserMetadata(
        identifier: identifier,
        userMetadata: userMetadata,
      );

  Future<List<Map<String, dynamic>>?> linkWithOtherUserToken({
    required String identifier,
    required String token,
  }) =>
      _delegate.linkWithOtherUserToken(identifier: identifier, token: token);

  Future<List<Map<String, dynamic>>?> linkWithUserId({
    required String identifier,
    required String userId,
    required String provider,
    String? connectionId,
  }) =>
      _delegate.linkWithUserId(
        identifier: identifier,
        userId: userId,
        provider: provider,
        connectionId: connectionId,
      );

  Future<List<Map<String, dynamic>>?> unlink({
    required String identityId,
    required String provider,
    required String fromUserId,
  }) =>
      _delegate.unlink(
        identityId: identityId,
        provider: provider,
        fromUserId: fromUserId,
      );
}
