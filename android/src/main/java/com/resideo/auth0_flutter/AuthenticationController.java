package com.resideo.auth0_flutter;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.authentication.AuthenticationAPIClient;
import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.callback.AuthenticationCallback;
import com.auth0.android.callback.BaseCallback;
import com.auth0.android.request.AuthenticationRequest;
import com.auth0.android.result.Credentials;
import com.auth0.android.result.UserProfile;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class AuthenticationController implements MethodCallHandler {
    private final Registrar registrar;

    static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.auth0_flutter.io/authentication");

        channel.setMethodCallHandler(new AuthenticationController(registrar));
    }

    private AuthenticationController(Registrar registrar) { this.registrar = registrar; }

    @Override
    public void onMethodCall(MethodCall call, @NonNull final Result result) {
        final String clientId = call.argument("clientId");
        final String domain = call.argument("domain");

        assert clientId != null;
        assert domain != null;

        final Auth0 auth0 = new Auth0(clientId, domain);
        auth0.setOIDCConformant(true);

        AuthenticationAPIClient authClient = new AuthenticationAPIClient(auth0);

        switch (call.method) {
            case AuthMethodName.login: {
                final String usernameOrEmail = call.argument("usernameOrEmail");
                final String password = call.argument("password");
                final String realm = call.argument("realm");

                assert usernameOrEmail != null;
                assert password != null;
                assert realm != null;

                final String audience = call.argument("audience");
                final String scope = call.argument("scope");

                final AuthenticationRequest request = authClient.login(usernameOrEmail, password, realm);

                if (audience != null) {
                    request.setAudience(audience);
                }

                if (scope != null) {
                    request.setScope(scope);
                }

                HashMap<String, Object> params = call.argument("parameters");
                if (params != null) {
                    request.addAuthenticationParameters(params);
                }

                request.start(new BaseCallback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }
//
//            case AuthMethodName.loginWithOTP: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.loginDefaultDirectory: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.createUser: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.resetPassword: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.startEmailPasswordless: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.startPhoneNumberPasswordless: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.userInfoWithToken: {
//                result.notImplemented();
//                break;
//            }

            case AuthMethodName.userInfoWithAccessToken: {
                final String accessToken = call.argument("accessToken");
                assert accessToken != null;

                authClient.userInfo(accessToken).start(new AuthenticationCallback<UserProfile>() {
                    @Override
                    public void onSuccess(UserProfile payload) {
                        final HashMap<String, Object> obj = JSONHelpers.profileTOJSON(payload);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

//            case AuthMethodName.loginSocial: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.tokenExchangeWithParameters: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.tokenExchangeWithCode: {
//                result.notImplemented();
//                break;
//            }
//            case AuthMethodName.appleTokenExchange: {
//                result.notImplemented();
//                break;
//            }

            case AuthMethodName.renew: {
                final String refreshToken = call.argument("refreshToken");
                assert refreshToken != null;

                authClient.renewAuth(refreshToken).start(new AuthenticationCallback<Credentials>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.revoke: {
                final String refreshToken = call.argument("refreshToken");

                assert refreshToken != null;

                authClient.revokeToken(refreshToken).start(new AuthenticationCallback<Void>() {
                    @Override
                    public void onSuccess(Void payload) {
                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() { result.success(true);
                            }
                        });
                    }

                    @Override
                    public void onFailure(AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }
//            case AuthMethodName.delegation: {
//                result.notImplemented();
//                break;
//            }
            default:
                result.notImplemented();
                break;
        }
    }
}

class AuthMethodName {
    static final String login = "login";
    static final String loginWithOTP = "loginWithOtp";
    static final String loginDefaultDirectory = "loginDefaultDirectory";
    static final String createUser = "createUser";
    static final String resetPassword = "resetPassword";
    static final String startEmailPasswordless = "startEmailPasswordless";
    static final String startPhoneNumberPasswordless = "startPhoneNumberPasswordless";
    static final String userInfoWithToken = "userInfoWithToken";
    static final String userInfoWithAccessToken = "userInfoWithAccessToken";
    static final String loginSocial = "loginSocial";
    static final String tokenExchangeWithParameters = "tokenExchangeWithParams";
    static final String tokenExchangeWithCode = "tokenExchangeWithCode";
    static final String appleTokenExchange = "appleTokenExchange";
    static final String renew = "renew";
    static final String revoke = "revoke";
    static final String delegation = "delegation";
}