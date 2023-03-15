//
//  TokenService.swift
//  mobile
//
//  Created by NguyenSon_MP on 08/03/2023.
//

import Foundation

class TokenService {
    static let tokenInstance = TokenService()
    
    func saveToken(token: String, refreshToken: String) {
        Contanst.userdefault.set(token, forKey: "userToken")
        Contanst.userdefault.set(refreshToken, forKey: "refreshToken")
    }
    
    func getToken(key: String) -> String {
        if let token = Contanst.userdefault.object(forKey: key) as? String {
            return token
        } else {
            return ""
        }
    }
    
    func checkForLogin() -> Bool {
        if getToken(key: "userToken") != "" {
            let infoToken = try! decode(jwtToken: getToken(key: "userToken"))
            print(infoToken["exp"]!)
            print(Date.now.timeIntervalSince1970)
            if Date.now.timeIntervalSince1970.isLessThanOrEqualTo(infoToken["exp"]! as! Double) {
                return loginByRefreshToken()
            }
            return false
            
        } else {
            return false
        }
    }
    
    func loginByRefreshToken() -> Bool {
        
        return true
    }
    
    func removeTokenAndInfo() {
        Contanst.userdefault.removeObject(forKey: "userInfoDetail")
        Contanst.userdefault.removeObject(forKey: "userInfo")
        Contanst.userdefault.removeObject(forKey: "userToken")
        Contanst.userdefault.removeObject(forKey: "refreshToken")
    }
}

extension TokenService{
    func decode(jwtToken jwt: String) throws -> [String: Any] {

        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Foundation.Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Foundation.Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}
