import 'package:auth0_platform_interface/auth0_platform_interface.dart';

class Authentication extends AuthenticationPlatform {
  Authentication({required Auth0App app}) : super(app: app);
}
