import 'package:auth0_platform_interface/auth0_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class Auth0Platform extends PlatformInterface {
  final Auth0Options? options;

  Auth0Platform._({this.options}) : super(token: _token);

  static Auth0Platform initialize({Auth0Options? options}) {
    _instance = Auth0Platform._(options: options);

    return instance;
  }

  static final Object _token = Object();

  static Auth0Platform? _instance;

  static Auth0Platform get instance {
    if (_instance != null) {
      return _instance!;
    }

    throw AssertionError("You must call initialze() first!");
  }

  static set instance(Auth0Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
