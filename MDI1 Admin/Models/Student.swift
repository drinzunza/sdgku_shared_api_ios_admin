import Foundation

struct Student: Identifiable, Codable {
    var id: UUID?
    var fullName: String
    var cohort: String
    var email: String
    var authKey: String
    var allowedEntities: [String]
    
    init(id: UUID? = nil, fullName: String, cohort: String, email: String, passKey: String, allowedEntities: [String] = []) {
        self.id = id
        self.fullName = fullName
        self.cohort = cohort
        self.email = email
        self.authKey = passKey
        self.allowedEntities = allowedEntities
    }
}
