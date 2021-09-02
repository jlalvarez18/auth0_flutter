import 'package:auth0_platform_interface/src/method_channel/users_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/user_patch_attributes.dart';

abstract class UsersPlatform extends PlatformInterface {
  final String token;

  UsersPlatform({required this.token}) : super(token: _token);

  static final Object _token = Object();

  static UsersPlatform? _instance;

  static UsersPlatform get instance {
    _instance ??= UsersMethodChannel.instance;

    return _instance!;
  }

  static set instance(UsersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
  }

  factory UsersPlatform.instanceWith({required String token}) {
    return UsersPlatform.instance.delegateWith(token: token);
  }

  UsersMethodChannel delegateWith({required String token}) {
    throw UnimplementedError('delegateWith() has not been implemented.');
  }

  Future<Map<String, dynamic>?> get({
    required String identifier,
    List<String> fields = const [],
    bool include = true,
  }) {
    throw UnimplementedError('get() has not been implemented.');
  }

  Future<Map<String, dynamic>?> patch({
    required String identifier,
    required UserPatchAttributes attributes,
  }) {
    throw UnimplementedError('patch() has not been implemented.');
  }

  Future<Map<String, dynamic>?> patchWithUserMetadata({
    required String identifier,
    required Map<String, dynamic> userMetadata,
  }) {
    throw UnimplementedError(
        'patchWithUserMetadata() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>?> linkWithOtherUserToken({
    required String identifier,
    required String token,
  }) {
    throw UnimplementedError(
        'linkWithOtherUserToken() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>?> linkWithUserId({
    required String identifier,
    required String userId,
    required String provider,
    String? connectionId,
  }) {
    throw UnimplementedError('linkWithUserId() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>?> unlink({
    required String identityId,
    required String provider,
    required String fromUserId,
  }) {
    throw UnimplementedError('unlink() has not been implemented.');
  }
}
