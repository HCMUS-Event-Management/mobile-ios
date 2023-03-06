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
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

enum DataError: Error {
    case invalidResponse
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

            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
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
            "Authorization": "Bearer \(Contanst.userdefault.string(forKey: "userToken")!)",
        ]
    }
    
    



    /*
    func fetchProducts(completion: @escaping Handler) {
        guard let url = URL(string: Constant.API.productURL) else {
            completion(.failure(.invalidURL)) // I forgot to mention this in the video
            return
        }
        // Background task
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            // JSONDecoder() - Data ka Model(Array) mai convert karega
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            }catch {
                completion(.failure(.network(error)))
            }

        }.resume()
        print("Ended")
    }
    */
}

/*
class A: APIManager {

    override func temp() {
        <#code#>
    }

    func configuration() {
        let manager = APIManager()
        manager.temp()

        // APIManager.temp()
        APIManager.shared.temp()
    }

}
*/

// singleton - singleton class ka object create hoga outside of the class
// Singleton - singleton class ka object create nahi hoga outside of the class
