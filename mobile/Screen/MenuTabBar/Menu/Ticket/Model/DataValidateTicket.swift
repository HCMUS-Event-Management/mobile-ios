//
//  File.swift
//  mobile
//
//  Created by NguyenSon_MP on 17/06/2023.
//

import Foundation

struct DataValidateTicket : Codable {
    let isValid : Bool?

    enum CodingKeys: String, CodingKey {

        case isValid = "isValid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isValid = try values.decodeIfPresent(Bool.self, forKey: .isValid)
    }

}
