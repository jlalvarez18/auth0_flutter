import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../models/auth0_app.dart';
import '../models/user_patch_attributes.dart';

abstract class UsersPlatform extends PlatformInterface {
  final String token;
  final Auth0App app;

  UsersPlatform({required this.token, required this.app})
      : super(token: _token);

  static final Object _token = Object();

  static UsersPlatform? _instance;

  static UsersPlatform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError('UsersPlatform.instance has not been set.');
  }

  static set instance(UsersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);

    _instance = instance;
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
