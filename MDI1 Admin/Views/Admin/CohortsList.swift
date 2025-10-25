import SwiftUI
import Foundation

struct CohortsList: View {
    @State private var cohorts: [Cohort] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showAdminSettings: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Backgrounds.gradient1
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView("Loading cohorts...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Text("Error loading cohorts")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await fetchCohorts()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List(cohorts) { cohort in
                        NavigationLink {
                            StudentsList(cohort: cohort)
                        } label: {
                            Text(cohort.name)
                        }
                    }
                    .cornerRadius(7)
                    .listStyle(.plain)
                    .padding(10)
                    .refreshable {
                        await fetchCohorts()
                    }
                }
            }
            .navigationTitle("Cohorts")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showAdminSettings = true
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .navigationDestination(isPresented: $showAdminSettings) {
                AppSettings()
            }
            .task {
                await fetchCohorts()
            }
        }
    }
    
    private func fetchCohorts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let students = try await DataService.getAllStudents()
            
            // Extract unique cohorts from students
            let uniqueCohortNames = Set(students.map { $0.cohort })
            cohorts = uniqueCohortNames.sorted().map { Cohort(name: $0) }
            
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

#Preview {
    return CohortsList()
}
