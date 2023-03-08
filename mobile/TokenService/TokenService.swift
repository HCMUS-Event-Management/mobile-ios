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
            return true
        } else {
            return false
        }
    }
    
    func removeTokenAndInfo() {
        Contanst.userdefault.removeObject(forKey: "userInfoDetail")
        Contanst.userdefault.removeObject(forKey: "userInfo")
        Contanst.userdefault.removeObject(forKey: "userToken")
        Contanst.userdefault.removeObject(forKey: "refreshToken")
    }
}
