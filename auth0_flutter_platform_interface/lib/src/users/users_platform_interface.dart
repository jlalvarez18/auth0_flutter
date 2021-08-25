import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'user_patch_attributes.dart';

abstract class UsersPlatform extends PlatformInterface {
  final String token;
  final String domain;

  UsersPlatform({
    required this.token,
    required this.domain,
  }) : super(token: _token);

  static final Object _token = Object();

  Future<Map<String, dynamic>?> get({
    required String identifier,
    List<String> fields = const [],
    bool include = true,
  });

  Future<Map<String, dynamic>?> patch({
    required String identifier,
    required UserPatchAttributes attributes,
  });

  Future<Map<String, dynamic>?> patchWithUserMetadata({
    required String identifier,
    required Map<String, dynamic> userMetadata,
  });

  Future<List<Map<String, dynamic>>?> linkWithOtherUserToken({
    required String identifier,
    required String token,
  });

  Future<List<Map<String, dynamic>>?> linkWithUserId({
    required String identifier,
    required String userId,
    required String provider,
    String? connectionId,
  });

  Future<List<Map<String, dynamic>>?> unlink({
    required String identityId,
    required String provider,
    required String fromUserId,
  });
}
