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
part 'src/authentication_error.dart';
part 'src/credentials_manager.dart';
part 'src/credentials_error.dart';
part 'src/users_error.dart';
part 'src/web_auth_error.dart';

class Auth0 {
  final String clientId;
  final String domain;

  Auth0({@required this.clientId, @required this.domain})
      : assert(clientId != null),
        assert(domain != null);

  WebAuth webAuth() {
    return WebAuth._(clientId: clientId, domain: domain);
  }

  Authentication authentication() {
    return Authentication._(clientId: clientId, domain: domain);
  }

  Users users({String token}) {
    return Users._(token: token, domain: domain);
  }

  CredentialsManager credentialsManager() {
    return CredentialsManager(clientId: clientId, domain: domain);
  }
}
