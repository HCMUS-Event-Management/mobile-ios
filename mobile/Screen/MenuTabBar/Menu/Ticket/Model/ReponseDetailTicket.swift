

import Foundation
import RealmSwift

struct ReponseDetailTicket : Codable {
    var statusCode : Int?
    var message : String?
    var data : DataMyTicket?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(DataMyTicket.self, forKey: .data)
    }

}

final class ReponseDetailTicketObject: Object {
    @objc dynamic var statusCode = 0
    @objc dynamic var message = ""
//    let tickets = List<DataMyTicketObject>()
//    @objc dynamic var data: DataMyTicketObject? = nil


    override static func primaryKey() -> String? {
        return "statusCode"
    }
}

extension ReponseDetailTicket: Persistable {
    public init(managedObject: ReponseDetailTicketObject) {
        statusCode = managedObject.statusCode
        message = managedObject.message
//        total = managedObject.total
    }

    public func managedObject() -> ReponseDetailTicketObject {
        let character = ReponseDetailTicketObject()
        character.statusCode = statusCode ?? 400
        character.message = message ?? ""
//        character.data = data?.managedObject()
        return character
    }
}
