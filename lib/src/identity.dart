class Identity {
  final String identifier;
  final String provider;
  final String connection;

  final bool social;
  final Map<String, dynamic> profileData;

  final String accessToken;
  final DateTime expiresIn;
  final String accessTokenSecret;

  Identity(
      {this.identifier,
      this.provider,
      this.connection,
      this.social,
      this.profileData,
      this.accessToken,
      this.expiresIn,
      this.accessTokenSecret});

  factory Identity.fromJSON(Map<String, dynamic> json) {
    final identifier = json['user_id'];
    final provider = json['provider'];
    final connection = json['connection'];

    if (identifier == null && provider == null && connection == null) {
      return null;
    }

    final social = json['isSocial'] ?? false;
    final profileData = json['profileData'] ?? {};

    final accessToken = json['access_token'];
    final accessTokenSecret = json['access_token_secret'];

    DateTime expiresIn;
    final expiresInSeconds = json['expires_in'];

    if (expiresInSeconds is int) {
      expiresIn = DateTime.fromMillisecondsSinceEpoch(
          expiresInSeconds * Duration.millisecondsPerSecond);
    } else {
      expiresIn = null;
    }

    return Identity(
        identifier: identifier,
        provider: provider,
        connection: connection,
        social: social,
        profileData: profileData,
        accessToken: accessToken,
        expiresIn: expiresIn,
        accessTokenSecret: accessTokenSecret);
  }
}
