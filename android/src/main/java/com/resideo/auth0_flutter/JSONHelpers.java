package com.resideo.auth0_flutter;

import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.result.Credentials;

import org.json.JSONException;
import org.json.JSONObject;

class JSONHelpers {
    static JSONObject credentialsToJSON(Credentials credentials) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("access_token", credentials.getAccessToken());
            obj.put("token_type", credentials.getType());
            obj.put("expires_in", credentials.getExpiresIn());
            obj.put("refresh_token", credentials.getRefreshToken());
            obj.put("id_token", credentials.getIdToken());
            obj.put("scope", credentials.getScope());
        } catch (JSONException ex) {
            ex.printStackTrace();
        }

        return obj;
    }

    static JSONObject authErrorToJSON(AuthenticationException exception) {
        JSONObject info = new JSONObject();
        try {
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
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject obj = new JSONObject();

        try {
            obj.put("code", exception.getCode());
            obj.put("statusCode", exception.getStatusCode());
            obj.put("description", exception.getDescription());
            obj.put("info", info);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return obj;
    }
}
