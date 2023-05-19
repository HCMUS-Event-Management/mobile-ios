/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import RealmSwift
struct EventInformation : Codable {
	let id : Int?
	let eventId : Int?
	let title : String?
	let description : String?
	let startAt : String?
	let endAt : String?
	let location : String?
	let type : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case eventId = "eventId"
		case title = "title"
		case description = "description"
		case startAt = "startAt"
		case endAt = "endAt"
		case location = "location"
		case type = "type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		startAt = try values.decodeIfPresent(String.self, forKey: .startAt)
		endAt = try values.decodeIfPresent(String.self, forKey: .endAt)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		type = try values.decodeIfPresent(String.self, forKey: .type)
	}

}



final class EventInformationObject: Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var eventId : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var description1 : String = ""
    @objc dynamic var startAt : String = ""
    @objc dynamic var endAt : String = ""
    @objc dynamic var location : String = ""
    @objc dynamic var type : String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension EventInformation: Persistable {
    public init(managedObject: EventInformationObject) {
        id = managedObject.id
        eventId = managedObject.eventId
        title = managedObject.title
        description = managedObject.description1
        startAt = managedObject.startAt
        endAt = managedObject.endAt
        location = managedObject.location
        type = managedObject.type
    }
    
    public func managedObject() -> EventInformationObject {
        let character = EventInformationObject()
        character.id = id ?? 0
        character.eventId = eventId ?? 0
        character.title = title ?? ""
        character.description1 = description ?? ""
        character.startAt = startAt ?? ""
        character.endAt = endAt ?? ""
        character.location = location ?? ""
        character.type = type ?? ""
        return character
    }
}
