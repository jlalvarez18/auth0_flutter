class DatabaseUser {
  final String? email;
  final String? username;
  final bool? verified;

  DatabaseUser._({this.email, this.username, this.verified});

  factory DatabaseUser.fromJSON(Map<String, dynamic> json) {
    return DatabaseUser._(
        email: json['email'],
        username: json['username'],
        verified: json['verified']);
  }
}
