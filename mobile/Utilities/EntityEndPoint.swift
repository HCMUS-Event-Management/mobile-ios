//
//  EntityEndPoint.swift
//  mobile
//
//  Created by NguyenSon_MP on 02/04/2023.
//

import Foundation

enum EntityEndPoint {
    case myTicket(page: Int, perPage: Int)
    case ticketDetail(ticketCode: String)
    case boughtTicket(page: Int, perPage: Int)
    case search(query: String)
}


extension EntityEndPoint: EndPointType {
    var path: String {
        switch self {
            
        case .myTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/my?page=\(page)&perPage=\(perPage)"
        case .ticketDetail(ticketCode: let ticketCode):
            return "api/v1/entity/ticket/\(ticketCode)"
        case .boughtTicket(page: let page, perPage: let perPage):
            return "api/v1/entity/ticket/bought?page=\(page)&perPage=\(perPage)"
        case .search(query: let query):
            return "api/v1/entity/event/search?query=\(query)"
        }
    }
    
    var baseURL: String {
        return ProcessInfo.processInfo.environment["BASE_URL1"]!
    }

    var url: URL? {
//        switch self {
//        case .myTicket(let page, let perPage): return URL(string: "\(baseURL)\(path)")
//        case .ticketDetail(let ticketCode): return URL(string: "\(baseURL)\(path)")
//        case .boughtTicket(let page, let perPage):
//            return URL(string: "\(baseURL)\(path)")
//        case .search(let query):
//            return URL(string:"https://itunes.apple.com/search?term=\(query)&entity=software,iPadSoftware&limit=10")
//        }
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .myTicket:
            return .get
        case .ticketDetail:
            return .get
        case .boughtTicket:
            return .get
        case .search(query: let query):
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .myTicket:
            return nil
        case .ticketDetail:
            return nil
        case .boughtTicket:
            return nil
        case .search:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myTicket:
            return APIManager.bearTokenHeaders
        case .ticketDetail:
            return APIManager.bearTokenHeaders
        case .boughtTicket:
            return APIManager.bearTokenHeaders
        case .search:
            return APIManager.commonHeaders
        }
    }
    
    
}
