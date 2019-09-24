import Flutter
import UIKit
import Auth0

private func unknownMethodError(_ methodName: String) -> FlutterError {
    return FlutterError(code: "", message: "Unknown method name: \(methodName)", details: nil)
}

typealias Auth0ControllerCompletion = (Any?, Error?) -> Void

public class SwiftAuth0FlutterPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "auth0_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftAuth0FlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodArgs = call.method.split(separator: ".")

        guard methodArgs.count == 2 else {
            result(unknownMethodError(call.method))
            return
        }

        let domainValue = String(methodArgs[0])
        let methodNameValue = String(methodArgs[1])

        guard let type = Domain(rawValue: domainValue) else {
            result(unknownMethodError(domainValue))
            return
        }

        let arguments = call.arguments ?? [:]
        
        let completion: Auth0ControllerCompletion = { (data, error) in
            sendResult(result, data: data, error: error)
        }

        switch type {
        case .auth0:
            guard let method = Auth0Method(rawValue: methodNameValue) else {
                result(unknownMethodError(methodNameValue))
                return
            }

            handleRoot(method: method, args: arguments, completion: completion)

        case .webAuth:
            guard let method = WebAuthController.MethodName(rawValue: methodNameValue) else {
                result(unknownMethodError(methodNameValue))
                return
            }

            WebAuthController.handle(method, arguments: arguments, completion: completion)

        case .authentication:
            guard let method = AuthenticationController.MethodName(rawValue: methodNameValue) else {
                result(unknownMethodError(methodNameValue))
                return
            }

            AuthenticationController.handle(method, arguments: arguments, completion: completion)

        case .credentialsManager:
            guard let method = CredentialsManagerController.MethodName(rawValue: methodNameValue) else {
                result(unknownMethodError(methodNameValue))
                return
            }

            CredentialsManagerController.handle(method, arguments: arguments, completion: completion)
        }
    }
    
    func handleRoot(method: Auth0Method, args: Any?, completion: @escaping Auth0ControllerCompletion) {
        switch method {
        case .resumeAuth:
            completion("", nil)
            
        case .getPlatformVersion:
            completion("iOS \(UIDevice.current.systemVersion)", nil)
        }
    }
}

func credentialsToJSON(_ credentials: Credentials) -> [String: Any] {
    let json: [String : Any?] = [
        "access_token": credentials.accessToken,
        "token_type": credentials.tokenType,
        "expires_in": credentials.expiresIn,
        "refresh_token": credentials.refreshToken,
        "id_token": credentials.idToken,
        "scope": credentials.scope
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

func databaseUserToJSON(_ user: DatabaseUser) -> [String: Any] {
    let json: [String: Any?] = [
        "email": user.email,
        "username": user.username,
        "verified": user.verified
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

func identityToJSON(_ identity: Identity) -> [String: Any] {
    let json: [String: Any?] = [
        "identifier": identity.identifier,
        "provider": identity.provider,
        "connection": identity.connection,
        "social": identity.social,
        "profileData": identity.profileData,
        "accessToken": identity.accessToken,
        "expiresIn": identity.expiresIn?.timeIntervalSince1970,
        "accessTokenSecret": identity.accessTokenSecret
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

func profileToJSON(_ profile: Profile) -> [String: Any] {
    let json: [String: Any?] = [
        "id": profile.id,
        "name": profile.name,
        "nickname": profile.nickname,
        "pictureURL": profile.pictureURL.absoluteString,
        "createdAt": profile.createdAt.timeIntervalSince1970,
        "email": profile.email,
        "emailVerified": profile.emailVerified,
        "givenName": profile.givenName,
        "familyName": profile.familyName,
        "additionalAttributes": profile.additionalAttributes,
        "identities": profile.identities.map { identityToJSON($0) },
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

func userInfoToJSON(_ userInfo: UserInfo) -> [String: Any] {
    let json: [String: Any?] = [
        "sub": userInfo.sub,
        "name": userInfo.name,
        "givenName": userInfo.givenName,
        "familyName": userInfo.familyName,
        "middleName": userInfo.middleName,
        "nickname": userInfo.nickname,
        "preferredUsername": userInfo.preferredUsername,
        "profile": userInfo.profile?.absoluteString,
        "picture": userInfo.picture?.absoluteString,
        "website": userInfo.website?.absoluteString,
        "email": userInfo.email,
        "emailVerified": userInfo.emailVerified,
        "gender": userInfo.gender,
        "birthdate": userInfo.birthdate,
        "zoneinfo": userInfo.zoneinfo?.identifier,
        "locale": userInfo.locale?.identifier,
        "phoneNumber": userInfo.phoneNumber,
        "phoneNumberVerified": userInfo.phoneNumberVerified,
        "address": userInfo.address,
        "updatedAt": userInfo.updatedAt?.timeIntervalSince1970,
        "customClaims": userInfo.customClaims
    ]
    
    let result = json.compactMapValues { $0 }
    
    return result
}

private func sendResult(_ result: FlutterResult, data: Any?, error: Error?) {
    if let error = error {
        if let nserror = error as? CustomNSError {
            result(FlutterError(code: "", message: error.localizedDescription, details: nserror.errorUserInfo))
        } else {
            result(FlutterError(code: "", message: error.localizedDescription, details: nil))
        }
    } else if let data = data {
        result(data)
    } else {
        result(nil)
    }
}

enum Domain: String {
    case auth0
    case webAuth
    case authentication
    case credentialsManager
}

enum Auth0Method: String {
    case resumeAuth
    case getPlatformVersion
}

extension Decodable {
    static func decode(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
