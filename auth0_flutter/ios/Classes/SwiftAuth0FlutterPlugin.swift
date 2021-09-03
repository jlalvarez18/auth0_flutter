import Flutter
import UIKit
import Auth0

enum Auth0PluginError: Swift.Error {
    case unknownMethod(String)
    case missingArgument(String)
    case unknownError
    
    func toFlutterError() -> FlutterError {
        switch self {
        case .unknownMethod(let name):
            return FlutterError(code: "", message: "Unknown method name: \(name)", details: nil)
        case .missingArgument(let arg):
            return FlutterError(code: "", message: "Missing argument: \(arg)", details: nil)
        case .unknownError:
            return FlutterError(code: "", message: "Unknown Error", details: nil)
        }
    }
}

typealias Auth0ControllerCompletion = (Any?, Error?) -> Void

public class SwiftAuth0FlutterPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAuth0FlutterPlugin()
        registrar.addApplicationDelegate(instance)
        
        Auth0Controller.register(with: registrar)
        WebAuthController.register(with: registrar)
        AuthenticationController.register(with: registrar)
        CredentialsManagerController.register(with: registrar)
        UsersController.register(with: registrar)
    }

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Auth0.resumeAuth(url, options: options)
    }
}

func sendResult(_ result: FlutterResult, data: Any?, error: Error?) {
    if let error = error {
        if let e = error as? CustomNSError {
            result(FlutterError(code: "", message: e.localizedDescription, details: e.errorUserInfo))
        } else {
            result(FlutterError(code: "", message: error.localizedDescription, details: nil))
        }
    } else if let data = data {
        result(data)
    } else {
        result(nil)
    }
}
