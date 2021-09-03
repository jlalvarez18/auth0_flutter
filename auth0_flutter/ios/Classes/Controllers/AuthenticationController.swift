//
//  AuthenticationController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class AuthenticationController: NSObject, FlutterPlugin {
    enum MethodName: String {
        case login
        case loginWithOTP
        case loginDefaultDirectory
        case createUser
        case resetPassword
        case startEmailPasswordless
        case startPhoneNumberPasswordless
        case loginEmailPasswordless
        case loginPhoneNumberPasswordless
        case userInfoWithAccessToken
        case loginFacebook
        case tokenExchangeWithParameters
        case tokenExchangeWithCode
        case appleTokenExchange
        case renew
        case revoke
        case delegation
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.auth0_flutter.io/authentication", binaryMessenger: registrar.messenger())
        
        let instance = AuthenticationController()
        
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
            let authParams = try AuthParameters.decode(data: data)
            
            let auth: Authentication
            
            if let options = Auth0Controller.options {
                auth = authentication(clientId: options.clientId, domain: options.domain)
            } else {
                auth = authentication()
            }
            
            if authParams.loggingEnabled {
                _ = auth.logging(enabled: authParams.loggingEnabled)
            }
            
            switch method {
                case .login:
                    let params = try LoginWithUsernameOrEmailParameters.decode(data: data)
                    auth.login(usernameOrEmail: params.usernameOrEmail,
                               password: params.password,
                               realm: params.realm,
                               audience: params.audience,
                               scope: params.scope,
                               parameters: params.parametersDict())
                        .start { (authResult) in
                            switch authResult {
                                case .success(let credentials):
                                    sendResult(result, data: credentials.toJSON(), error: nil)
                                case .failure(let error):
                                    sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                            }
                        }
                    
                case .loginWithOTP:
                    let params = try LoginWithOTPParameters.decode(data: data)
                    auth.login(withOTP: params.otp, mfaToken: params.mfaToken).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .loginDefaultDirectory:
                    let params = try LoginWithDefaultDirectoryParameters.decode(data: data)
                    auth.loginDefaultDirectory(withUsername: params.username,
                                               password: params.password,
                                               audience: params.audience,
                                               scope: params.scope,
                                               parameters: params.parametersDict())
                        .start { (authResult) in
                            switch authResult {
                                case .success(let credentials):
                                    sendResult(result, data: credentials.toJSON(), error: nil)
                                case .failure(let error):
                                    sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                            }
                        }
                    
                case .createUser:
                    let params = try CreateUserParameters.decode(data: data)
                    auth.createUser(email: params.email,
                                    username: params.username,
                                    password: params.password,
                                    connection: params.connection,
                                    userMetadata: params.userMetadataDict(),
                                    rootAttributes: params.rootAttributesDict())
                        .start { (authResult) in
                            switch authResult {
                                case .success(let user):
                                    sendResult(result, data: databaseUserToJSON(user), error: nil)
                                case .failure(let error):
                                    sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                            }
                        }
                    
                case .resetPassword:
                    let params = try ResetPasswordParameters.decode(data: data)
                    auth.resetPassword(email: params.email, connection: params.connection).start { (authResult) in
                        switch authResult {
                            case .success(_):
                                sendResult(result, data: nil, error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .startEmailPasswordless:
                    let params = try StartEmailPasswordlessParameters.decode(data: data)
                    auth.startPasswordless(email: params.email, type: params.type, connection: params.connection, parameters: params.parametersDict()).start { (authResult) in
                        switch authResult {
                            case .success(_):
                                sendResult(result, data: nil, error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .startPhoneNumberPasswordless:
                    let params = try StartPhoneNumberPasswordlessParameters.decode(data: data)
                    auth.startPasswordless(phoneNumber: params.phoneNumber, type: params.type, connection: params.connection).start { (authResult) in
                        switch authResult {
                            case .success(_):
                                sendResult(result, data: nil, error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .loginEmailPasswordless:
                    let params = try LoginEmailPasswordlessParameters.decode(data: data)
                    auth.login(email: params.email, code: params.code, audience: params.audience, scope: params.scope, parameters: params.parametersDict()).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .loginPhoneNumberPasswordless:
                    let params = try LoginPhoneNumberPasswordlessParameters.decode(data: data)
                    auth.login(phoneNumber: params.phoneNumber, code: params.code, audience: params.audience, scope: params.scope, parameters: params.parametersDict()).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .userInfoWithAccessToken:
                    let params = try UserInfoWithAccessTokenParameters.decode(data: data)
                    auth.userInfo(withAccessToken: params.accessToken).start { (authResult) in
                        switch authResult {
                            case .success(let userInfo):
                                sendResult(result, data: userInfo.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .loginFacebook:
                    let params = try LoginFacebookParameters.decode(data: data)
                    auth.login(facebookSessionAccessToken: params.sessionAccessToken, profile: params.profileDict(), scope: params.scope, audience: params.audience).start { authResult in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .tokenExchangeWithParameters:
                    let params = try TokenExchangeWithParamsParameters.decode(data: data)
                    auth.tokenExchange(withParameters: params.parametersDict()).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .tokenExchangeWithCode:
                    let params = try TokenExchangeWithCodeParameters.decode(data: data)
                    auth.tokenExchange(withCode: params.code, codeVerifier: params.code, redirectURI: params.redirectURI).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .appleTokenExchange:
                    let params = try AppleTokenExchangeParameters.decode(data: data)
                    auth.tokenExchange(withAppleAuthorizationCode: params.authCode, scope: params.scope, audience: params.audience).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .renew:
                    let params = try RenewParameters.decode(data: data)
                    auth.renew(withRefreshToken: params.refreshToken, scope: params.scope).start { (authResult) in
                        switch authResult {
                            case .success(let credentials):
                                sendResult(result, data: credentials.toJSON(), error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .revoke:
                    let params = try RevokeParameters.decode(data: data)
                    auth.revoke(refreshToken: params.refreshToken).start { (authResult) in
                        switch authResult {
                            case .success(_):
                                sendResult(result, data: nil, error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
                    
                case .delegation:
                    let params = try DelegationParameters.decode(data: data)
                    auth.delegation(withParameters: params.parametersDict()).start { (authResult) in
                        switch authResult {
                            case .success(let dict):
                                sendResult(result, data: dict, error: nil)
                            case .failure(let error):
                                sendResult(result, data: nil, error: CustomAuthenticationError(error as! AuthenticationError))
                        }
                    }
            }
        } catch {
            sendResult(result, data: nil, error: error)
        }
    }
}

private struct AuthParameters: Decodable {
    let loggingEnabled: Bool
}

private struct LoginWithUsernameOrEmailParameters: Decodable {
    let usernameOrEmail: String
    let password: String
    let realm: String
    let audience: String?
    let scope: String?
    private let parameters: [String: AnyDecodable]?
    
    func parametersDict() -> [String: Any]? {
        return parameters?.mapValues { $0.value }
    }
}

private struct LoginWithOTPParameters: Decodable {
    let otp: String
    let mfaToken: String
}

private struct LoginWithDefaultDirectoryParameters: Decodable {
    let username: String
    let password: String
    let audience: String?
    let scope: String?
    private let parameters: [String: AnyDecodable]?
    
    func parametersDict() -> [String: Any]? {
        return parameters?.mapValues { $0.value }
    }
}

private struct CreateUserParameters: Decodable {
    let email: String
    let username: String?
    let password: String
    let connection: String
    private let userMetadata: [String: AnyDecodable]?
    private let rootAttributes: [String: AnyDecodable]?
    
    func userMetadataDict() -> [String: Any]? {
        return userMetadata?.mapValues { $0.value }
    }
    
    func rootAttributesDict() -> [String: Any]? {
        return rootAttributes?.mapValues { $0.value }
    }
}

private struct ResetPasswordParameters: Decodable {
    let email: String
    let connection: String
}

extension PasswordlessType: Decodable {}

private struct StartEmailPasswordlessParameters: Decodable {
    let email: String
    let type: PasswordlessType
    let connection: String
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
    }
}

private struct StartPhoneNumberPasswordlessParameters: Decodable {
    let phoneNumber: String
    let type: PasswordlessType
    let connection: String
}

private struct LoginPhoneNumberPasswordlessParameters: Decodable {
    let phoneNumber: String
    let code: String
    let audience: String?
    let scope: String?
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
    }
}

private struct LoginEmailPasswordlessParameters: Decodable {
    let email: String
    let code: String
    let audience: String?
    let scope: String?
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
    }
}

private struct UserInfoWithAccessTokenParameters: Decodable {
    let accessToken: String
}

private struct LoginFacebookParameters: Decodable {
    let sessionAccessToken: String
    private let profile: [String: AnyDecodable]
    let scope: String
    let audience: String?
    
    func profileDict() -> [String: Any] {
        return profile.mapValues { $0.value }
    }
}

private struct TokenExchangeWithParamsParameters: Decodable {
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
    }
}

private struct TokenExchangeWithCodeParameters: Decodable {
    let code: String
    let codeVerifier: String
    let redirectURI: String
}

private struct AppleTokenExchangeParameters: Decodable {
    let authCode: String
    let scope: String?
    let audience: String?
}

private struct RenewParameters: Decodable {
    let refreshToken: String
    let scope: String?
}

private struct RevokeParameters: Decodable {
    let refreshToken: String
}

private struct DelegationParameters: Decodable {
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
    }
}
