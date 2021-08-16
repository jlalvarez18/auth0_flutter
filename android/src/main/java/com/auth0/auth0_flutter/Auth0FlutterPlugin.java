package com.auth0.auth0_flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** Auth0FlutterPlugin */
public class Auth0FlutterPlugin implements FlutterPlugin, ActivityAware {

  CredentialsController credentialsController;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is now attached to a Flutter experience.

    AuthenticationController.registerWith(binding);
    WebAuthController.registerWith(binding);
    UsersController.registerWith(binding);

    credentialsController = CredentialsController.registerWith(binding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is no longer attached to a Flutter experience.
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    credentialsController.activityBinding = binding;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    credentialsController.activityBinding = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    credentialsController.activityBinding = binding;
  }

  @Override
  public void onDetachedFromActivity() {
    credentialsController.activityBinding = null;
  }
}