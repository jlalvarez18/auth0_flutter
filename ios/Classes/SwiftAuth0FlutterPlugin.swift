import Flutter
import UIKit
import Auth0

public class SwiftAuth0FlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth0_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftAuth0FlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodArgs = call.method.split(separator: ".")
        
        guard let type = MethodType(rawValue: String(methodArgs[0])) else {
            return
        }
        
        switch type {
        case .auth0:
            guard let method = Auth0Method(rawValue: String(methodArgs[1])) else {
                return
            }
            
            handle(method: method, args: call.arguments, result: result)
        case .webAuth:
            guard let method = WebAuthMethod(rawValue: String(methodArgs[1])) else {
                return
            }
            
            handleWebAuth(method, arguments: call.arguments ?? [:], completion: result)
        case .authentication:
            break
        case .credentialsManager:
            break
        }
    }
    
    func handleWebAuth(_ method: WebAuthMethod, arguments: Any, completion: @escaping FlutterResult) {
        let decoder = JSONDecoder();
        
        var args: WebAuthArguments
        
        do {
            let data = try JSONSerialization.data(withJSONObject: arguments, options: [])
            args = try decoder.decode(WebAuthArguments.self, from: data)
        } catch {
            completion(FlutterError(code: "", message: "Unable to serialize arguments", details: nil))
           return
        }
        
        switch method {
        case .start:
            args.webAuth().start { (result) in
                switch result {
                case .success(let credentials):
                    completion(credentialsToJSON(credentials: credentials))
                    
                case .failure(let error):
                    let e = error as! WebAuthError
                    
                    completion(FlutterError(code: "", message: e.localizedDescription, details: e.errorUserInfo))
                }
            }
            
        case .clearSession:
            let dict = arguments as? [String: Bool] ?? [:]
            
            args.webAuth().clearSession(federated: dict["federated"] ?? false) { (success) in
                completion(success)
            }
        }
    }
    
    func handle(method: Auth0Method, args: Any?, result: @escaping FlutterResult) {
        switch method {
        case .resumeAuth:
            result("")
            
        case .getPlatformVersion:
            result("iOS " + UIDevice.current.systemVersion)
        }
    }
}

func credentialsToJSON(credentials: Credentials) -> [String: Any] {
    let json: [String : Any?] = [
        "access_token": credentials.accessToken,
        "token_type": credentials.tokenType,
        "expires_in": credentials.expiresIn,
        "refresh_token": credentials.refreshToken,
        "id_token": credentials.idToken,
        "scope": credentials.scope
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

struct WebAuthArguments: Decodable {
    let clientId: String
    let domain: String
    
    let universalLink: Bool
    let responseType: [String]?
    let nonce: String?
    let parameters: [String: String]
    
    func webAuth() -> WebAuth {
        let auth = Auth0.webAuth(clientId: self.clientId, domain: self.domain)
        
        if universalLink {
            _ = auth.useUniversalLink()
        }
        
        if let value = responseType {
            let types: [ResponseType] = value.compactMap {
                switch $0 {
                case "token":
                    return .token
                case "idToken":
                    return .idToken
                case "code":
                    return .code
                default:
                    return nil
                }
            }
            
            _ = auth.responseType(types)
        }
        
        if let value = nonce {
            _ = auth.nonce(value)
        }
        
        _ = auth.parameters(parameters)
        
        return auth
    }
}

enum MethodType: String {
    case auth0
    case webAuth
    case authentication
    case credentialsManager
}

enum Auth0Method: String {
    case resumeAuth
    case getPlatformVersion
}

enum WebAuthMethod: String {
    case start
    case clearSession
}

enum AuthenticationMethod: String {
    case login
    case loginWithOTP
    case loginDefaultDirectory
    case createUser
    case resetPassword
    case startEmailPasswordless
    case startPhoneNumberPasswordless
    case userInfoWithToken
    case userInfoWithAccessToken
    case loginSocial
    case tokenExchangeWithParameters
    case tokenExchangeWithCode
    case appleTokenExchange
    case renew
    case revoke
    case delegation
}

enum CredentialsManagerMethod: String {
    case enableBioMetrics
    case storeCredentials
    case clearCredentials
    case hasValidCredentials
    case getCredentials
}
