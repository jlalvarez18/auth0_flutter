part of auth0_flutter;

enum CredentialErrorType {
  noCredentials,
  noRefreshToken,
  failedRefresh,
  touchFailed
}

final _hash = <String, CredentialErrorType>{
  'no_credentials': CredentialErrorType.noCredentials,
  'no_refresh_token': CredentialErrorType.noRefreshToken,
  'failed_refresh': CredentialErrorType.failedRefresh,
  'touch_failed': CredentialErrorType.touchFailed
};

class CredentialsManagerError implements Exception {
  final CredentialErrorType type;
  final String description;

  CredentialsManagerError({this.type, this.description});

  @override
  String toString() {
    return "Credentials Error($type, $description)";
  }

  factory CredentialsManagerError.fromJSON(Map<String, dynamic> json) {
    final typeString = json['error_type'] as String;

    final type = _hash[typeString];

    final description = json['error_description'] as String;

    return CredentialsManagerError(type: type, description: description);
  }
}
