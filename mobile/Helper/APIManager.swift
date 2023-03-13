//
//  APIManager.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import Foundation
import Alamofire
import UIKit
// Singleton Design Pattern

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

enum DataError: Error, Equatable {
    
    static func == (lhs: DataError, rhs: DataError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case invalidResponse
    case invalidResponse400
    case invalidResponse500
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias Handler<T> = (Swift.Result<T, DataError>) -> Void


final class APIManager {
    
    static let shared = APIManager()
    private init() {}

    func encodeBody<T: Encodable>(value: T) throws -> Foundation.Data? {
        let data = try? JSONEncoder().encode(value)
        return data
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        type: EndPointType,
        params: Foundation.Data?,
        completion: @escaping Handler<T>
    ) {
        guard let url = type.url else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        
        if (params != nil) {
            request.httpBody = params
        }

        request.allHTTPHeaderFields = type.headers
        
        // Background task
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
        print(response)

            if let response = response as? HTTPURLResponse,
                  400 ~= response.statusCode {
                completion(.failure(.invalidResponse400))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                  500 ~= response.statusCode {
                completion(.failure(.invalidResponse500))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
//                do {
//                    let dataType = try JSONDecoder().decode(ReponseCommon.self, from: data)
//                    print(dataType)
//                    completion(.failure(.invalidResponse(dataType.message ?? "")))
//                }catch {
//                    completion(.failure(.network(error)))
//                }
//                if response.statusCode
                
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let dataType = try JSONDecoder().decode(modelType, from: data)
                completion(.success(dataType))
            }catch {
                completion(.failure(.network(error)))
            }

        }.resume()
    }
    
    
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    static var bearTokenHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(TokenService.tokenInstance.getToken(key: "userToken"))",
        ]
    }
}
