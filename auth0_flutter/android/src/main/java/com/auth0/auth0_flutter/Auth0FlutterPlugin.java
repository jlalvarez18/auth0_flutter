package com.auth0.auth0_flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/** Auth0FlutterPlugin */
public class Auth0FlutterPlugin implements FlutterPlugin, ActivityAware {

  CredentialsController credentialsController;
  WebAuthController webAuthController;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    AuthenticationController.registerWith(binding);
    UsersController.registerWith(binding);

    webAuthController = WebAuthController.registerWith(binding);
    credentialsController = CredentialsController.registerWith(binding);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // TODO: your plugin is no longer attached to a Flutter experience.
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    credentialsController.setActivityBinding(binding);
    webAuthController.setActivityBinding(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    credentialsController.setActivityBinding(null);
    webAuthController.setActivityBinding(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    credentialsController.setActivityBinding(binding);
    webAuthController.setActivityBinding(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    credentialsController.setActivityBinding(null);
    webAuthController.setActivityBinding(null);
  }
}