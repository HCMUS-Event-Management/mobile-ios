/*
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct Session : Codable {
    var id : String?
    var eventId : String?
    var startAt : String?
    var endAt : String?
    var holderId : String?
    var event : Event?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case eventId = "eventId"
        case startAt = "startAt"
        case endAt = "endAt"
        case holderId = "holderId"
        case event = "event"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        eventId = try values.decodeIfPresent(String.self, forKey: .eventId)
        startAt = try values.decodeIfPresent(String.self, forKey: .startAt)
        endAt = try values.decodeIfPresent(String.self, forKey: .endAt)
        holderId = try values.decodeIfPresent(String.self, forKey: .holderId)
        event = try values.decodeIfPresent(Event.self, forKey: .event)
    }

}


final class SessionObject: Object {
    @objc dynamic var id : String = ""
    @objc dynamic var eventId : String = ""
    @objc dynamic var startAt : String = ""
    @objc dynamic var endAt : String = ""
    @objc dynamic var holderId : String = ""
    @objc dynamic var event : EventObject?

    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Session: Persistable {
    public init(managedObject: SessionObject) {
        id = managedObject.id
        eventId = managedObject.eventId
        startAt = managedObject.startAt
        endAt = managedObject.endAt
        holderId = managedObject.holderId
    }
    
    public func managedObject() -> SessionObject {
        let character = SessionObject()
        character.id = id ?? ""
        character.eventId = eventId ?? ""
        character.startAt = startAt ?? ""
        character.endAt = endAt ?? ""
        character.holderId = holderId ?? ""
        character.event = event?.managedObject()

        return character
    }
}
