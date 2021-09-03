import 'package:auth0_platform_interface/src/utils/channel_helper.dart';
import 'package:auth0_platform_interface/src/utils/channel_methods.dart';
import 'package:flutter/services.dart';

import '../../auth0_platform_interface.dart';

class Auth0MethodChannel extends Auth0Platform {
  final _channel = MethodChannel('plugins.auth0_flutter.io/core');

  Auth0MethodChannel._() : super();

  static Auth0MethodChannel _instance = Auth0MethodChannel._();
  static Auth0MethodChannel get instance => _instance;

  @override
  Future<void> initialize({Auth0Options? options}) async {
    final args = <String, String?>{
      'clientId': options?.clientId,
      'domain': options?.domain,
    };

    await invokeMethod(
      channel: _channel,
      method: Auth0Method.initialize,
      arguments: args,
      exceptionHandler: (exception) => exception,
    );
  }
}
