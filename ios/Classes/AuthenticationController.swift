//
//  AuthenticationController.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/24/19.
//

import Foundation
import Auth0

class AuthenticationController {
    enum MethodName: String {
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
    
    static func handle(_ method: MethodName, arguments: Any, completion: @escaping Auth0ControllerCompletion) {
        let decoder = JSONDecoder();
        
        do {
            let data = try JSONSerialization.data(withJSONObject: arguments, options: [])
            let authParams = try decoder.decode(AuthParameters.self, from: data)
            
            let auth = authentication(clientId: authParams.clientId, domain: authParams.domain)
            
            switch method {
            case .login:
                let params = try LoginWithUsernameOrEmailParameters.decode(data: data)
                auth.login(usernameOrEmail: params.usernameOrEmail,
                           password: params.password,
                           realm: params.realm,
                           audience: params.audience,
                           scope: params.scope,
                           parameters: params.parametersDict())
                    .start { (result) in
                        switch result {
                        case .success(let credentials):
                            completion(credentialsToJSON(credentials), nil)
                        case .failure(let error):
                            completion(nil, error)
                        }
                }
                
            case .loginWithOTP:
                let params = try LoginWithOTPParameters.decode(data: data)
                auth.login(withOTP: params.otp, mfaToken: params.mfaToken).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .loginDefaultDirectory:
                let params = try LoginWithDefaultDirectoryParameters.decode(data: data)
                auth.loginDefaultDirectory(withUsername: params.username,
                                           password: params.password,
                                           audience: params.audience,
                                           scope: params.scope,
                                           parameters: params.parametersDict())
                    .start { (result) in
                        switch result {
                        case .success(let credentials):
                            completion(credentialsToJSON(credentials), nil)
                        case .failure(let error):
                            completion(nil, error)
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
                    .start { (result) in
                        switch result {
                        case .success(let user):
                            completion(databaseUserToJSON(user), nil)
                        case .failure(let error):
                            completion(nil, error)
                        }
                }
                
            case .resetPassword:
                let params = try ResetPasswordParameters.decode(data: data)
                auth.resetPassword(email: params.email, connection: params.connection).start { (result) in
                    switch result {
                    case .success(_):
                        completion(nil, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .startEmailPasswordless:
                let params = try StartEmailPasswordlessParameters.decode(data: data)
                auth.startPasswordless(email: params.email, type: params.type, connection: params.connection, parameters: params.parametersDict()).start { (result) in
                    switch result {
                    case .success(_):
                        completion(nil, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .startPhoneNumberPasswordless:
                let params = try StartPhoneNumberPasswordlessParameters.decode(data: data)
                auth.startPasswordless(phoneNumber: params.phoneNumber, type: params.type, connection: params.connection).start { (result) in
                    switch result {
                    case .success(_):
                        completion(nil, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .userInfoWithToken:
                let params = try UserInfoWithTokenParameters.decode(data: data)
                auth.userInfo(token: params.token).start { (result) in
                    switch result {
                    case .success(let profile):
                        completion(profileToJSON(profile), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .userInfoWithAccessToken:
                let params = try UserInfoWithAccessTokenParameters.decode(data: data)
                auth.userInfo(withAccessToken: params.accessToken).start { (result) in
                    switch result {
                    case .failure(let error):
                        completion(nil, error)
                    case .success(let userInfo):
                        completion(userInfoToJSON(userInfo), nil)
                    }
                }
                
            case .loginSocial:
                let params = try LoginSocialParameters.decode(data: data)
                auth.loginSocial(token: params.token, connection: params.connection, scope: params.scope, parameters: params.parametersDict()).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .tokenExchangeWithParameters:
                let params = try TokenExchangeWithParamsParameters.decode(data: data)
                auth.tokenExchange(withParameters: params.parametersDict()).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .tokenExchangeWithCode:
                let params = try TokenExchangeWithCodeParameters.decode(data: data)
                auth.tokenExchange(withCode: params.code, codeVerifier: params.code, redirectURI: params.redirectURI).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .appleTokenExchange:
                let params = try AppleTokenExchangeParameters.decode(data: data)
                auth.tokenExchange(withAppleAuthorizationCode: params.authCode, scope: params.scope, audience: params.audience).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .renew:
                let params = try RenewParameters.decode(data: data)
                auth.renew(withRefreshToken: params.refreshToken, scope: params.scope).start { (result) in
                    switch result {
                    case .success(let credentials):
                        completion(credentialsToJSON(credentials), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .revoke:
                let params = try RevokeParameters.decode(data: data)
                auth.revoke(refreshToken: params.refreshToken).start { (result) in
                    switch result {
                    case .success(_):
                        completion(nil, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
                
            case .delegation:
                let params = try DelegationParameters.decode(data: data)
                auth.delegation(withParameters: params.parametersDict()).start { (result) in
                    switch result {
                    case .success(let dict):
                        completion(dict, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
            }
        } catch {
            completion(nil, error)
        }
    }
}

private struct AuthParameters: Decodable {
    let clientId: String
    let domain: String
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

private struct UserInfoWithTokenParameters: Decodable {
    let token: String
}

private struct UserInfoWithAccessTokenParameters: Decodable {
    let accessToken: String
}

private struct LoginSocialParameters: Decodable {
    let token: String
    let connection: String
    let scope: String
    private let parameters: [String: AnyDecodable]
    
    func parametersDict() -> [String: Any] {
        return parameters.mapValues { $0.value }
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
