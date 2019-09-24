//
//  CredentialsController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class CredentialsManagerController {
    enum MethodName: String {
        case enableBioMetrics
        case storeCredentials
        case clearCredentials
        case hasValidCredentials
        case getCredentials
    }
    
    enum CredentialsError: Swift.Error {
        case missingParameter(String)
        case unknownError
        
        var localizedDescription: String {
            switch self {
            case .missingParameter(let value):
                return "Missing parameter: \(value)";
            case .unknownError:
                return "Unknown error occurred"
            }
        }
    }

    static func handle(_ method: MethodName, arguments: Any, completion: @escaping Auth0ControllerCompletion) {
        let decoder = JSONDecoder();
        
        let args: CredentialsArguments
        
        do {
            let data = try JSONSerialization.data(withJSONObject: arguments, options: [])
            args = try decoder.decode(CredentialsArguments.self, from: data)
        } catch {
            completion(nil, CredentialsError.missingParameter("credentials"))
            return
        }
        
        let auth = authentication(clientId: args.clientId, domain: args.domain)
        var manager = CredentialsManager(authentication: auth)
        
        switch method {
        case .enableBioMetrics:
            manager.enableBiometrics(withTitle: args.title ?? "", cancelTitle: args.cancelTitle, fallbackTitle: args.fallbackTitle)
            completion(nil, nil)
            
        case .storeCredentials:
            guard let credentialsArg = args.credentials else {
                completion(nil, nil)
                return
            }
            
            let credentials = Credentials(json: credentialsArg)
            let success = manager.store(credentials: credentials)
            
            completion(success, nil)
            
        case .clearCredentials:
            let success = manager.clear()
            completion(success, nil)
            
        case .hasValidCredentials:
            let success = manager.hasValid()
            completion(success, nil)
            
        case .getCredentials:
            manager.credentials { (error, credentials) in
                if let error = error {
                    completion(nil, error)
                } else if let credentials = credentials {
                    completion(credentialsToJSON(credentials), nil)
                } else {
                    completion(nil, CredentialsError.unknownError)
                }
            }
        }
    }
}

private struct CredentialsArguments: Decodable {
    let clientId: String
    let domain: String
    let storeKey: String?
    
    let title: String?
    let cancelTitle: String?
    let fallbackTitle: String?
    
    let credentials: [String: String]?
}
