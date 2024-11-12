import Foundation

@Observable
class Todo: Identifiable, Codable {
    var id: UUID
    var name: String
    var dateCompleted: Date?

    var isComplete: Bool {
        get { dateCompleted != nil }
        set { dateCompleted = .now }
    }

    init(id: UUID = UUID(), name: String, dateCompleted: Date? = nil) {
        self.id = id
        self.name = name
        self.dateCompleted = dateCompleted
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case dateCompleted
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        dateCompleted = try container.decode(Date?.self, forKey: .dateCompleted)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(dateCompleted, forKey: .dateCompleted)
    }
}
