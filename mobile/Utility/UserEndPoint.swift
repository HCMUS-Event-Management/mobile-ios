//
//  ProductEndPoint.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 15/01/23.
//

import Foundation

enum UserEndPoint {
    case profile // Module - GET
    case login(infoLogin: InfoLogin) // POST
    case logout // POST
    case updateProfile // POST
}

// https://fakestoreapi.com/products
extension UserEndPoint: EndPointType {
    

    var path: String {
        switch self {
        case .profile:
            return "api/v1/user-auth/user/my-profile"
        case .login:
            return "api/v1/user-auth/user/sign-in"
        case .logout:
            return "api/v1/user-auth/user/log-out"
        case .updateProfile:
            return "api/v1/user-auth/user/update-profile"
        }
        
        
    }

    var baseURL: String {
        return ProcessInfo.processInfo.environment["BASE_URL"]!
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .profile:
            return .get
        case .login:
            return .post
        case .logout:
            return .post
        case .updateProfile:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .profile:
            return nil
        case .login(let Info):
            return Info
        case .logout:
            return nil
        case .updateProfile:
            return nil
        }
    
    }

    var headers: [String : String]? {
        switch self {
        case .profile:
            return APIManager.bearTokenHeaders
        case .login(let infoLogin):
            return APIManager.commonHeaders
        case .logout:
            return APIManager.bearTokenHeaders
        case .updateProfile:
            return APIManager.bearTokenHeaders
        }
    }
}
