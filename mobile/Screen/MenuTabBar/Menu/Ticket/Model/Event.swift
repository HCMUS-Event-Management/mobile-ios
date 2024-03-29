/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct Event : Codable {
    var id : String?
    var title : String?
    var description : String?
    var startAt : String?
    var endAt : String?
    var status : String?
    var urlWeb : String?
    var image : String?
    var locationId : String?
    var seatingPlan : String?
    var createdAt : String?
    var updatedAt : String?
    var type : String?
    var isOnline : Bool?
    var categoryId : String?
    var userId : String?
    var user : User?
    var location : Location?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description = "description"
        case startAt = "startAt"
        case endAt = "endAt"
        case status = "status"
        case urlWeb = "urlWeb"
        case image = "image"
        case locationId = "locationId"
        case seatingPlan = "seatingPlan"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case type = "type"
        case isOnline = "isOnline"
        case categoryId = "categoryId"
        case userId = "userId"
        case user = "user"
        case location = "location"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        startAt = try values.decodeIfPresent(String.self, forKey: .startAt)
        endAt = try values.decodeIfPresent(String.self, forKey: .endAt)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        urlWeb = try values.decodeIfPresent(String.self, forKey: .urlWeb)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        locationId = try values.decodeIfPresent(String.self, forKey: .locationId)
        seatingPlan = try values.decodeIfPresent(String.self, forKey: .seatingPlan)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        isOnline = try values.decodeIfPresent(Bool.self, forKey: .isOnline)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        location = try values.decodeIfPresent(Location.self, forKey: .location)

    }

}


final class EventObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var descrip: String = ""
    @objc dynamic var startAt : String = ""
    @objc dynamic var endAt : String = ""
    @objc dynamic var status : String = ""
    @objc dynamic var urlWeb : String = ""
    @objc dynamic var image : String = ""
    @objc dynamic var locationId : String = ""
    @objc dynamic var seatingPlan: String = ""
    @objc dynamic var createdAt : String = ""
    @objc dynamic var updatedAt : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var isOnline : Bool = false
    @objc dynamic var categoryId : String = ""
    @objc dynamic var userId : String = ""
    @objc dynamic var user: UserObject? = nil
    @objc dynamic var location: LocationObject? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Event: Persistable {
    public init(managedObject: EventObject) {
        id = managedObject.id
        title = managedObject.title
        description = managedObject.descrip
        startAt = managedObject.startAt
        endAt = managedObject.endAt
        status = managedObject.status
        urlWeb = managedObject.urlWeb
        image = managedObject.image
        locationId = managedObject.locationId
        seatingPlan = managedObject.seatingPlan
        createdAt = managedObject.createdAt
        updatedAt = managedObject.updatedAt
        type = managedObject.type
        isOnline = managedObject.isOnline
        categoryId = managedObject.categoryId
        userId = managedObject.userId
    }
    
    public func managedObject() -> EventObject {
        let character = EventObject()
        character.id = id ?? ""
        character.title = title ?? ""
        character.descrip = description ?? ""
        character.startAt = startAt ?? ""
        character.endAt = endAt ?? ""
        character.status = status ?? ""
        character.urlWeb = urlWeb ?? ""
        character.image = image ?? ""
        character.locationId = locationId ?? ""
        character.seatingPlan = seatingPlan ?? ""
        character.createdAt = createdAt ?? ""
        character.updatedAt = updatedAt ?? ""
        character.type = type ?? ""
        character.isOnline = isOnline ?? false
        character.categoryId = categoryId ?? ""
        character.userId = userId ?? ""
        character.user =  user?.managedObject()
        character.location =  location?.managedObject()

        return character
    }
}
