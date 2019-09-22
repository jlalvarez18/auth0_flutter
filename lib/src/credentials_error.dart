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

class CredentialsError {
  final CredentialErrorType type;
  final String description;

  CredentialsError({this.type, this.description});

  factory CredentialsError.fromJSON(Map<String, dynamic> json) {
    final typeString = json['error_type'] as String;

    final type = _hash[typeString];

    final description = json['error_description'] as String;

    return CredentialsError(type: type, description: description);
  }
}
