part of auth0_flutter;

class AuthenticationError implements Exception {
  final String code;
  final int statusCode;
  final String description;
  final Map<String, dynamic> info;

  AuthenticationError._(
      {this.code, this.statusCode, this.description, this.info});

  @override
  String toString() {
    return "AuthenticationError($statusCode, $info)";
  }

  factory AuthenticationError.from(PlatformException e) {
    final details = Map.castFrom(e.details) as Map<String, dynamic>;

    return AuthenticationError._(
        code: details['code'],
        statusCode: details['statusCode'],
        description: details['description'],
        info: details['info']);
  }
}
