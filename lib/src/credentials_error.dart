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

  CredentialsManagerError._({this.type, this.description});

  @override
  String toString() {
    return "Credentials Error($type, $description)";
  }

  factory CredentialsManagerError.from(PlatformException e) {
    final details = Map<String, dynamic>.from(e.details);

    final typeString = details['error_type'] as String;

    final type = _hash[typeString];

    final description = details['error_description'] as String;

    return CredentialsManagerError._(type: type, description: description);
  }
}
