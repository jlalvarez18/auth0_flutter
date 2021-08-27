import 'package:auth0_platform_interface/auth0_platform_interface.dart';

class Users extends UsersPlatform {
  Users({required String token, required Auth0App app})
      : super(token: token, app: app);
}
