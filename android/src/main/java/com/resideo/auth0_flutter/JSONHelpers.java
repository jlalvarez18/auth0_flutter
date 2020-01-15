package com.resideo.auth0_flutter;

import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.authentication.storage.CredentialsManagerException;
import com.auth0.android.management.ManagementException;
import com.auth0.android.result.Credentials;
import com.auth0.android.result.UserIdentity;
import com.auth0.android.result.UserProfile;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    static HashMap<String, Object> profileTOJSON(UserProfile profile) {
        HashMap<String, Object> obj = new HashMap<>();
        obj.put("id", profile.getId());
        obj.put("sub", profile.getId());
        obj.put("name", profile.getName());
        obj.put("givenName", profile.getGivenName());
        obj.put("familyName", profile.getFamilyName());
        obj.put("nickname", profile.getNickname());

        obj.put("pictureURL", profile.getPictureURL());

        Date createdAt = profile.getCreatedAt();
        if (createdAt != null) {
            long milli = createdAt.getTime();
            long secs = milli / 1000;

            obj.put("createdAt", secs);
        }

        obj.put("email", profile.getEmail());
        obj.put("emailVerified", profile.isEmailVerified());

        final Map<String, Object> extraInfo = profile.getExtraInfo();
        extraInfo.put("user_metadata", profile.getUserMetadata());
        extraInfo.put("app_metadata", profile.getAppMetadata());

        obj.put("additionalAttributes", extraInfo);
        obj.put("user_metadata", profile.getUserMetadata());
        obj.put("app_metadata", profile.getAppMetadata());

        final List<UserIdentity> identities = profile.getIdentities();
        obj.put("identities", identitiesToJSON(identities));

        return obj;
    }

    static ArrayList<HashMap<String, Object>> identitiesToJSON(List<UserIdentity> identities) {
        if (identities == null) {
            return new ArrayList<>();
        }

        final ArrayList<HashMap<String, Object>> identitiesJSON = new ArrayList<>();

        for (UserIdentity identity : identities) {
            identitiesJSON.add(identityToJSON(identity));
        }

        return identitiesJSON;
    }

    static HashMap<String, Object> identityToJSON(UserIdentity identity) {
        HashMap<String, Object> obj = new HashMap<>();
        obj.put("identifier", identity.getId());
        obj.put("provider", identity.getProvider());
        obj.put("connection", identity.getConnection());
        obj.put("social", identity.isSocial());
        obj.put("profileData", identity.getProfileInfo());
        obj.put("accessToken", identity.getAccessToken());
        obj.put("accessTokenSecret", identity.getAccessTokenSecret());

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

        if (exception.isAuthenticationCanceled()) {
            obj.put("type", "userCancelled");
        } else {
            obj.put("type", "unknownError");
        }

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
