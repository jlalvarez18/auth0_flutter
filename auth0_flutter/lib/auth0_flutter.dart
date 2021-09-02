library auth0_flutter;

import 'dart:io';

import 'package:auth0_platform_interface/auth0_platform_interface.dart';
import 'package:flutter/widgets.dart';

export 'package:auth0_platform_interface/auth0_platform_interface.dart'
    show
        Credentials,
        Auth0Options,
        AuthenticationError,
        UsersError,
        WebAuthError,
        WebAuthErrorType,
        CredentialErrorType,
        CredentialsManagerError;

part 'src/auth0.dart';
part 'src/authentication.dart';
part 'src/biometrics_options.dart';
part 'src/credentials_manager.dart';
part 'src/users.dart';
part 'src/web_auth.dart';
