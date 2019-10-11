//
//  Errors.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/30/19.
//

import Foundation
import Auth0

class WebAuthErrorCustom: CustomNSError {
    private let type: String
    private let description: String
    
    init(_ error: WebAuthError) {
        self.type = WebAuthErrorCustom.typeToString(type: error)
        self.description = error.localizedDescription
    }
    
    public var errorUserInfo: [String : Any] {
        return [
            "description": description,
            "type": type
        ]
    }
    
    private static func typeToString(type: WebAuthError) -> String {
        switch type {
        case .noBundleIdentifierFound:
            return "noBundleIdentifierFound"
        case .cannotDismissWebAuthController:
            return "cannotDismissWebAuthController"
        case .userCancelled:
            return "userCancelled"
        case .pkceNotAllowed(_):
            return "pkceNotAllowed"
        case .noNonceProvided:
            return "noNonceProvided"
        case .missingResponseParam(_):
            return "missingResponseParam"
        case .invalidIdTokenNonce:
            return "invalidIdTokenNonce"
        case .missingAccessToken:
            return "missingAccessToken"
        case .unknownError:
            return "unknownError"
        }
    }
}

extension ManagementError {
    public var errorUserInfo: [String : Any] {
        return [
            "code": code,
            "description": description,
        ]
    }
}

extension CredentialsManagerError: CustomNSError {
    
    public var localizedDescription: String {
        switch self {
        case .noCredentials:
            return "No credentials found"
        case .noRefreshToken:
            return "No refresh token found"
        case .failedRefresh(let error):
            return "Refresh failed with error: \(error.localizedDescription)"
        case .touchFailed(let error):
            return "Touch failed with error: \(error.localizedDescription)"
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let type: String
        
        switch self {
        case .noCredentials:
            type = "no_credentials"
        case .noRefreshToken:
            type = "no_refresh_token"
        case .failedRefresh(_):
            type = "failed_refresh"
        case .touchFailed(_):
            type = "touch_failed"
        }
        
        return [
            "error_type": type,
            "error_description": localizedDescription
        ]
    }
}

class CustomAuthenticationError: CustomNSError {
    private let error: AuthenticationError;
    
    init(_ error: AuthenticationError) {
        self.error = error
    }
    
    var errorCode: Int {
        return error.errorCode
    }
    
    public var errorUserInfo: [String : Any] {
        return [
            "code": error.code,
            "statusCode": error.statusCode,
            "description": error.localizedDescription,
            "info": [
                "isNetworkError": false,
                "isBrowserAppNotAvailable": false,
                "isInvalidAuthorizeURL": error.code == "a0.invalid_authorize_url",
                "isInvalidConfiguration": error.code == "a0.invalid_configuration",
                "isAuthenticationCanceled": error.code == "a0.authentication_canceled",
                "isPasswordLeaked": error.code == "password_leaked",
                
                "isMultifactorRequired": error.isMultifactorRequired,
                "isMultifactorEnrollRequired": error.isMultifactorEnrollRequired,
                "isMultifactorTokenInvalid": error.isMultifactorTokenInvalid,
                "isMultifactorCodeInvalid": error.isMultifactorCodeInvalid,
                "isPasswordNotStrongEnough": error.isPasswordNotStrongEnough,
                "isPasswordAlreadyUsed": error.isPasswordAlreadyUsed,
                "isRuleError": error.isRuleError,
                "isInvalidCredentials": error.isInvalidCredentials,
                
                "isAccessDenied": error.isAccessDenied,
                "isLoginRequired": error.code == "login_required"
            ]
        ]
    }
}
