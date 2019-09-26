part of auth0_flutter;

class UsersError implements Exception {
  final String code;
  final String description;

  UsersError({this.code, this.description});

  factory UsersError.from(PlatformException e) {
    final details = Map<String, dynamic>.from(e.details);

    return UsersError(
        code: details['code'], description: details['description']);
  }
}
