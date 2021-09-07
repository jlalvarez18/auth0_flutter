package com.auth0.auth0_flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ActivityBindingController {
    private @Nullable
    ActivityPluginBinding _activityBinding;

    public void setActivityBinding(@Nullable ActivityPluginBinding binding) {
        this._activityBinding = binding;
    }

    @Nullable
    public ActivityPluginBinding getActivityBinding() {
        return _activityBinding;
    }
}
