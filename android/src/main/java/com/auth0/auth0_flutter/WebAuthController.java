package com.auth0.auth0_flutter;

import android.app.Dialog;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.Auth0Exception;
import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.callback.Callback;
import com.auth0.android.provider.AuthCallback;

import com.auth0.android.provider.WebAuthProvider;
import com.auth0.android.result.Credentials;

import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class WebAuthController implements MethodCallHandler {
    private final Handler mainHandler = new Handler(Looper.getMainLooper());
    private final FlutterPluginBinding binding;

    ActivityPluginBinding activityBinding;

    private WebAuthController(FlutterPluginBinding binding) {
        this.binding = binding;
    }

    static WebAuthController registerWith(FlutterPluginBinding binding) {
        final WebAuthController controller = new WebAuthController(binding);
        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.auth0_flutter.io/web_auth");

        channel.setMethodCallHandler(controller);

        return controller;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
        final String clientId = methodCall.argument("clientId");
        final String domain = methodCall.argument("domain");

        assert clientId != null;
        assert domain != null;

        final Auth0 auth0 = new Auth0(clientId, domain);

        switch (methodCall.method) {
            case WebAuthMethodName.start: {
                final WebAuthProvider.Builder webAuth = webAuth(auth0, methodCall);

                webAuth.start(activityBinding.getActivity(), new Callback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials credentials) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(credentials);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException exception) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(exception);
                        final String message = exception.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case WebAuthMethodName.clearSession: {
                final WebAuthProvider.LogoutBuilder builder = WebAuthProvider.logout(auth0);

                final String scheme = methodCall.argument("scheme");
                if (scheme != null) {
                    builder.withScheme(scheme);
                }

                builder.start(binding.getApplicationContext(), new Callback<Void, AuthenticationException>() {
                    @Override
                    public void onSuccess(Void unused) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(true);
                            }
                        });
                    }

                    @Override
                    public void onFailure(AuthenticationException e) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(false);
                            }
                        });
                    }
                });
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    }

    private WebAuthProvider.Builder webAuth(Auth0 auth0, MethodCall methodCall) {
        final WebAuthProvider.Builder webAuth = WebAuthProvider.login(auth0);

        final String scheme = methodCall.argument("scheme");
        if (scheme != null) {
            webAuth.withScheme(scheme);
        }

        final String nonce = methodCall.argument("nonce");
        if (nonce != null) {
            webAuth.withNonce(nonce);
        }

        final HashMap<String, Object> params = methodCall.argument("parameters");
        if (params != null) {
            webAuth.withParameters(params);
        }

        final String connectionScope = methodCall.argument("connection_scope");
        if (connectionScope != null) {
            webAuth.withConnectionScope(connectionScope);
        }

        return webAuth;
    }
}

class WebAuthMethodName {
    static final String start = "start";
    static final String clearSession = "clearSession";
}