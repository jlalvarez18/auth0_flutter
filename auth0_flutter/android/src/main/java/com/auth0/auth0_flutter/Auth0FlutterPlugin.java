package com.auth0.auth0_flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/** Auth0FlutterPlugin */
public class Auth0FlutterPlugin implements FlutterPlugin, ActivityAware {
  final ArrayList<ActivityBindingController> controllers = new ArrayList<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    Auth0Controller.registerWith(binding);

    controllers.add(AuthenticationController.registerWith(binding));
    controllers.add(CredentialsController.registerWith(binding));
    controllers.add(UsersController.registerWith(binding));
    controllers.add(WebAuthController.registerWith(binding));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is no longer attached to a Flutter experience.
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    for (ActivityBindingController controller : controllers) {
      controller.setActivityBinding(binding);
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    for (ActivityBindingController controller : controllers) {
      controller.setActivityBinding(null);
    }
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    for (ActivityBindingController controller : controllers) {
      controller.setActivityBinding(binding);
    }
  }

  @Override
  public void onDetachedFromActivity() {
    for (ActivityBindingController controller : controllers) {
      controller.setActivityBinding(null);
    }
  }
}

