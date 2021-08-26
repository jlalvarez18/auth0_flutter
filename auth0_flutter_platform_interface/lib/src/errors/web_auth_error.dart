import 'package:flutter/services.dart';

enum WebAuthErrorType {
  noBundleIdentifierFound,
  cannotDismissWebAuthController,
  userCancelled,
  pkceNotAllowed,
  noNonceProvided,
  missingResponseParam,
  invalidIdTokenNonce,
  missingAccessToken,
  unknownError
}

class WebAuthError implements Exception {
  final WebAuthErrorType type;
  final String? description;

  WebAuthError({required this.type, this.description});

  @override
  String toString() {
    return "WebAuthError($type, $description)";
  }

  factory WebAuthError.from(PlatformException e) {
    final Map<String, dynamic> details = Map.castFrom(e.details);

    return WebAuthError(
        type: _webAuthTypeFrom(details["type"]),
        description: details["description"]);
  }
}

WebAuthErrorType _webAuthTypeFrom(String? value) {
  if (value == null) {
    return WebAuthErrorType.unknownError;
  }

  switch (value) {
    case "noBundleIdentifierFound":
      return WebAuthErrorType.noBundleIdentifierFound;
    case "cannotDismissWebAuthController":
      return WebAuthErrorType.cannotDismissWebAuthController;
    case "userCancelled":
      return WebAuthErrorType.userCancelled;
    case "pkceNotAllowed":
      return WebAuthErrorType.pkceNotAllowed;
    case "noNonceProvided":
      return WebAuthErrorType.noNonceProvided;
    case "missingResponseParam":
      return WebAuthErrorType.missingResponseParam;
    case "invalidIdTokenNonce":
      return WebAuthErrorType.invalidIdTokenNonce;
    case "missingAccessToken":
      return WebAuthErrorType.missingAccessToken;
    case "unknownError":
      return WebAuthErrorType.unknownError;
  }

  return WebAuthErrorType.unknownError;
}
