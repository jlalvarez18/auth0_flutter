part of auth0_flutter;

class Users {
  final String token;
  final String domain;
  final MethodChannel _channel;

  Users._({this.token, this.domain, MethodChannel channel})
      : _channel = channel;

  Future<Map<String, dynamic>> get(
      {String identifier, List<String> fields, bool include}) async {
    final arguments = {
      'identifier': identifier,
      'fields': fields,
      'include': include
    };

    final result =
        await _channel.invokeMapMethod<String, dynamic>('users_get', arguments);

    return result;
  }

  Future<Map<String, dynamic>> patch(
      {String identifier, UserPatchAttributes attributes}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'attributes': attributes._dictionary
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        'users_patch_attributes', arguments);

    return result;
  }

  Future<Map<String, dynamic>> patchWithUserMetadata(
      {String identifier, Map<String, dynamic> userMetadata}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'userMetadata': userMetadata
    };

    final result = await _channel.invokeMapMethod<String, dynamic>(
        'users_patch_user_metadata', arguments);

    return result;
  }

  Future<List<Map<String, dynamic>>> linkWithOtherUserToken(
      {String identifier, String token}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'token': token
    };

    final result = await _channel.invokeListMethod<Map<String, dynamic>>(
        'users_link_with_other_user_token', arguments);

    return result;
  }

  Future<List<Map<String, dynamic>>> linkWithUserId(
      {@required String identifier,
      @required String userId,
      @required String provider,
      String connectionId}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'userId': userId,
      'provider': provider,
      'connectionId': connectionId
    };

    final result = await _channel.invokeListMethod<Map<String, dynamic>>(
        'users_link_with_user_id', arguments);

    return result;
  }

  Future<List<Map<String, dynamic>>> unlink(
      {@required String identityId,
      @required String provider,
      @required String fromUserId}) async {
    final arguments = <String, dynamic>{
      'identityId': identityId,
      'provider': provider,
      'fromUserId': fromUserId
    };

    final result = await _channel.invokeListMethod<Map<String, dynamic>>(
        'users_unlink', arguments);

    return result;
  }
}
