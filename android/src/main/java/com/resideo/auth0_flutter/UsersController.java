package com.resideo.auth0_flutter;

import androidx.annotation.NonNull;

import com.auth0.android.Auth0;
import com.auth0.android.callback.BaseCallback;
import com.auth0.android.management.ManagementException;
import com.auth0.android.management.UsersAPIClient;
import com.auth0.android.result.UserIdentity;
import com.auth0.android.result.UserProfile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class UsersController implements MethodCallHandler {
    private final Registrar registrar;

    static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.auth0_flutter.io/users");

        channel.setMethodCallHandler(new UsersController(registrar));
    }

    private UsersController(Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull final Result result) {
        final String clientId = call.argument("clientId");
        final String domain = call.argument("domain");
        final String token = call.argument("token");

        assert clientId != null;
        assert domain != null;

        final Auth0 auth0 = new Auth0(clientId, domain);
        UsersAPIClient apiClient = new UsersAPIClient(auth0, token);

        switch (call.method) {
            case UsersControllerMethodName.get: {
                final String identifier = call.argument("identifier");
                assert identifier != null;

                apiClient.getProfile(identifier).start(new BaseCallback<UserProfile, ManagementException>() {
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
                    public void onFailure(ManagementException error) {
                        final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                        result.error("", error.getLocalizedMessage(), info);
                    }
                });
                break;
            }
            case UsersControllerMethodName.linkWithOtherUserToken: {
                final String primaryUserId = call.argument("identifier");
                final String otherUserToken = call.argument("token");

                assert primaryUserId != null;
                assert otherUserToken != null;

                apiClient.link(primaryUserId, otherUserToken).start(new BaseCallback<List<UserIdentity>, ManagementException>() {
                    @Override
                    public void onSuccess(List<UserIdentity> payload) {
                        final ArrayList<HashMap<String, Object>> obj = JSONHelpers.identitiesToJSON(payload);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(ManagementException error) {
                        final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                        result.error("", error.getLocalizedMessage(), info);
                    }
                });
                break;
            }
            case UsersControllerMethodName.unlink: {
                final String identityId = call.argument("identityId");
                final String provider = call.argument("provider");
                final String fromUserId = call.argument("fromUserId");

                assert identityId != null;
                assert provider != null;
                assert fromUserId != null;

                apiClient.unlink(identityId, fromUserId, provider).start(new BaseCallback<List<UserIdentity>, ManagementException>() {
                    @Override
                    public void onSuccess(List<UserIdentity> payload) {
                        final ArrayList<HashMap<String, Object>> obj = JSONHelpers.identitiesToJSON(payload);

                        registrar.activity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(ManagementException error) {
                        final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                        result.error("", error.getLocalizedMessage(), info);
                    }
                });
                break;
            }
//            case UsersControllerMethodName.linkWithUserId: {
//                break;
//            }
//            case UsersControllerMethodName.patchAttributes: {
//                break;
//            }
//            case UsersControllerMethodName.patchUserMetadata: {
//                break;
//            }
            default:
                result.notImplemented();
        }
    }
}

class UsersControllerMethodName {
    static final String get = "get";
    static final String patchAttributes = "patchAttributes";
    static final String patchUserMetadata = "patchUserMetadata";
    static final String linkWithOtherUserToken = "linkWithOtherUserToken";
    static final String linkWithUserId = "linkWithUserId";
    static final String unlink = "unlink";

    private UsersControllerMethodName() {};
}