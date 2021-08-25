import 'package:flutter/services.dart';

import '../utils/channel_helper.dart';
import '../utils/channel_methods.dart';
import 'user_patch_attributes.dart';
import 'users_error.dart';
import 'users_platform_interface.dart';

const _channel = MethodChannel('plugins.auth0_flutter.io/users');

class UsersMethodChannel extends UsersPlatform {
  UsersError _errorHandler(PlatformException e) => UsersError.from(e);

  UsersMethodChannel({
    required String token,
    required String domain,
  }) : super(domain: domain, token: token);

  @override
  Future<Map<String, dynamic>?> get({
    required String identifier,
    List<String> fields = const [],
    bool include = true,
  }) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'fields': fields,
      'include': include,
    });

    final result = await invokeMapMethod<String, dynamic>(
      channel: _channel,
      method: UsersMethod.get,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  @override
  Future<Map<String, dynamic>?> patch({
    required String identifier,
    required UserPatchAttributes attributes,
  }) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'attributes': attributes.attributes,
    });

    final result = await invokeMapMethod<String, dynamic>(
      channel: _channel,
      method: UsersMethod.patchAttributes,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  @override
  Future<Map<String, dynamic>?> patchWithUserMetadata({
    required String identifier,
    required Map<String, dynamic> userMetadata,
  }) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'userMetadata': userMetadata,
    });

    final result = await invokeMapMethod<String, dynamic>(
      channel: _channel,
      method: UsersMethod.patchUserMetadata,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>?> linkWithOtherUserToken({
    required String identifier,
    required String token,
  }) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'token': token,
    });

    final result = await invokeListMethod<Map<String, dynamic>>(
      channel: _channel,
      method: UsersMethod.linkWithOtherUserToken,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>?> linkWithUserId({
    required String identifier,
    required String userId,
    required String provider,
    String? connectionId,
  }) async {
    final arguments = _generateArguments({
      'identifier': identifier,
      'userId': userId,
      'provider': provider,
      'connectionId': connectionId,
    });

    final result = await invokeListMethod<Map<String, dynamic>>(
      channel: _channel,
      method: UsersMethod.linkWithUserId,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>?> unlink({
    required String identityId,
    required String provider,
    required String fromUserId,
  }) async {
    final arguments = _generateArguments({
      'identityId': identityId,
      'provider': provider,
      'fromUserId': fromUserId,
    });

    final result = await invokeListMethod<Map<String, dynamic>>(
      channel: _channel,
      method: UsersMethod.unlink,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    return result;
  }

  Map<String, dynamic> _generateArguments(Map<String, dynamic>? other) {
    final args = <String, dynamic>{
      'token': token,
      'domain': domain,
    };

    if (other != null) {
      args.addAll(other);
    }

    return args;
  }
}
