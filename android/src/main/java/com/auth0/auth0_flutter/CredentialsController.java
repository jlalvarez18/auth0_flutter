package com.auth0.auth0_flutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.authentication.AuthenticationAPIClient;
import com.auth0.android.authentication.storage.CredentialsManagerException;
import com.auth0.android.authentication.storage.SecureCredentialsManager;
import com.auth0.android.authentication.storage.SharedPreferencesStorage;
import com.auth0.android.callback.Callback;
import com.auth0.android.result.Credentials;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class CredentialsController implements MethodCallHandler {
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    ActivityPluginBinding activityBinding;

    private SecureCredentialsManager _manager;

    static CredentialsController registerWith(FlutterPlugin.FlutterPluginBinding binding) {
        final CredentialsController controller = new CredentialsController();

        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.auth0_flutter.io/credentials_manager");
        channel.setMethodCallHandler(controller);

        return controller;
    }

    private SecureCredentialsManager getCredentialsManager(MethodCall methodCall) {
        if (_manager == null) {
            final String clientId = methodCall.argument("clientId");
            final String domain = methodCall.argument("domain");

            assert clientId != null;
            assert domain != null;

            final Auth0 auth0 = new Auth0(clientId, domain);

            final Context context = activityBinding.getActivity().getApplicationContext();

            final AuthenticationAPIClient apiClient = new AuthenticationAPIClient(auth0);
            final SharedPreferencesStorage storage = new SharedPreferencesStorage(context);

            _manager = new SecureCredentialsManager(context, apiClient, storage);
        }

        return _manager;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
        final SecureCredentialsManager manager = getCredentialsManager(methodCall);

        switch (methodCall.method) {
            case CredentialsMethodName.enableBioMetrics: {
                activityBinding.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
                    @Override
                    public boolean onActivityResult(final int requestCode, final int resultCode, Intent intent) {
                        return manager.checkAuthenticationResult(requestCode, resultCode);
                    }
                });

                final String title = methodCall.argument("title");

                final boolean success = manager.requireAuthentication(activityBinding.getActivity(), 11, title, null);

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
                final String scope = (String) credentialsJSON.get("scope");
                final Integer expiresIn = (Integer) credentialsJSON.get("expires_in");

                assert expiresIn != null;
                assert idToken != null;
                assert accessToken != null;
                assert type != null;

                Date expiration = new Date(System.currentTimeMillis() + expiresIn * 1000);

                Credentials credentials = new Credentials(idToken, accessToken, type, refreshToken, expiration, scope);
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
                mainHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        manager.getCredentials(new Callback<Credentials, CredentialsManagerException>() {
                            @Override
                            public void onSuccess(final Credentials payload) {
                                mainHandler.post(new Runnable() {
                                    @Override
                                    public void run() {
                                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);
                                        result.success(obj);
                                    }
                                });
                            }

                            @Override
                            public void onFailure(@NonNull final CredentialsManagerException error) {
                                mainHandler.post(new Runnable() {
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

