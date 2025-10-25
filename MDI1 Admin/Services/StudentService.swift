import Foundation

struct StudentService {
    
    // MARK: - Student API Methods
    
    /// Create a new student
    static func createStudent(student: Student) async throws -> Student {
        let (data, _) = try await Http.sendPostRequest(payload: student, to: "/api/admin/students", expectedStatus: 201)
        return try Http.decode(data, to: Student.self)
    }
    
    /// Get all students
    static func getAllStudents() async throws -> [Student] {
        let (data, _) = try await Http.sendGetRequest(to: "/api/admin/students")
        return try Http.decode(data, to: [Student].self)
    }
    
    /// Get students by cohort
    static func getStudentsByCohort(cohort: String) async throws -> [Student] {
        let (data, _) = try await Http.sendGetRequest(to: "/api/admin/students/cohort/\(cohort)")
        return try Http.decode(data, to: [Student].self)
    }
    
    /// Get a specific student by ID
    static func getStudent(id: UUID) async throws -> Student {
        let (data, _) = try await Http.sendGetRequest(to: "/api/admin/students/\(id.uuidString)")
        return try Http.decode(data, to: Student.self)
    }
    
    /// Update a student
    static func updateStudent(id: UUID, student: Student) async throws -> Student {
        let (data, _) = try await Http.sendPatchRequest(payload: student, to: "/api/admin/students/\(id.uuidString)")
        return try Http.decode(data, to: Student.self)
    }
    
    /// Delete a student
    static func deleteStudent(id: UUID) async throws {
        _ = try await Http.sendDeleteRequest(to: "/api/admin/students/\(id.uuidString)")
    }
    
    /// Update student's allowed entities
    static func updateStudentEntities(id: UUID, entities: [String]) async throws -> Student {
        let (data, _) = try await Http.sendPutRequest(payload: entities, to: "/api/admin/students/\(id.uuidString)/entities")
        return try Http.decode(data, to: Student.self)
    }
}
