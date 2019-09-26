//
//  JSONHelpers.swift
//  auth0_flutter
//
//  Created by Juan Alvarez on 9/25/19.
//

import Foundation
import Auth0

extension Decodable {
    static func decode(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}

extension Credentials {
    func toJSON() -> [String: Any] {
        let json: [String : Any?] = [
            "access_token": self.accessToken,
            "token_type": self.tokenType,
            "expires_in": self.expiresIn?.timeIntervalSinceNow,
            "refresh_token": self.refreshToken,
            "id_token": self.idToken,
            "scope": self.scope
        ]
        
        let result = json.compactMapValues { $0 }
        
        return result
    }
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

extension Identity {
    func toJSON() -> [String: Any] {
        let json: [String: Any?] = [
            "identifier": self.identifier,
            "provider": self.provider,
            "connection": self.connection,
            "social": self.social,
            "profileData": self.profileData,
            "accessToken": self.accessToken,
            "expiresIn": self.expiresIn?.timeIntervalSince1970,
            "accessTokenSecret": self.accessTokenSecret
        ]
        
        let result = json.compactMapValues { $0 }
        
        return result
    }
}

extension Profile {
    func toJSON() -> [String: Any] {
        let json: [String: Any?] = [
            "id": self.id,
            "name": self.name,
            "nickname": self.nickname,
            "pictureURL": self.pictureURL.absoluteString,
            "createdAt": self.createdAt.timeIntervalSince1970,
            "email": self.email,
            "emailVerified": self.emailVerified,
            "givenName": self.givenName,
            "familyName": self.familyName,
            "additionalAttributes": self.additionalAttributes,
            "identities": self.identities.map { $0.toJSON() },
        ]
        
        let result = json.compactMapValues { $0 }
        
        return result
    }
}

extension UserInfo {
    func toJSON() -> [String: Any] {
        let json: [String: Any?] = [
            "sub": self.sub,
            "name": self.name,
            "givenName": self.givenName,
            "familyName": self.familyName,
            "middleName": self.middleName,
            "nickname": self.nickname,
            "preferredUsername": self.preferredUsername,
            "profile": self.profile?.absoluteString,
            "picture": self.picture?.absoluteString,
            "website": self.website?.absoluteString,
            "email": self.email,
            "emailVerified": self.emailVerified,
            "gender": self.gender,
            "birthdate": self.birthdate,
            "zoneinfo": self.zoneinfo?.identifier,
            "locale": self.locale?.identifier,
            "phoneNumber": self.phoneNumber,
            "phoneNumberVerified": self.phoneNumberVerified,
            "address": self.address,
            "updatedAt": self.updatedAt?.timeIntervalSince1970,
            "customClaims": self.customClaims
        ]
        
        let result = json.compactMapValues { $0 }
        
        return result
    }
}
