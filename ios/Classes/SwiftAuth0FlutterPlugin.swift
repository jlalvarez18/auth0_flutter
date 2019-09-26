import Flutter
import UIKit
import Auth0

enum Auth0PluginError: Swift.Error {
    case unknownMethod(String)
    case unknownError
    
    func toFlutterError() -> FlutterError {
        switch self {
        case .unknownMethod(let name):
            return FlutterError(code: "", message: "Unknown method name: \(name)", details: nil)
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
        
        WebAuthController.register(with: registrar)
        AuthenticationController.register(with: registrar)
        CredentialsManagerController.register(with: registrar)
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

class WebAuthErrorCustom: CustomNSError {
    private let type: String
    private let description: String
    
    init(_ error: WebAuthError) {
        self.type = WebAuthErrorCustom.typeToString(type: error)
        self.description = error.localizedDescription
    }
    
    public var errorUserInfo: [String : Any] {
        return [
            "description": description,
            "type": type
        ]
    }
    
    private static func typeToString(type: WebAuthError) -> String {
        switch type {
        case .noBundleIdentifierFound:
            return "noBundleIdentifierFound"
        case .cannotDismissWebAuthController:
            return "cannotDismissWebAuthController"
        case .userCancelled:
            return "userCancelled"
        case .pkceNotAllowed(_):
            return "pkceNotAllowed"
        case .noNonceProvided:
            return "noNonceProvided"
        case .missingResponseParam(_):
            return "missingResponseParam"
        case .invalidIdTokenNonce:
            return "invalidIdTokenNonce"
        case .missingAccessToken:
            return "missingAccessToken"
        case .unknownError:
            return "unknownError"
        }
    }
}

extension ManagementError {
    public var errorUserInfo: [String : Any] {
        return [
            "code": code,
            "description": description,
        ]
    }
}

extension CredentialsManagerError: CustomNSError {
    
    public var localizedDescription: String {
        switch self {
        case .noCredentials:
            return "No credentials found"
        case .noRefreshToken:
            return "No refresh token found"
        case .failedRefresh(let error):
            return "Refresh failed with error: \(error.localizedDescription)"
        case .touchFailed(let error):
            return "Touch failed with error: \(error.localizedDescription)"
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let type: String
        
        switch self {
        case .noCredentials:
            type = "no_credentials"
        case .noRefreshToken:
            type = "no_refresh_token"
        case .failedRefresh(_):
            type = "failed_refresh"
        case .touchFailed(_):
            type = "touch_failed"
        }
        
        return [
            "error_type": type,
            "error_description": localizedDescription
        ]
    }
}
