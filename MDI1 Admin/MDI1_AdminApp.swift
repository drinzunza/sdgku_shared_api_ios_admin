import SwiftUI
import SwiftData

@main
struct MDI1_AdminApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Student.self, // List your models here
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CohortsList()
        }
        .modelContainer(sharedModelContainer)
    }
}
