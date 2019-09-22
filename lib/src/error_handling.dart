part of auth0_flutter;

void _processJSONForErrors(Map<String, dynamic> result) {
  final Map<String, dynamic> error = result['error'];

  if (error == null) {
    return null;
  }

  final String errorType = error['type'];

  if (errorType == 'authentication_error') {
    throw AuthenticationError.fromJSON(error, error['status_code']);
  }

  if (errorType == 'credentials_error') {
    throw CredentialsError.fromJSON(error);
  }
}
