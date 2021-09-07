package com.auth0.auth0_flutter;

public class Auth0Options {
    final String clientId;
    final String domain;

    public Auth0Options(String clientId, String domain) {
        this.clientId = clientId;
        this.domain = domain;
    }
}
