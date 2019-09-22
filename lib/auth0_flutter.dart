library auth0_flutter;

import 'dart:async';

import 'package:auth0_flutter/src/authentication_error.dart';
import 'package:auth0_flutter/src/identity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'src/date.dart';
part 'src/authentication.dart';
part 'src/credentials.dart';
part 'src/web_auth.dart';
part 'src/database_user.dart';
part 'src/profile.dart';
part 'src/user_info.dart';
part 'src/users.dart';
part 'src/user_patch_attributes.dart';

class Auth0Flutter {
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

    final bool result = await _channel.invokeMethod('resumeAuth', arguments);

    return result;
  }

  static Users users({String token, String domain}) {
    return Users._(token: token, domain: domain, channel: _channel);
  }
}
