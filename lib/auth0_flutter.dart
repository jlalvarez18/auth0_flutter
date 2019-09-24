library auth0_flutter;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:auth0_flutter/src/channel_methods.dart';
import 'package:auth0_flutter/src/identity.dart';

part 'src/date.dart';
part 'src/authentication.dart';
part 'src/credentials.dart';
part 'src/web_auth.dart';
part 'src/database_user.dart';
part 'src/profile.dart';
part 'src/user_info.dart';
part 'src/users.dart';
part 'src/user_patch_attributes.dart';
part 'src/error_handling.dart';
part 'src/authentication_error.dart';
part 'src/credentials_manager.dart';
part 'src/credentials_error.dart';

class Auth0 {
  static const MethodChannel _channel = const MethodChannel('auth0_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static WebAuth webAuth({String clientId, String domain}) {
    return WebAuth._(clientId: clientId, domain: domain, channel: _channel);
  }

  static Authentication authentication({String clientId, String domain}) {
    return Authentication._(
        clientId: clientId, domain: domain, channel: _channel);
  }

  static Future<bool> resumeAuth(Uri url, Map<String, dynamic> options) async {
    final arguments = <String, dynamic>{
      'url': url.toString(),
      'options': options
    };

    final bool result =
        await _channel.invokeMethod(Auth0Method.resumeAuth, arguments);

    return result;
  }

  static Users users({String token, String domain}) {
    return Users._(token: token, domain: domain, channel: _channel);
  }
}
