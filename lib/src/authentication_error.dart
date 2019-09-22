part of auth0_flutter;

class AuthenticationError {
  final Map<String, dynamic> info;
  final int statusCode;

  AuthenticationError({this.info, this.statusCode});

  factory AuthenticationError.fromJSON(
      Map<String, dynamic> json, int statusCode) {
    return AuthenticationError(info: json, statusCode: statusCode);
  }
}
