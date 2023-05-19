/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/


import Foundation
import RealmSwift
struct DataReponsePaymentHistory : Codable {
	var id : Int?
	var price : Int?
	var currency : String?
	var method : String?
	var intent : String?
	var requesterId : Int?
	var paymentId : String?
	var description : String?
	var status : String?
	var eventInfoId : Int?
	var createdAt : String?
	var purchasedAt : String?
	var eventInformation : EventInformation?
	var user : UserInt?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case price = "price"
		case currency = "currency"
		case method = "method"
		case intent = "intent"
		case requesterId = "requesterId"
		case paymentId = "paymentId"
		case description = "description"
		case status = "status"
		case eventInfoId = "eventInfoId"
		case createdAt = "createdAt"
		case purchasedAt = "purchasedAt"
		case eventInformation = "eventInformation"
		case user = "user"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		currency = try values.decodeIfPresent(String.self, forKey: .currency)
		method = try values.decodeIfPresent(String.self, forKey: .method)
		intent = try values.decodeIfPresent(String.self, forKey: .intent)
		requesterId = try values.decodeIfPresent(Int.self, forKey: .requesterId)
		paymentId = try values.decodeIfPresent(String.self, forKey: .paymentId)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		eventInfoId = try values.decodeIfPresent(Int.self, forKey: .eventInfoId)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		purchasedAt = try values.decodeIfPresent(String.self, forKey: .purchasedAt)
		eventInformation = try values.decodeIfPresent(EventInformation.self, forKey: .eventInformation)
		user = try values.decodeIfPresent(UserInt.self, forKey: .user)
	}

}


final class DataReponsePaymentHistoryObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var price : Int = 0
    @objc dynamic var currency : String = ""
    @objc dynamic var method : String = ""
    @objc dynamic var intent : String = ""
    @objc dynamic var requesterId : Int = 0
    @objc dynamic var paymentId : String = ""
    @objc dynamic var description1 : String = ""
    @objc dynamic var status : String = ""
    @objc dynamic var eventInfoId : Int = 0
    @objc dynamic var createdAt : String = ""
    @objc dynamic var purchasedAt : String = ""
    @objc dynamic var eventInformation : EventInformationObject? = nil
    @objc dynamic var user: UserIntObject? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension DataReponsePaymentHistory: Persistable {
    public init(managedObject: DataReponsePaymentHistoryObject) {
        id = managedObject.id
        price = managedObject.price
        currency = managedObject.currency
        method = managedObject.method
        intent = managedObject.intent
        requesterId = managedObject.requesterId
        paymentId = managedObject.paymentId
        description = managedObject.description1
        status = managedObject.status
        eventInfoId = managedObject.eventInfoId
        createdAt = managedObject.createdAt
        purchasedAt  = managedObject.purchasedAt
    }
    
    public func managedObject() -> DataReponsePaymentHistoryObject {
        let character = DataReponsePaymentHistoryObject()
        character.id = id ?? 0
        character.price = price ?? 0
        character.currency = currency ?? ""
        character.method = method ?? ""
        character.intent = intent ?? ""
        character.requesterId = requesterId ?? 0
        character.paymentId = paymentId ?? ""
        character.description1 = description ?? ""
        character.status = status ?? ""
        character.eventInfoId = eventInfoId ?? 0
        character.createdAt = createdAt ?? ""
        character.purchasedAt = purchasedAt ?? ""
        character.eventInformation = eventInformation?.managedObject()
        character.user = user?.managedObject()
        return character
    }
}
