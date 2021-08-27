import 'package:auth0_platform_interface/auth0_platform_interface.dart';

class WebAuth extends WebAuthPlatform {
  WebAuth({required Auth0App app}) : super(app: app);
}
