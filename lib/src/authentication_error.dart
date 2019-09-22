part of auth0_flutter;

class AuthenticationError {
  final Map<String, dynamic> info;
  final int statusCode;

  AuthenticationError._({this.info, this.statusCode});

  factory AuthenticationError.fromJSON(Map<String, dynamic> json) {
    final statusCode = json.remove('status_code');
    final info = json;

    return AuthenticationError._(info: info, statusCode: statusCode);
  }
}
