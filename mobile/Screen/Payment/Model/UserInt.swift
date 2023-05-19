

import Foundation
import RealmSwift
struct UserInt : Codable {
    let id : Int?
    let fullName : String?
    let email : String?
    let phone : String?
    let identityCard : String?
    let gender : String?
    let address : String?
    let isActive : Bool?
    let isDeleted : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fullName = "fullName"
        case email = "email"
        case phone = "phone"
        case identityCard = "identityCard"
        case gender = "gender"
        case address = "address"
        case isActive = "isActive"
        case isDeleted = "isDeleted"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        identityCard = try values.decodeIfPresent(String.self, forKey: .identityCard)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        isDeleted = try values.decodeIfPresent(Bool.self, forKey: .isDeleted)
    }

}


final class UserIntObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var fullName : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var phone : String = ""
    @objc dynamic var identityCard : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var isActive : Bool = false
    @objc dynamic var isDeleted : Bool = false
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension UserInt: Persistable {
    public init(managedObject: UserIntObject) {
        id = managedObject.id
        fullName = managedObject.fullName
        email = managedObject.email
        phone = managedObject.phone
        identityCard = managedObject.identityCard
        gender = managedObject.gender
        address = managedObject.address
        isActive = managedObject.isActive
        isDeleted = managedObject.isDeleted
    }
    
    public func managedObject() -> UserIntObject {
        let character = UserIntObject()
        character.id = id ?? 0
        character.fullName = fullName ?? ""
        character.email = email ?? ""
        character.phone = phone ?? ""
        character.identityCard = identityCard ?? ""
        character.gender = gender ?? ""
        character.address = address ?? ""
        character.isActive = isActive ?? false
        character.isDeleted = isDeleted ?? false
        return character
    }
}
