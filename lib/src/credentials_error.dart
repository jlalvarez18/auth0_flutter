part of auth0_flutter;

enum CredentialErrorType {
  noCredentials,
  noRefreshToken,
  failedRefresh,
  touchFailed
}

class CredentialsError {
  final CredentialErrorType type;
  final String description;

  CredentialsError({this.type, this.description});

  factory CredentialsError.fromJSON(Map<String, dynamic> json) {
    final typeString = json['credentials_error_type'] as String;

    CredentialErrorType type;

    if (typeString == 'no_credentials') {
      type = CredentialErrorType.noCredentials;
    } else if (typeString == 'no_refresh_token') {
      type = CredentialErrorType.noRefreshToken;
    } else if (typeString == 'failed_refresh') {
      type = CredentialErrorType.failedRefresh;
    } else if (typeString == 'touch_failed') {
      type = CredentialErrorType.touchFailed;
    }

    final description = json['credentials_error_description'] as String;

    return CredentialsError(type: type, description: description);
  }
}
