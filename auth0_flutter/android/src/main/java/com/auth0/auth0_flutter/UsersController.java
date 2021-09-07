package com.auth0.auth0_flutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.auth0.android.Auth0;
import com.auth0.android.callback.Callback;
import com.auth0.android.callback.ManagementCallback;
import com.auth0.android.management.ManagementException;
import com.auth0.android.management.UsersAPIClient;
import com.auth0.android.request.Request;
import com.auth0.android.result.UserIdentity;
import com.auth0.android.result.UserProfile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class UsersController extends ActivityBindingController implements MethodCallHandler {
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    static UsersController registerWith(FlutterPluginBinding binding) {
        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.auth0_flutter.io/users");

        final UsersController instance = new UsersController();

        channel.setMethodCallHandler(instance);

        return instance;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        final ActivityPluginBinding binding = getActivityBinding();

        if (binding == null) {
            result.error("", "Missing activity.", null);
            return;
        }

        final String token = call.argument("token");

        assert token != null;

        final Auth0 auth0 = Auth0Controller.auth0(binding);

        UsersAPIClient apiClient = new UsersAPIClient(auth0, token);

        switch (call.method) {
            case UsersControllerMethodName.get: {
                final String identifier = call.argument("identifier");
                assert identifier != null;

                Request<UserProfile, ManagementException> request = apiClient.getProfile(identifier);

                request.start(new Callback<UserProfile, ManagementException>() {
                    @Override
                    public void onSuccess(UserProfile payload) {
                        final HashMap<String, Object> obj = JSONHelpers.profileTOJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull final ManagementException error) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                                result.error("", error.getLocalizedMessage(), info);
                            }
                        });
                    }
                });
                break;
            }
            case UsersControllerMethodName.linkWithOtherUserToken: {
                final String primaryUserId = call.argument("identifier");
                final String otherUserToken = call.argument("token");

                assert primaryUserId != null;
                assert otherUserToken != null;

                apiClient.link(primaryUserId, otherUserToken).start(new Callback<List<UserIdentity>, ManagementException>() {
                    @Override
                    public void onSuccess(List<UserIdentity> payload) {
                        final ArrayList<HashMap<String, Object>> obj = JSONHelpers.identitiesToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull final ManagementException error) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                                result.error("", error.getLocalizedMessage(), info);
                            }
                        });

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

                apiClient.unlink(identityId, fromUserId, provider).start(new Callback<List<UserIdentity>, ManagementException>() {
                    @Override
                    public void onSuccess(List<UserIdentity> payload) {
                        final ArrayList<HashMap<String, Object>> obj = JSONHelpers.identitiesToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull final ManagementException error) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                                result.error("", error.getLocalizedMessage(), info);
                            }
                        });
                    }
                });
                break;
            }
            case UsersControllerMethodName.linkWithUserId: {
                final String primaryUserId = call.argument("identifier");
                final String userId = call.argument("userId");

                assert primaryUserId != null;
                assert userId != null;

                apiClient.link(primaryUserId, userId).start(new ManagementCallback<List<UserIdentity>>() {
                    @Override
                    public void onSuccess(final List<UserIdentity> payload) {
                        final ArrayList<HashMap<String, Object>> obj = JSONHelpers.identitiesToJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull final ManagementException error) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                                result.error("", error.getLocalizedMessage(), info);
                            }
                        });
                    }
                });
                break;
            }
//            case UsersControllerMethodName.patchAttributes: {
//                final String primaryUserId = call.argument("identifier");
//
//                break;
//            }
            case UsersControllerMethodName.patchUserMetadata: {
                final String primaryUserId = call.argument("identifier");
                final HashMap<String, Object> metadata = call.argument("userMetadata");

                assert primaryUserId != null;
                assert metadata != null;

                Request<UserProfile, ManagementException> request = apiClient.updateMetadata(primaryUserId, metadata);

                request.start(new ManagementCallback<UserProfile>() {
                    @Override
                    public void onSuccess(UserProfile payload) {
                        final HashMap<String, Object> obj = JSONHelpers.profileTOJSON(payload);

                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(obj);
                            }
                        });
                    }

                    @Override
                    public void onFailure(@NonNull final ManagementException error) {
                        mainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                final HashMap<String, String> info = JSONHelpers.managementExceptionToJSON(error);
                                result.error("", error.getLocalizedMessage(), info);
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

class UsersControllerMethodName {
    static final String get = "get";
    static final String patchAttributes = "patchAttributes";
    static final String patchUserMetadata = "patchUserMetadata";
    static final String linkWithOtherUserToken = "linkWithOtherUserToken";
    static final String linkWithUserId = "linkWithUserId";
    static final String unlink = "unlink";

    private UsersControllerMethodName() {};
}