part of auth0_flutter;

class AuthenticationError implements Exception {
  final Map<String, dynamic> info;
  final int statusCode;

  AuthenticationError._({this.info, this.statusCode});

  @override
  String toString() {
    return "AuthenticationError($statusCode, $info)";
  }

  factory AuthenticationError.from(PlatformException e) {
    final details = Map<String, dynamic>.from(e.details);

    return AuthenticationError._(
        info: details['info'], statusCode: details['statusCode']);
  }
}
