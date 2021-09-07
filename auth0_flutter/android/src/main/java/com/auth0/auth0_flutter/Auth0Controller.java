package com.auth0.auth0_flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.auth0.android.Auth0;

import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class Auth0Controller implements MethodCallHandler {
    @Nullable
    static Auth0Options options;

    static void registerWith(FlutterPluginBinding binding) {
        final MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "plugins.auth0_flutter.io/core");

        final Auth0Controller instance = new Auth0Controller();

        channel.setMethodCallHandler(instance);
    }

    static Auth0 auth0(ActivityPluginBinding binding) {
        if (options != null) {
            return new Auth0(options.clientId, options.domain);
        } else {
            return new Auth0(binding.getActivity());
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        final String clientId = call.argument("clientId");
        final String domain = call.argument("domain");

        if (clientId == null || domain == null) {
            result.success(null);
            return;
        }

        if (call.method.equals(Auth0MethodName.initialize)) {
            Auth0Controller.options = new Auth0Options(clientId, domain);

            result.success(null);
        } else {
            result.notImplemented();
        }
    }
}

class Auth0MethodName {
    static final String initialize = "initialize";
}

