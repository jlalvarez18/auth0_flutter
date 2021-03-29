part of auth0_flutter;

class UserPatchAttributes {
  final Map<String, dynamic> _dictionary;

  UserPatchAttributes(this._dictionary);

  UserPatchAttributes blocked(bool blocked) {
    _dictionary['blocked'] = blocked;
    return this;
  }

  UserPatchAttributes email(
      {required String email,
      bool? verified,
      bool? verify,
      required String connection,
      required String clientId}) {
    _dictionary['email'] = email;
    _dictionary['verify_email'] = verify;
    _dictionary['email_verified'] = verified;
    _dictionary['connection'] = connection;
    _dictionary['client_id'] = clientId;

    return this;
  }

  UserPatchAttributes emailVerified(
      {required bool verified, required String connection}) {
    _dictionary['email_verified'] = verified;
    _dictionary['connection'] = connection;

    return this;
  }

  UserPatchAttributes phoneNumber(
      {required String phoneNumber,
      bool? verified,
      bool? verify,
      required String connection,
      required String clientId}) {
    _dictionary["phone_number"] = phoneNumber;
    _dictionary["verify_phone_number"] = verify;
    _dictionary["phone_verified"] = verified;
    _dictionary["connection"] = connection;
    _dictionary["client_id"] = clientId;

    return this;
  }

  UserPatchAttributes phoneVerified(
      {required bool verified, required String connection}) {
    _dictionary["phone_verified"] = verified;
    _dictionary["connection"] = connection;

    return this;
  }

  UserPatchAttributes password(
      {required String password, bool? verify, required String connection}) {
    _dictionary["password"] = password;
    _dictionary["connection"] = connection;
    _dictionary["verify_password"] = verify;

    return this;
  }

  UserPatchAttributes username(
      {required String username, required String connection}) {
    _dictionary["username"] = username;
    _dictionary["connection"] = connection;

    return this;
  }

  UserPatchAttributes userMetadata(Map<String, dynamic> metadata) {
    _dictionary["user_metadata"] = metadata;

    return this;
  }

  UserPatchAttributes appMetadata(Map<String, dynamic> metadata) {
    _dictionary["app_metadata"] = metadata;

    return this;
  }
}
