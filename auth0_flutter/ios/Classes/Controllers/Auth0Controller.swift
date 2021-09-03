//
//  Auth0Controller.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/3/21.
//

import Foundation

class Auth0Controller: NSObject, FlutterPlugin {
    enum MethodName: String {
        case initialize
    }
    
    static var sharedInstance: Auth0Controller {
        return Auth0Controller()
    }
    
    static var options: Auth0Options?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/core", binaryMessenger: registrar.messenger())
        
        let instance = Auth0Controller.sharedInstance
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments ?? [:]
        
        do {
            guard let method = MethodName(rawValue: call.method) else {
                sendResult(result, data: nil, error: Auth0PluginError.unknownMethod(call.method))
                return
            }
            
            let data = try JSONSerialization.data(withJSONObject: arguments, options: [])
            let params = try Auth0Parameters.decode(data: data)
            
            switch method {
                case .initialize:
                    if let clientId = params.clientId, let domain = params.domain {
                        Auth0Controller.options = Auth0Options(clientId: clientId, domain: domain)
                    }
                    
                    sendResult(result, data: nil, error: nil)
            }
        } catch {
            sendResult(result, data: nil, error: error)
        }
    }
}

struct Auth0Options {
    let clientId: String
    let domain: String
}

private struct Auth0Parameters: Decodable {
    let clientId: String?
    let domain: String?
}
