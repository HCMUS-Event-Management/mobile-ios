////
////  APIManager.swift
////  mobile
////
////  Created by NguyenSon_MP on 23/02/2023.
////
//
//import Foundation
//import Alamofire
//
//
//
////enum HTTPMethods: String {
////    case get = "GET"
////    case post = "POST"
////}
////
////protocol EndPointType {
////    var path: String { get }
////    var baseURL: String { get }
////    var url: URL? { get }
////    var method: HTTPMethods { get }
////    var body: Encodable? { get }
////    var headers: [String: String]? { get }
////}
//
//enum DataError: Error {
//    case invalidResponse
//    case invalidURL
//    case invalidData
//    case network(Error?)
//}
//
//typealias Handler<T> = (Swift.Result<T, DataError>) -> Void
//
//// singleton
//final class APIManager {
//    static let shared = APIManager()
//    private init(){}
//
////    private func parseData(_ data: DataResponse<Any>) -> Any {
////        switch data.result {
////        case .success(let value):
////            guard let data = value as? [String:Any], let dataObject = data["data"] as? Data else {
////                return "Error Parse Data"
////            }
////            print(type(of: dataObject))
////            return dataObject
////        case .failure(let err):
////            print(err)
////        }
////        return "Nothing"
////    }
////
////    private func sendPostRequest(_ params: [String:Any]?,_ url: URL) -> Any {
////        Alamofire.request(url, method: .post, parameters: params, headers: nil).responseJSON{[weak self] (response) in
////            self?.parseData(response)
////        }
////    }
////
//
//
//    func request<T: Codable>(
//        modelType: T.Type,
//        type: EndPointType,
//        completion: @escaping Handler<T>
//    ) {
//        guard let url = type.url else {
//            completion(.failure(.invalidURL)) // I forgot to mention this in the video
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = type.method.rawValue
//
//        if let parameters = type.body {
//            print(parameters)
////            request.httpBody = try? JSONEncoder().encode(parameters)
//        }
//
//        request.allHTTPHeaderFields = type.headers
//
//        // Background task
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(.invalidData))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse,
//                  200 ... 299 ~= response.statusCode else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//            // JSONDecoder() - Data ka Model(Array) mai convert karega
//            do {
//                let dataType = try JSONDecoder().decode(modelType, from: data)
//                completion(.success(dataType))
//            }catch {
//                completion(.failure(.network(error)))
//            }
//
//        }.resume()
//    }
//
//
//    static var commonHeaders: [String: String] {
//        return [
//            "Content-Type": "application/json"
//        ]
//    }
//
//
//
//    func login(params: [String:Any]?) {
//        guard let url = URL(string: Contanst.API.loginURL) else {
////            completion(.failure(.invalidURL)) // I forgot to mention this in the video
//            return
//        }
//
//
//
//        APIManager.shared.request(
//            modelType: Data.self, // response type
//            type: ) { result in
//                switch result {
//                case .success(let info): break
////                    self.eventHandler?(.newProductAdded(product: product))
//                case .failure(let error): break
////                    self.eventHandler?(.error(error))
//                }
//            }
//
//
////        sendPostRequest(params, url)
//
//
//        // Background task
////        URLSession.shared.dataTask(with: url) { data, response, error in
////
////            guard let data = data, error == nil else {
////                completion(.failure(.invalidData))
////                return
////            }
////            guard let response = response as? HTTPURLResponse,
////                  200 ... 299 ~= response.statusCode else {
////                completion(.failure(.invalidResponse))
////                return
////            }
////            // JSONDecoder() - Data ka Model(Array) mai convert karega
////            do {
////                let dataDB = try JSONDecoder().decode([Data].self, from: data)
////                completion(.success(dataDB))
////            }catch {
////                completion(.failure(.network(error)))
////            }
////
////        }.resume()
////        print("Ended")
//
//
//
//
//
//
//    }
//
//
//
//    /*
//    func fetchProducts(completion: @escaping Handler) {
//
//    }
//    */
//}
