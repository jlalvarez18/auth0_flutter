package com.resideo.auth0_flutter;

import android.app.Dialog;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.Auth0Exception;
import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.provider.AuthCallback;
import com.auth0.android.provider.ResponseType;
import com.auth0.android.provider.VoidCallback;
import com.auth0.android.provider.WebAuthProvider;
import com.auth0.android.result.Credentials;

import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class WebAuthController implements MethodCallHandler {
    private final Registrar registrar;

    static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.auth0_flutter.io/web_auth");

        channel.setMethodCallHandler(new WebAuthController(registrar));
    }

    private WebAuthController(Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
        final String clientId = methodCall.argument("clientId");
        final String domain = methodCall.argument("domain");

        assert clientId != null;
        assert domain != null;

        final Auth0 auth0 = new Auth0(clientId, domain);
        auth0.setOIDCConformant(true);

        switch (methodCall.method) {
            case WebAuthMethodName.start: {
                final WebAuthProvider.Builder webAuth = webAuth(auth0, methodCall);

                webAuth.start(registrar.activity(), new AuthCallback() {
                    @Override
                    public void onFailure(@NonNull Dialog dialog) {}

                    @Override
                    public void onFailure(AuthenticationException exception) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(exception);

                        final String message = exception.getLocalizedMessage();

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.error("", message, obj);
                            }
                        });
                    }

                    @Override
                    public void onSuccess(@NonNull Credentials credentials) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(credentials);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
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

                builder.start(registrar.activeContext(), new VoidCallback() {
                    @Override
                    public void onSuccess(Void payload) {
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(true);
                            }
                        });
                    }

                    @Override
                    public void onFailure(Auth0Exception error) {
                        registrar.activity().runOnUiThread(new Runnable() {
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

        final List<String> responseTypeStrings = methodCall.argument("responseType");
        assert responseTypeStrings != null;

        int t = 0;

        for (String value: responseTypeStrings) {
            switch (value) {
                case "token": {
                    t += t | ResponseType.TOKEN;
                    break;
                }
                case "idToken": {
                    t += t | ResponseType.ID_TOKEN;
                    break;
                }
                case "code": {
                    t += t | ResponseType.CODE;
                    break;
                }
            }
        }

        webAuth.withResponseType(t);

        final String nonce = methodCall.argument("nonce");
        if (nonce != null) {
            webAuth.withNonce(nonce);
        }

        HashMap<String, Object> params = methodCall.argument("parameters");
        if (params != null) {
            webAuth.withParameters(params);
        }

        return webAuth;
    }
}

class WebAuthMethodName {
    static final String start = "start";
    static final String clearSession = "clearSession";
}