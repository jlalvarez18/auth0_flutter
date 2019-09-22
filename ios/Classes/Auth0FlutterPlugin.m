#import "Auth0FlutterPlugin.h"
#import <auth0_flutter/auth0_flutter-Swift.h>

@implementation Auth0FlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAuth0FlutterPlugin registerWithRegistrar:registrar];
}
@end
