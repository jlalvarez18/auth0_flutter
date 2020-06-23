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
        case revokeCredentials
    }
    
    private var credsManager: CredentialsManager?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/credentials_manager", binaryMessenger: registrar.messenger())
        
        let instance = CredentialsManagerController()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func getCredentialsManager(data: Data) throws -> CredentialsManager {
        if let manager = credsManager {
            return manager
        }
        
        let managerArgs = try CredentialsManagerArguments.decode(data: data)
        let auth = authentication(clientId: managerArgs.clientId, domain: managerArgs.domain)
        let manager = CredentialsManager(authentication: auth, storeKey: managerArgs.storeKey ?? "credentials")
        
        self.credsManager = manager
        
        return manager
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = MethodName(rawValue: call.method) else {
            sendResult(result, data: nil, error: Auth0PluginError.unknownMethod(call.method))
            return
        }
        
        let args = call.arguments as? [String: Any] ?? [:]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: args, options: [])
            
            var manager = try getCredentialsManager(data: data)
            
            switch method {
            case .enableBioMetrics:
                let args = try CredentialsBiometricsArgs.decode(data: data)
                
                manager.enableBiometrics(withTitle: args.title ?? "", cancelTitle: args.cancelTitle, fallbackTitle: args.fallbackTitle)
                
                sendResult(result, data: true, error: nil)
                
            case .storeCredentials:
                let credArgs = try CredentialsArguments.decode(data: data)
                
                guard let credentialsArg = credArgs.credentialsDict() else {
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
                let args = try GetCredentialsArgs.decode(data: data)
                
                manager.credentials(withScope: args.scope) { (error, credentials) in
                    if let credentials = credentials {
                        sendResult(result, data: credentials.toJSON(), error: nil)
                    } else if let error = error {
                        sendResult(result, data: nil, error: error)
                    } else {
                        sendResult(result, data: nil, error: Auth0PluginError.unknownError)
                    }
                }
                
            case .revokeCredentials:
                manager.revoke { (error) in
                    if let error = error {
                        sendResult(result, data: false, error: error)
                    } else {
                        sendResult(result, data: true, error: nil)
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
}

private struct CredentialsBiometricsArgs: Decodable {
    let title: String?
    let cancelTitle: String?
    let fallbackTitle: String?
}

private struct CredentialsArguments: Decodable {
    private let credentials: [String: AnyDecodable]?
    
    func credentialsDict() -> [String: Any]? {
        return credentials?.mapValues { $0.value }
    }
}

private struct GetCredentialsArgs: Decodable {
    let scope: String?
}
