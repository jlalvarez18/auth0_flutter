//
//  CredentialsController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class CredentialsManagerController: NSObject, FlutterPlugin {
    enum MethodName: String {
        case enableBioMetrics
        case storeCredentials
        case clearCredentials
        case hasValidCredentials
        case getCredentials
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/credentials_manager", binaryMessenger: registrar.messenger())
        
        let instance = CredentialsManagerController()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: args, options: [])
            let managerArgs = try CredentialsManagerArguments.decode(data: data)
            
            let auth = authentication(clientId: managerArgs.clientId, domain: managerArgs.domain)
            var manager = CredentialsManager(authentication: auth)
            
            guard let method = MethodName(rawValue: call.method) else {
                sendResult(result, data: nil, error: Auth0PluginError.unknownMethod(call.method))
                return
            }
            
            switch method {
            case .enableBioMetrics:
                manager.enableBiometrics(withTitle: managerArgs.title ?? "", cancelTitle: managerArgs.cancelTitle, fallbackTitle: managerArgs.fallbackTitle)
                sendResult(result, data: nil, error: nil)
                
            case .storeCredentials:
                guard let credentialsArg = managerArgs.credentialsDict() else {
                    sendResult(result, data: nil, error: nil)
                    return
                }
                
                let credentials = Credentials(json: credentialsArg)
                let success = manager.store(credentials: credentials)
                
                sendResult(result, data: success, error: nil)
                
            case .clearCredentials:
                let success = manager.clear()
                sendResult(result, data: success, error: nil)
                
            case .hasValidCredentials:
                let success = manager.hasValid()
                sendResult(result, data: success, error: nil)
                
            case .getCredentials:
                manager.credentials { (error, credentials) in
                    if let credentials = credentials {
                        sendResult(result, data: credentials.toJSON(), error: nil)
                    } else if let error = error {
                        sendResult(result, data: nil, error: error)
                    } else {
                        sendResult(result, data: nil, error: Auth0PluginError.unknownError)
                    }
                }
            }
        } catch {
            sendResult(result, data: nil, error: error)
        }
    }
}

private struct CredentialsManagerArguments: Decodable {
    let clientId: String
    let domain: String
    let storeKey: String?
    
    let title: String?
    let cancelTitle: String?
    let fallbackTitle: String?
    
    private let credentials: [String: AnyDecodable]?
    
    func credentialsDict() -> [String: Any]? {
        return credentials?.mapValues { $0.value }
    }
}
