part of auth0_flutter;

// Top Level error
// {
//   "error": {
//     "type": "authentication" | "credentials",
//   }
// }

// Authentication error
/**
 * {
 * "info": Object,
 * "status_code": int
 * }
 */

// Credentials error
/**
 * {
 * "error_type": "no_credentials" | "no_refresh_token" | "failed_refresh" |"touch_failed",
 * "error_description": String
 * }
 */

// void _processJSONForErrors(Map<String, dynamic> json) {
//   final Map<String, dynamic> error = json['error'];

//   if (error == null) {
//     return null;
//   }

//   final String errorType = error['type'];

//   if (errorType == 'authentication') {
//     throw AuthenticationError.fromJSON(error);
//   }

//   if (errorType == 'credentials') {
//     throw CredentialsError.fromJSON(error);
//   }
// }
