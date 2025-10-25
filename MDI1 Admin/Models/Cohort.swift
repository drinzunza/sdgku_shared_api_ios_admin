import Foundation

struct Cohort: Identifiable, Hashable, Codable {
    var id: UUID?
    var name: String
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
