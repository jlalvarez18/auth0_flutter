//
//  UsersController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/26/19.
//

import Foundation
import Auth0

class UsersController: NSObject, FlutterPlugin {
    enum MethodName: String {
        case get
        case patchAttributes
        case patchUserMetadata
        case linkWithOtherUserToken
        case linkWithUserId
        case unlink
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/users", binaryMessenger: registrar.messenger())
        
        let instance = UsersController()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        
        do {
            guard let method = MethodName(rawValue: call.method) else {
                throw Auth0PluginError.unknownMethod(call.method)
            }
            
            let data = try JSONSerialization.data(withJSONObject: args, options: [])
            let usersArgs = try UsersArguments.decode(data: data)
            
            let usersManagement: Users
            
            if let options = Auth0Controller.options {
                usersManagement = users(token: usersArgs.token, domain: options.domain)
            } else {
                usersManagement = users(token: usersArgs.token)
            }
                
            switch method {
            case .get:
                let params = try GetArguments.decode(data: data)
                usersManagement.get(params.identifier, fields: params.fields, include: params.include).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
                
            case .patchAttributes:
                let params = try PatchArguments.decode(data: data)
                usersManagement.patch(params.identifier, attributes: params.userPatchAttributes()).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
                
            case .patchUserMetadata:
                let params = try PatchWithUserMetadataArguments.decode(data: data)
                usersManagement.patch(params.identifier, userMetadata: params.userMetadataDict()).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
                
            case .linkWithOtherUserToken:
                let params = try LinkWithOtherUserTokenArguments.decode(data: data)
                usersManagement.link(params.identifier, withOtherUserToken: params.token).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
                
            case .linkWithUserId:
                let params = try LinkWithUserIdArguments.decode(data: data)
                usersManagement.link(params.identifier, withUser: params.userId, provider: params.provider, connectionId: params.connectionId).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
                
            case .unlink:
                let params = try UnlinkArguments.decode(data: data)
                usersManagement.unlink(identityId: params.identityId, provider: params.provider, fromUserId: params.fromUserId).start { (usersResult) in
                    switch usersResult {
                    case .success(let object):
                        sendResult(result, data: object, error: nil)
                    case .failure(let error):
                        sendResult(result, data: nil, error: CustomManagementError(error as! ManagementError))
                    }
                }
            }
        } catch {
            sendResult(result, data: nil, error: error)
        }
    }
}

private struct UsersArguments: Decodable {
    let token: String
}

private struct GetArguments: Decodable {
    let identifier: String
    let fields: [String]
    let include: Bool
}

private struct PatchArguments: Decodable {
    let identifier: String
    private let attributes: [String: AnyDecodable]
    
    func userPatchAttributes() -> UserPatchAttributes {
        let attr = attributes.mapValues { $0.value }
        
        return UserPatchAttributes(dictionary: attr)
    }
}

private struct PatchWithUserMetadataArguments: Decodable {
    let identifier: String
    private let userMetadata: [String: AnyDecodable]
    
    func userMetadataDict() -> [String: Any] {
        return userMetadata.mapValues { $0.value }
    }
}

private struct LinkWithOtherUserTokenArguments: Decodable {
    let identifier: String
    let token: String
}

private struct LinkWithUserIdArguments: Decodable {
    let identifier: String
    let userId: String
    let provider: String
    let connectionId: String?
}

private struct UnlinkArguments: Decodable {
    let identityId: String
    let provider: String
    let fromUserId: String
}
