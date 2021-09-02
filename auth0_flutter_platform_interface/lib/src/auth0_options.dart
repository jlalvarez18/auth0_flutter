class Auth0Options {
  final String clientId;
  final String domain;

  Auth0Options({required this.clientId, required this.domain});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Auth0Options &&
        other.clientId == clientId &&
        other.domain == domain;
  }

  @override
  int get hashCode => clientId.hashCode ^ domain.hashCode;

  @override
  String toString() => 'Auth0Options(clientId: $clientId, domain: $domain)';
}
