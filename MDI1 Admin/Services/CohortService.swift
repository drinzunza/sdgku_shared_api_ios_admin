
import Foundation

struct CohortService {
    
    // MARK: - Cohort API Methods
    
    /// Create a new cohort
    static func createCohort(cohort: Cohort) async throws -> Cohort {
        let (data, _) = try await Http.sendPostRequest(payload: cohort, to: "/api/admin/cohorts", expectedStatus: 201)
        return try Http.decode(data, to: Cohort.self)
    }
    
    /// Get all cohorts
    static func getAllCohorts() async throws -> [Cohort] {
        let (data, _) = try await Http.sendGetRequest(to: "/api/admin/cohorts")
        return try Http.decode(data, to: [Cohort].self)
    }
    
    /// Get a specific cohort by ID
    static func getCohort(id: UUID) async throws -> Cohort {
        let (data, _) = try await Http.sendGetRequest(to: "/api/admin/cohorts/\(id.uuidString)")
        return try Http.decode(data, to: Cohort.self)
    }
    
    /// Update a cohort
    static func updateCohort(id: UUID, cohort: Cohort) async throws -> Cohort {
        let (data, _) = try await Http.sendPatchRequest(payload: cohort, to: "/api/admin/cohorts/\(id.uuidString)")
        return try Http.decode(data, to: Cohort.self)
    }
    
    /// Delete a cohort
    static func deleteCohort(id: UUID) async throws {
        _ = try await Http.sendDeleteRequest(to: "/api/admin/cohorts/\(id.uuidString)")
    }
}
