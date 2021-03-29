part of auth0_flutter;

class Profile {
  final String id;
  final String name;
  final String nickname;
  final DateTime createdAt;

  final Uri? pictureURL;
  final String? email;
  final bool? emailVerified;
  final String? givenName;
  final String? familyName;

  final Map<String, dynamic>? additionalAttributes;
  final List<Identity>? identities;

  Map<String, dynamic>? get userMetadata {
    return additionalAttributes?['user_metadata'];
  }

  Map<String, dynamic>? get appMetadata {
    return additionalAttributes?['app_metadata'];
  }

  Profile._({
    required this.id,
    required this.name,
    required this.nickname,
    required this.createdAt,
    this.pictureURL,
    this.email,
    this.emailVerified,
    this.givenName,
    this.familyName,
    this.additionalAttributes,
    this.identities,
  });

  factory Profile.fromJSON(Map<String, dynamic> json) {
    final String? id = json['id'];
    if (id == null) {
      throw ArgumentError.notNull('id');
    }

    final String? name = json['name'];
    if (name == null) {
      throw ArgumentError.notNull('name');
    }

    final String? nickname = json['nickname'];
    if (nickname == null) {
      throw ArgumentError.notNull('nickname');
    }

    final pictureUrl = Uri.tryParse(json['pictureURL']);

    final String? dateString = json['createdAt'];
    if (dateString == null) {
      throw ArgumentError.notNull('createdAt');
    }

    final createdAt = dateFromString(dateString);
    if (createdAt == null) {
      throw Exception('Could not parse createdAt string');
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
