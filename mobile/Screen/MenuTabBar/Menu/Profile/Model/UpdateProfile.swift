//
//  UpdateProfile.swift
//  mobile
//
//  Created by NguyenSon_MP on 06/03/2023.
//

import Foundation

struct UpdateProfile: Codable {
    var fullName: String?
    var phone: String?
    var birthday: String?
    var identityCard: String?
    var gender: String?
    var avatar: String?
    var address: String?
    var isDeleted: Bool?
}
