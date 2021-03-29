part of auth0_flutter;

class UsersError implements Exception {
  final String? code;
  final String? description;

  UsersError._({this.code, this.description});

  @override
  String toString() {
    return "UsersError($code, $description)";
  }

  factory UsersError.from(PlatformException e) {
    final Map<String, dynamic> details = Map.castFrom(e.details);

    return UsersError._(
        code: details['code'], description: details['description']);
  }
}
