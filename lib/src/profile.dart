part of auth0_flutter;

class Profile {
  final String id;
  final String name;
  final String nickname;
  final Uri pictureURL;
  final DateTime createdAt;

  final String email;
  final bool emailVerified;
  final String givenName;
  final String familyName;

  final Map<String, dynamic> additionalAttributes;
  final List<Identity> identities;

  Profile._(
      {this.id,
      this.name,
      this.nickname,
      this.pictureURL,
      this.createdAt,
      this.email,
      this.emailVerified,
      this.givenName,
      this.familyName,
      this.additionalAttributes,
      this.identities});

  factory Profile.fromJSON(Map<String, dynamic> json) {
    final String id = json['id'];
    final String name = json['name'];
    final String nickname = json['nickname'];

    final pictureUrl = Uri.tryParse(json['pictureURL']);

    final String dateString = json['createdAt'];
    final createdAt = dateFromString(dateString);

    if (id == null &&
        name == null &&
        nickname == null &&
        pictureUrl == null &&
        createdAt == null) {
      return null;
    }

    final List<Map<String, dynamic>> identityValues = json['identities'];
    final identities = identityValues.map((v) => Identity.fromJSON(v)).toList();

    final attributes = Map<String, dynamic>.of(json);
    attributes.removeWhere((k, v) => _keys.contains(k));

    return Profile._(
        id: id,
        name: name,
        nickname: nickname,
        pictureURL: pictureUrl,
        createdAt: createdAt,
        email: json['email'],
        emailVerified: json['emailVerified'] ?? false,
        givenName: json['givenName'],
        familyName: json['familyName'],
        identities: identities,
        additionalAttributes: attributes);
  }

  static final List<String> _keys = [
    "user_id",
    "name",
    "nickname",
    "picture",
    "created_at",
    "email",
    "email_verified",
    "given_name",
    "family_name",
    "identities"
  ];
}
