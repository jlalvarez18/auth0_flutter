package com.auth0.auth0_flutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.authentication.AuthenticationAPIClient;
import com.auth0.android.authentication.AuthenticationException;
import com.auth0.android.authentication.PasswordlessType;
import com.auth0.android.callback.AuthenticationCallback;
import com.auth0.android.callback.Callback;
import com.auth0.android.request.AuthenticationRequest;
import com.auth0.android.request.Request;
import com.auth0.android.result.Credentials;
import com.auth0.android.result.DatabaseUser;
import com.auth0.android.result.UserProfile;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AuthenticationController implements MethodCallHandler {
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    static void registerWith(FlutterPluginBinding binding) {
        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.auth0_flutter.io/authentication");

        channel.setMethodCallHandler(new AuthenticationController());
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull final Result result) {
        final String clientId = call.argument("clientId");
        final String domain = call.argument("domain");

        assert clientId != null;
        assert domain != null;

        final Auth0 auth0 = new Auth0(clientId, domain);

        AuthenticationAPIClient authClient = new AuthenticationAPIClient(auth0);

        switch (call.method) {
            case AuthMethodName.login: {
                final String usernameOrEmail = call.argument("usernameOrEmail");
                final String password = call.argument("password");
                final String realm = call.argument("realm");

                assert usernameOrEmail != null;
                assert password != null;
                assert realm != null;

                final AuthenticationRequest request = authClient.login(usernameOrEmail, password, realm);

                final String audience = call.argument("audience");
                if (audience != null) {
                    request.setAudience(audience);
                }

                final String scope = call.argument("scope");
                if (scope != null) {
                    request.setScope(scope);
                }

                HashMap<String, String> params = call.argument("parameters");
                if (params != null) {
                    request.addParameters(params);
                }

                request.start(new AuthenticationCallback<Credentials>() {
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
                    public void onFailure(@NonNull AuthenticationException e) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(e);

                        final String message = e.getLocalizedMessage();

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

            case AuthMethodName.loginWithOTP: {
                final String otp = call.argument("otp");
                final String mfaToken = call.argument("mfaToken");

                assert otp != null;
                assert mfaToken != null;

                authClient.loginWithOTP(mfaToken, otp).start(new Callback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

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
//            case AuthMethodName.loginDefaultDirectory: {
//                result.notImplemented();
//                break;
//            }

            case AuthMethodName.createUser: {
                final String email = call.argument("email");
                final String username = call.argument("username");
                final String password = call.argument("password");
                final String connection = call.argument("connection");

                assert email != null;
                assert password != null;
                assert connection != null;

                final Request<DatabaseUser, AuthenticationException> request;

                if (username != null) {
                    request = authClient.createUser(email, password, username, connection);
                } else {
                    request = authClient.createUser(email, password, connection);
                }

                request.start(new Callback<DatabaseUser, AuthenticationException>() {
                    @Override
                    public void onSuccess(DatabaseUser payload) {
                        final HashMap<String, Object> obj = JSONHelpers.databaseUserToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.resetPassword: {
                final String email = call.argument("email");
                final String connection = call.argument("connection");

                assert email != null;
                assert connection != null;

                authClient.resetPassword(email, connection).start(new Callback<Void, AuthenticationException>() {
                    @Override
                    public void onSuccess(Void payload) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(null);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.startEmailPasswordless: {
                final String email = call.argument("email");
                final String typeString = call.argument("type");

                assert email != null;
                assert typeString != null;

                final PasswordlessType type = PasswordlessType.valueOf(typeString);

                authClient.passwordlessWithEmail(email, type).start(new Callback<Void, AuthenticationException>() {
                    @Override
                    public void onSuccess(Void payload) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(null);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.startPhoneNumberPasswordless: {
                final String phoneNumber = call.argument("phoneNumber");
                final String typeString = call.argument("type");

                assert phoneNumber != null;
                assert typeString != null;

                final PasswordlessType type = PasswordlessType.valueOf(typeString);

                authClient.passwordlessWithSMS(phoneNumber, type).start(new Callback<Void, AuthenticationException>() {
                    @Override
                    public void onSuccess(Void payload) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(null);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.loginEmailPasswordless: {
                final String email = call.argument("email");
                final String code = call.argument("code");

                assert email != null;
                assert code != null;

                authClient.loginWithEmail(email, code).start(new Callback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.loginPhoneNumberPasswordless: {
                final String phoneNumber = call.argument("phoneNumber");
                final String code = call.argument("code");

                assert phoneNumber != null;
                assert code != null;

                authClient.loginWithPhoneNumber(phoneNumber, code).start(new Callback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.userInfoWithAccessToken: {
                final String accessToken = call.argument("accessToken");
                assert accessToken != null;

                authClient.userInfo(accessToken).start(new AuthenticationCallback<UserProfile>() {
                    @Override
                    public void onSuccess(UserProfile payload) {
                        final HashMap<String, Object> obj = JSONHelpers.profileTOJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }

            case AuthMethodName.loginFacebook: {
                final String token = call.argument("sessionAccessToken");
                final Map<String, String> profile = call.argument("profile");
                final String scope = call.argument("scope");

                assert token != null;
                assert profile != null;
                assert scope != null;

                final JSONObject profileJson = new JSONObject(profile);

                Map<String, String> params = new HashMap<>();
                params.put("user_profile", profileJson.toString());

                final String tokenType = "http://auth0.com/oauth/token-type/facebook-info-session-access-token";

                final AuthenticationRequest request = (AuthenticationRequest) authClient
                        .loginWithNativeSocialToken(token, tokenType)
                        .setScope(scope)
                        .addParameters(params);

                final String audience = call.argument("audience");
                if (audience != null) {
                    request.setAudience(audience);
                }

                request.start(new Callback<Credentials, AuthenticationException>() {
                    @Override
                    public void onSuccess(Credentials payload) {
                        final HashMap<String, Object> obj = JSONHelpers.credentialsToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() { result.error("", message, obj);
                            }
                        });
                    }
                });
                break;
            }
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

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

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

            case AuthMethodName.revoke: {
                final String refreshToken = call.argument("refreshToken");

                assert refreshToken != null;

                authClient.revokeToken(refreshToken).start(new AuthenticationCallback<Void>() {
                    @Override
                    public void onSuccess(Void payload) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(true);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull AuthenticationException error) {
                        final HashMap<String, Object> obj = JSONHelpers.authErrorToJSON(error);

                        final String message = error.getLocalizedMessage();

                        mainHandler.post(new Runnable() {
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
    static final String loginEmailPasswordless = "loginEmailPasswordless";
    static final String loginPhoneNumberPasswordless = "loginPhoneNumberPasswordless";
    static final String userInfoWithAccessToken = "userInfoWithAccessToken";
    static final String loginFacebook = "loginFacebook";
    static final String tokenExchangeWithParameters = "tokenExchangeWithParams";
    static final String tokenExchangeWithCode = "tokenExchangeWithCode";
    static final String appleTokenExchange = "appleTokenExchange";
    static final String renew = "renew";
    static final String revoke = "revoke";
    static final String delegation = "delegation";
}
