part of auth0_flutter;

class AuthenticationError implements Exception {
  final Map<String, dynamic> info;
  final int statusCode;

  AuthenticationError._({this.info, this.statusCode});

  @override
  String toString() {
    return "AuthenticationError($statusCode, $info)";
  }

  factory AuthenticationError.fromJSON(Map<String, dynamic> json) {
    final statusCode = json.remove('status_code');
    final info = json;

    return AuthenticationError._(info: info, statusCode: statusCode);
  }
}
