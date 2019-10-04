package com.resideo.auth0_flutter;

import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.authentication.storage.CredentialsManagerException;
import com.auth0.android.management.ManagementException;
import com.auth0.android.result.Credentials;

import java.util.HashMap;

class JSONHelpers {
    static HashMap<String, Object> credentialsToJSON(Credentials credentials) {
        HashMap<String, Object>  obj = new HashMap<>();
        obj.put("access_token", credentials.getAccessToken());
        obj.put("token_type", credentials.getType());
        obj.put("expires_in", credentials.getExpiresIn());
        obj.put("refresh_token", credentials.getRefreshToken());
        obj.put("id_token", credentials.getIdToken());
        obj.put("scope", credentials.getScope());

        return obj;
    }

    static HashMap<String, Object> authErrorToJSON(AuthenticationException exception) {
        HashMap<String, Object> info = new HashMap<>();
        // Android Only
        info.put("isNetworkError", exception.isNetworkError());
        info.put("isBrowserAppNotAvailable", exception.isBrowserAppNotAvailable());
        info.put("isInvalidAuthorizeURL", exception.isInvalidAuthorizeURL());
        info.put("isInvalidConfiguration", exception.isInvalidConfiguration());
        info.put("isAuthenticationCanceled", exception.isAuthenticationCanceled());
        info.put("isPasswordLeaked", exception.isPasswordLeaked());
        // Cross platform
        info.put("isMultifactorRequired", exception.isMultifactorRequired());
        info.put("isMultifactorEnrollRequired", exception.isMultifactorEnrollRequired());
        info.put("isMultifactorTokenInvalid", exception.isMultifactorTokenInvalid());
        info.put("isMultifactorCodeInvalid", exception.isMultifactorCodeInvalid());
        info.put("isPasswordNotStrongEnough", exception.isPasswordNotStrongEnough());
        info.put("isPasswordAlreadyUsed", exception.isPasswordAlreadyUsed());
        info.put("isRuleError", exception.isRuleError());
        info.put("isInvalidCredentials", exception.isInvalidCredentials());
        // Web based
        info.put("isAccessDenied", exception.isAccessDenied());
        info.put("isLoginRequired", exception.isLoginRequired());

        HashMap<String, Object> obj = new HashMap<>();
        obj.put("code", exception.getCode());
        obj.put("statusCode", exception.getStatusCode());
        obj.put("description", exception.getDescription());
        obj.put("info", info);

        return obj;
    }

    static HashMap<String, String> credentialsErrorToJSON(CredentialsManagerException exception) {
        HashMap<String, String> obj = new HashMap<>();

        // TODO: unfortunate we have to check strings to determine the type of error returned.
        final String message = exception.getMessage();
        switch (message) {
            case "No Credentials were previously set.":
                obj.put("error_type", "no_credentials");
                break;
            case "Credentials have expired and no Refresh Token was available to renew them.":
                obj.put("error_type", "no_refresh_token");
                break;
            case "An error occurred while trying to use the Refresh Token to renew the Credentials.":
                obj.put("error_type", "failed_refresh");
                break;
            default:
                obj.put("error_type", "unknown");
                break;
        }

        obj.put("error_description", exception.getLocalizedMessage());

        return obj;
    }

    static HashMap<String, String> managementExceptionToJSON(ManagementException exception) {
        HashMap<String, String> obj = new HashMap<>();
        obj.put("code", exception.getCode());
        obj.put("description", exception.getDescription());

        return obj;
    }
}
