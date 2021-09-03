import 'package:auth0_platform_interface/auth0_platform_interface.dart';
import 'package:auth0_platform_interface/src/method_channel/auth0_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class Auth0Platform extends PlatformInterface {
  final Auth0Options? options;

  Auth0Platform({this.options}) : super(token: _token);

  static final Object _token = Object();

  static Auth0Platform? _instance;

  static Auth0Platform get instance {
    _instance ??= Auth0MethodChannel.instance;

    return _instance!;
  }

  static set instance(Auth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize({Auth0Options? options}) {
    throw UnimplementedError('initialize() has not been implemented');
  }
}
