/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift

struct DataMyTicket : Codable {
    var id : String?
    var qrCode : String?
    var discount : Int?
    var isSold : Bool?
    var isCheckin : Bool?
    var ownerId : String?
    var eventId : String?
    var buyerId : String?
    var sessionId : String?
    var ticketCode : String?
    var price : Int?
    var paymentMethod : String?
    var proposalSessionTicketId : String?
    var session : Session?
    var buyer : Buyer?
    var owner : Owner?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case qrCode = "qrCode"
        case discount = "discount"
        case isSold = "isSold"
        case isCheckin = "isCheckin"
        case ownerId = "ownerId"
        case eventId = "eventId"
        case buyerId = "buyerId"
        case sessionId = "sessionId"
        case ticketCode = "ticketCode"
        case price = "price"
        case paymentMethod = "paymentMethod"
        case proposalSessionTicketId = "proposalSessionTicketId"
        case session = "session"
        case buyer = "buyer"
        case owner = "owner"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        qrCode = try values.decodeIfPresent(String.self, forKey: .qrCode)
        discount = try values.decodeIfPresent(Int.self, forKey: .discount)
        isSold = try values.decodeIfPresent(Bool.self, forKey: .isSold)
        isCheckin = try values.decodeIfPresent(Bool.self, forKey: .isCheckin)
        ownerId = try values.decodeIfPresent(String.self, forKey: .ownerId)
        eventId = try values.decodeIfPresent(String.self, forKey: .eventId)
        buyerId = try values.decodeIfPresent(String.self, forKey: .buyerId)
        sessionId = try values.decodeIfPresent(String.self, forKey: .sessionId)
        ticketCode = try values.decodeIfPresent(String.self, forKey: .ticketCode)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
        proposalSessionTicketId = try values.decodeIfPresent(String.self, forKey: .proposalSessionTicketId)
        session = try values.decodeIfPresent(Session.self, forKey: .session)
        buyer = try values.decodeIfPresent(Buyer.self, forKey: .buyer)
        owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
    }

}


final class DataMyTicketObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var qrCode : String = ""
    @objc dynamic var discount : Int = 0
    @objc dynamic var isSold : Bool = true
    @objc dynamic var isCheckin : Bool = true
    @objc dynamic var ownerId : String = ""
    @objc dynamic var eventId : String = ""
    @objc dynamic var buyerId : String = ""
    @objc dynamic var sessionId : String = ""
    @objc dynamic var ticketCode : String = ""
    @objc dynamic var price : Int = 0
    @objc dynamic var paymentMethod : String = ""
    @objc dynamic var proposalSessionTicketId : String = ""

//    @objc dynamic var session : Session?
//    @objc dynamic var buyer : Buyer?
//    @objc dynamic var owner : Owner?
//    let tickets = List<DataMyTicketObject>()
//    var session = Session()
//    var session = List<SessionObject>()
    
    @objc dynamic var session: SessionObject? = nil
    @objc dynamic var owner: OwnerObject? = nil
    @objc dynamic var buyer: BuyerObject? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension DataMyTicket: Persistable {
    public init(managedObject: DataMyTicketObject) {
        id = managedObject.id
        qrCode = managedObject.qrCode
        discount = managedObject.discount
        isSold = managedObject.isSold
        isCheckin = managedObject.isCheckin
        ownerId = managedObject.ownerId
        eventId = managedObject.eventId
        sessionId = managedObject.sessionId
        ticketCode = managedObject.ticketCode
        price = managedObject.price
        paymentMethod = managedObject.paymentMethod
        proposalSessionTicketId = managedObject.proposalSessionTicketId

//        session  = managedObject.session
    }
    
    public func managedObject() -> DataMyTicketObject {
        let character = DataMyTicketObject()
        character.id = id ?? ""
        character.qrCode = qrCode ?? ""
        character.discount = discount ?? 0
        character.isSold = isSold ?? true
        character.isCheckin = isCheckin ?? true
        character.ownerId = ownerId ?? ""
        character.eventId = eventId ?? ""
        character.sessionId = sessionId ?? ""
        character.price = price ?? 0
        character.ticketCode = ticketCode ?? ""
        character.paymentMethod = paymentMethod ?? ""
        character.proposalSessionTicketId = proposalSessionTicketId ?? ""
        character.session = session?.managedObject()
        character.owner = owner?.managedObject()
        character.buyer = buyer?.managedObject()

//        character.session = List<SessionObject>()
//        character.session.append(session?.managedObject() ?? SessionObject())
        return character
    }
}
