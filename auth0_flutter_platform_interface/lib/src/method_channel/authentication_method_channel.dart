import 'package:flutter/services.dart';

import '../../auth0_platform_interface.dart';
import '../errors/authentication_error.dart';
import '../models/credentials.dart';
import '../models/database_user.dart';
import '../models/profile.dart';
import '../models/user_info.dart';
import '../platform_interface/authentication_platform_interface.dart';
import '../utils/channel_helper.dart';
import '../utils/channel_methods.dart';
import 'web_auth_method_channel.dart';

class AuthenticationMethodChannel extends AuthenticationPlatform {
  final _channel =
      const MethodChannel('plugins.auth0_flutter.io/authentication');

  AuthenticationMethodChannel._() : super();

  static AuthenticationMethodChannel _instance =
      AuthenticationMethodChannel._();
  static AuthenticationMethodChannel get instance => _instance;

  AuthenticationError _errorHandler(PlatformException e) =>
      AuthenticationError.from(e);

  bool _loggingEnabled = false;

  /// Turn on/off Auth0.swift debug logging of HTTP requests and OAuth2 flow (iOS only).
  AuthenticationMethodChannel logging({required bool enabled}) {
    _loggingEnabled = enabled;
    return this;
  }

  @override
  Future<Credentials> login({
    required String usernameOrEmail,
    required String password,
    required String realm,
    String? audience,
    String? scope,
    Map<String, String>? parameters,
  }) async {
    final args = _generateArguments({
      'usernameOrEmail': usernameOrEmail,
      'password': password,
      'realm': realm,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.login,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> loginWithOTP(String otp,
      {required String mfaToken}) async {
    final args = _generateArguments({'otp': otp, 'mfaToken': mfaToken});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginWithOTP,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> loginDefaultDirectory({
    required String username,
    required String password,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'username': username,
      'password': password,
      'audience': audience,
      'scope': scope,
      'parameters': parameters
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginDefaultDirectory,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<DatabaseUser> createUser({
    required String email,
    String? username,
    required String password,
    required String connection,
    Map<String, dynamic>? userMetadata,
    Map<String, dynamic>? rootAttributes,
  }) async {
    final args = _generateArguments({
      'email': email,
      'username': username,
      'password': password,
      'connection': connection,
      'userMetadata': userMetadata,
      'rootAttributes': rootAttributes
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.createUser,
      args,
    );

    return DatabaseUser.fromJSON(result);
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String connection,
  }) async {
    final args = _generateArguments({'email': email, 'connection': connection});

    await _invokeMethod(
      AuthenticationMethod.resetPassword,
      args,
    );
  }

  @override
  Future<void> startEmailPasswordless({
    required String email,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'email',
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({
      'email': email,
      'type': type.stringValue,
      'connection': connection,
      'parameters': parameters,
    });

    await _invokeMethod(
      AuthenticationMethod.startEmailPasswordless,
      args,
    );
  }

  @override
  Future<Credentials> loginWithEmailPasswordless({
    required String email,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'email': email,
      'code': otpCode,
      'audience': audience,
      'scope': scope,
      'parameters': parameters ?? {},
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginEmailPasswordless,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<void> startPhoneNumberPasswordless({
    required String phoneNumber,
    PasswordlessType type = PasswordlessType.code,
    String connection = 'sms',
  }) async {
    final args = _generateArguments({
      'phoneNumber': phoneNumber,
      'type': type.stringValue,
      'connection': connection
    });

    await _invokeMethod(
      AuthenticationMethod.startPhoneNumberPasswordless,
      args,
    );
  }

  @override
  Future<Credentials> loginWithPhoneNumberPasswordless({
    required String phoneNumber,
    required String otpCode,
    String? audience,
    String? scope,
    Map<String, dynamic>? parameters,
  }) async {
    final args = _generateArguments({
      'phoneNumber': phoneNumber,
      'code': otpCode,
      'audience': audience,
      'scope': scope,
      'parameters': parameters ?? {},
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginPhoneNumberPasswordless,
      args,
    );

    return Credentials.fromJSON(result);
  }

  /// Returns user information by performing a request to /userinfo endpoint.
  /// - warning: for OIDC-conformant clients please use `userInfo(withAccessToken accessToken:)`
  @Deprecated(
      'Please use userInfoWithAccessToken. OIDC conformance is now default.')
  Future<Profile> userInfoWithToken(String token) async {
    throw PlatformException(code: 'code');
  }

  /// Returns OIDC standard claims information by performing a request
  ///  to /userinfo endpoint.
  /// - important: This method should be used for OIDC Conformant clients.
  @override
  Future<UserInfo> userInfoWithAccessToken(String accessToken) async {
    final args = _generateArguments({'accessToken': accessToken});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.userInfoWithAccessToken,
      args,
    );

    return UserInfo.fromJSON(result);
  }

  @Deprecated('Use loginFacebook for Facebook login instead')
  Future<Credentials> loginSocial({
    required String token,
    required String connection,
    String scope = 'openid',
    required Map<String, dynamic> parameters,
  }) async {
    throw PlatformException(code: '');
  }

  @override
  Future<Credentials> loginFacebook({
    required String sessionAccessToken,
    required Map<String, dynamic> profile,
    String scope = 'openid profile offline_access',
    String? audience,
  }) async {
    final args = _generateArguments({
      'sessionAccessToken': sessionAccessToken,
      'profile': profile,
      'scope': scope,
      'audience': audience,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.loginFacebook,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> tokenExchangeWithParameters({
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({'parameters': parameters});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.tokenExchangeWithParameters,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> tokenExchangeWithCode({
    required String code,
    required String codeVerifier,
    required String redirectURI,
  }) async {
    final args = _generateArguments({
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectURI': redirectURI
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.tokenExchangeWithCode,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> appleTokenExchange({
    required String authCode,
    String? scope,
    String? audience,
  }) async {
    final args = _generateArguments({
      'authCode': authCode,
      'scope': scope,
      'audience': audience,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.appleTokenExchange,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<Credentials> renew({
    required String refreshToken,
    String? scope,
  }) async {
    final args = _generateArguments({
      'refreshToken': refreshToken,
      'scope': scope,
    });

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.renew,
      args,
    );

    return Credentials.fromJSON(result);
  }

  @override
  Future<void> revoke({required String refreshToken}) async {
    final args = _generateArguments({'refreshToken': refreshToken});

    await _invokeMethod(
      AuthenticationMethod.revoke,
      args,
    );
  }

  @override
  Future<Map<String, dynamic>> delegation({
    required Map<String, dynamic> parameters,
  }) async {
    final args = _generateArguments({'parameters': parameters});

    final result = await _invokeMapMethod<String, dynamic>(
      AuthenticationMethod.delegation,
      args,
    );

    return result;
  }

  @override
  WebAuthMethodChannel webAuthWithConnection(String connection) {
    return WebAuthMethodChannel.instance.connection(connection);
  }

  Map<String, dynamic> _generateArguments(Map<String, dynamic>? other) {
    final options = Auth0Platform.instance.options;

    final args = <String, dynamic>{
      'clientId': options?.clientId,
      'domain': options?.domain,
      'loggingEnabled': _loggingEnabled,
    };

    if (other != null) {
      args.addAll(other);
    }

    return args;
  }

  Future<Map<K, V>> _invokeMapMethod<K, V>(
      AuthenticationMethod method, dynamic arguments) async {
    final value = await invokeMapMethod<K, V>(
      channel: _channel,
      method: method.stringValue,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );

    if (value == null) {
      throw Exception('Unknown Error');
    }

    return value;
  }

  Future<void> _invokeMethod(
    AuthenticationMethod method,
    dynamic arguments,
  ) async {
    return invokeMethod(
      channel: _channel,
      method: method.stringValue,
      arguments: arguments,
      exceptionHandler: _errorHandler,
    );
  }
}
