class UserPatchAttributes {
  final Map<String, dynamic> _attributes;

  UserPatchAttributes(Map<String, dynamic> attributes)
      : this._attributes = Map.of(attributes);

  Map<String, dynamic> get attributes => _attributes;

  UserPatchAttributes blocked(bool blocked) {
    _attributes['blocked'] = blocked;

    return this;
  }

  UserPatchAttributes email({
    required String email,
    bool? verified,
    bool? verify,
    required String connection,
    required String clientId,
  }) {
    _attributes['email'] = email;
    _attributes['verify_email'] = verify;
    _attributes['email_verified'] = verified;
    _attributes['connection'] = connection;
    _attributes['client_id'] = clientId;

    return this;
  }

  UserPatchAttributes emailVerified({
    required bool verified,
    required String connection,
  }) {
    _attributes['email_verified'] = verified;
    _attributes['connection'] = connection;

    return this;
  }

  UserPatchAttributes phoneNumber({
    required String phoneNumber,
    bool? verified,
    bool? verify,
    required String connection,
    required String clientId,
  }) {
    _attributes["phone_number"] = phoneNumber;
    _attributes["verify_phone_number"] = verify;
    _attributes["phone_verified"] = verified;
    _attributes["connection"] = connection;
    _attributes["client_id"] = clientId;

    return this;
  }

  UserPatchAttributes phoneVerified({
    required bool verified,
    required String connection,
  }) {
    _attributes["phone_verified"] = verified;
    _attributes["connection"] = connection;

    return this;
  }

  UserPatchAttributes password({
    required String password,
    bool? verify,
    required String connection,
  }) {
    _attributes["password"] = password;
    _attributes["connection"] = connection;
    _attributes["verify_password"] = verify;

    return this;
  }

  UserPatchAttributes username({
    required String username,
    required String connection,
  }) {
    _attributes["username"] = username;
    _attributes["connection"] = connection;

    return this;
  }

  UserPatchAttributes userMetadata(Map<String, dynamic> metadata) {
    _attributes["user_metadata"] = metadata;

    return this;
  }

  UserPatchAttributes appMetadata(Map<String, dynamic> metadata) {
    _attributes["app_metadata"] = metadata;

    return this;
  }
}
