//
//  WebAuthController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class WebAuthController: NSObject, FlutterPlugin {
    enum MethodName: String {
        case start
        case clearSession
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/web_auth", binaryMessenger: registrar.messenger())
        
        let instance = WebAuthController()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        
        do {
            guard let method = MethodName(rawValue: call.method) else {
                throw Auth0PluginError.unknownMethod(call.method)
            }
            
            let data = try JSONSerialization.data(withJSONObject: args, options: [])
            let authArguments = try WebAuthArguments.decode(data: data)
            
            let webAuth = authArguments.webAuth()
            
            switch method {
            case .start:
                webAuth.start { (authResult) in
                    switch authResult {
                    case .success(let credentials):
                        sendResult(result, data: credentials.toJSON(), error: nil)
                        
                    case .failure(let error):
                        let e = WebAuthErrorCustom(error as! WebAuthError)
                        
                        sendResult(result, data: nil, error: e)
                    }
                }
                
            case .clearSession:
                let dict = call.arguments as? [String: Bool] ?? [:]
                
                webAuth.clearSession(federated: dict["federated"] ?? false) { (success) in
                    sendResult(result, data: success, error: nil)
                }
            }
        } catch {
            sendResult(result, data: nil, error: error)
        }
    }
}

private struct WebAuthArguments: Decodable {
    let clientId: String
    let domain: String
    
    let universalLink: Bool
    let responseType: [String]
    let nonce: String?
    let parameters: [String: String]
    
    func webAuth() -> WebAuth {
        let auth = Auth0.webAuth(clientId: self.clientId, domain: self.domain)
        
        if universalLink {
            _ = auth.useUniversalLink()
        }
        
        let types: [ResponseType] = responseType.compactMap {
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
        
        if let value = nonce {
            _ = auth.nonce(value)
        }
        
        _ = auth.parameters(parameters)
        
        return auth
    }
}
