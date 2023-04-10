/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift



struct ReponseBoughtTicket : Codable {
    var statusCode : Int?
    var page : Int?
    var total : Int?
    var data : [DataBoughtTicket]?

    enum CodingKeys: String, CodingKey {

        case statusCode = "statusCode"
        case page = "page"
        case total = "total"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        data = try values.decodeIfPresent([DataBoughtTicket].self, forKey: .data)
    }

}

final class ReponseBoughtTicketObject: Object {
    @objc dynamic var statusCode = 0
    @objc dynamic var page = 0
    @objc dynamic var total = 0
//    let tickets = List<DataMyTicketObject>()

    override static func primaryKey() -> String? {
        return "statusCode"
    }
}

extension ReponseBoughtTicket: Persistable {
    public init(managedObject: ReponseBoughtTicketObject) {
        statusCode = managedObject.statusCode
        page = managedObject.page
        total = managedObject.total
    }

    public func managedObject() -> ReponseBoughtTicketObject {
        let character = ReponseBoughtTicketObject()
        character.statusCode = statusCode ?? 400
        character.page = page ?? 0
        character.total = total ?? 0
        return character
    }
}