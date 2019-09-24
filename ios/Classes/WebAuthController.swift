//
//  WebAuthController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class WebAuthController {
    enum MethodName: String {
        case start
        case clearSession
    }
    
    enum Error: Swift.Error {
        case authError(WebAuthError)
    }
    
    static func handle(_ method: MethodName, arguments: Any, completion: @escaping Auth0ControllerCompletion) {
        let decoder = JSONDecoder();
        
        var args: WebAuthArguments
        
        do {
            let data = try JSONSerialization.data(withJSONObject: arguments, options: [])
            args = try decoder.decode(WebAuthArguments.self, from: data)
        } catch {
            completion(nil, error)
            return
        }
        
        switch method {
        case .start:
            args.webAuth().start { (result) in
                switch result {
                case .success(let credentials):
                    completion(credentialsToJSON(credentials), nil)
                    
                case .failure(let error):
                    let e = error as! WebAuthError
                    
                    completion(nil, e)
                }
            }
            
        case .clearSession:
            let dict = arguments as? [String: Bool] ?? [:]
            
            args.webAuth().clearSession(federated: dict["federated"] ?? false) { (success) in
                completion(success, nil)
            }
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
