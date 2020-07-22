package com.resideo.auth0_flutter;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.authentication.AuthenticationAPIClient;
import com.auth0.android.authentication.storage.CredentialsManagerException;
import com.auth0.android.authentication.storage.SecureCredentialsManager;
import com.auth0.android.authentication.storage.SharedPreferencesStorage;
import com.auth0.android.callback.BaseCallback;
import com.auth0.android.result.Credentials;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class CredentialsController implements MethodCallHandler {
    private final Registrar registrar;
    private SecureCredentialsManager _manager;

    static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.auth0_flutter.io/credentials_manager");

        channel.setMethodCallHandler(new CredentialsController(registrar));
    }

    private CredentialsController(Registrar registrar) {
        this.registrar = registrar;
    }

    private SecureCredentialsManager getCredentialsManager(MethodCall methodCall) {
        if (_manager == null) {
            final String clientId = methodCall.argument("clientId");
            final String domain = methodCall.argument("domain");

            assert clientId != null;
            assert domain != null;

            final Auth0 auth0 = new Auth0(clientId, domain);
            auth0.setOIDCConformant(true);

            final AuthenticationAPIClient apiClient = new AuthenticationAPIClient(auth0);
            final SharedPreferencesStorage storage = new SharedPreferencesStorage(registrar.activeContext());

            _manager = new SecureCredentialsManager(registrar.activeContext(), apiClient, storage);
        }

        return _manager;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
        final SecureCredentialsManager manager = getCredentialsManager(methodCall);

        switch (methodCall.method) {
            case CredentialsMethodName.enableBioMetrics: {
                registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
                    @Override
                    public boolean onActivityResult(final int requestCode, final int resultCode, Intent intent) {
                        return manager.checkAuthenticationResult(requestCode, resultCode);
                    }
                });

                final String title = methodCall.argument("title");

                final boolean success = manager.requireAuthentication(registrar.activity(), 11, title, null);

                result.success(success);

                break;
            }
            case CredentialsMethodName.storeCredentials: {
                final HashMap<String, Object> credentialsJSON = methodCall.argument("credentials");

                assert credentialsJSON != null;

                final String idToken = (String) credentialsJSON.get("id_token");
                final String accessToken = (String) credentialsJSON.get("access_token");
                final String type = (String) credentialsJSON.get("token_type");
                final String refreshToken = (String) credentialsJSON.get("refresh_token");
                final Integer expiresIn = (Integer) credentialsJSON.get("expires_in");
                final String scope = (String) credentialsJSON.get("scope");

                Date expiresAt = null;
                if (expiresIn != null) {
                    expiresAt = new Date(System.currentTimeMillis() + expiresIn * 1000);
                }

                Credentials credentials = new Credentials(idToken, accessToken, type, refreshToken, expiresAt, scope);
                try {
                    manager.saveCredentials(credentials);

                    result.success(true);
                } catch (CredentialsManagerException e) {
                    final HashMap<String, String> info = JSONHelpers.credentialsErrorToJSON(e);

                    result.error("", e.getLocalizedMessage(), info);
                }

                break;
            }
            case CredentialsMethodName.clearCredentials: {
                manager.clearCredentials();

                result.success(true);
                break;
            }
            case CredentialsMethodName.hasValidCredentials: {
                final boolean loggedIn = manager.hasValidCredentials();

                result.success(loggedIn);
                break;
            }
            case CredentialsMethodName.getCredentials: {
                registrar.activity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        manager.getCredentials(new BaseCallback<Credentials, CredentialsManagerException>() {
                            @Override
                            public void onSuccess(final Credentials payload) {
                                registrar.activity().runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);
                                        result.success(obj);
                                    }
                                });
                            }

                            @Override
                            public void onFailure(final CredentialsManagerException error) {
                                registrar.activity().runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        final Map<String, String> info = JSONHelpers.credentialsErrorToJSON(error);
                                        result.error("", error.getLocalizedMessage(), info);
                                    }
                                });
                            }
                        });
                    }
                });
                break;
            }
            default:
                result.notImplemented();
        }
    }
}

class CredentialsMethodName {
    static final String enableBioMetrics = "enableBioMetrics";
    static final String storeCredentials = "storeCredentials";
    static final String clearCredentials = "clearCredentials";
    static final String hasValidCredentials = "hasValidCredentials";
    static final String getCredentials = "getCredentials";
}

