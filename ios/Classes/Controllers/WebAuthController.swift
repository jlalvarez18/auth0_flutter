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
            
            switch method {
            case .start:
                let authArguments = try WebAuthArguments.decode(data: data)
                
                let webAuth = authArguments.webAuth()
                
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
                guard let clientId = args["clientId"] as? String else {
                    throw Auth0PluginError.missingArgument("clientId")
                }
                
                guard let domain = args["domain"] as? String else {
                    throw Auth0PluginError.missingArgument("domain")
                }
                
                let federated = args["federated"] as? Bool ?? false
                
                let webAuth = Auth0.webAuth(clientId: clientId, domain: domain)
                
                webAuth.clearSession(federated: federated) { (success) in
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
    
    let loggingEnabled: Bool
    
    func webAuth() -> WebAuth {
        let auth = Auth0.webAuth(clientId: self.clientId, domain: self.domain)
        
        if loggingEnabled {
            _ = auth.logging(enabled: loggingEnabled)
        }
        
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
