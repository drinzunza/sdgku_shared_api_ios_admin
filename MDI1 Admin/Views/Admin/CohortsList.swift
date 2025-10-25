import SwiftUI
import Foundation

struct CohortsList: View {
    @State private var cohorts: [Cohort] = []
    @State private var isLoading: Bool = false
    @State private var showAdminSettings: Bool = false
    @State private var showCreateCohort: Bool = false
    @State private var isCreating: Bool = false
    @State private var errorMessage: String? = nil
    
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
                        Task {
                            await fetchCohorts()
                        }
                    }
                }
            }
            .navigationTitle("Cohorts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showCreateCohort = true
                    }) {
                        Label("Add Cohort", systemImage: "plus")
                    }
                }
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
            .sheet(isPresented: $showCreateCohort) {
                CreateSheet(
                    title: "New Cohort",
                    subTitle: "Cohort name",
                    okText: "Save",
                    isLoading: isCreating,
                    errorMessage: errorMessage,
                    onConfirm: { text in
                        Task {
                            await saveCohort(text)
                        }
                    },
                    onCancel: {
                        self.showCreateCohort = false
                    }
                )
            }
            .onAppear {
                if cohorts.isEmpty {
                    Task {
                        await fetchCohorts()
                    }
                }
            }
        }
    }
    
    // MARK: - Data Methods
    
    private func fetchCohorts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            cohorts = try await CohortService.getAllCohorts()
            print("Retrieved \(cohorts.count) cohorts")
            isLoading = false
        } catch {
            print("Error fetching cohorts: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func saveCohort(_ newCohortName: String) async {
        isCreating = true
        errorMessage = nil
        
        do {
            let newCohort = Cohort(name: newCohortName)
            let createdCohort = try await CohortService.createCohort(cohort: newCohort)
            
            // Add to local list
            cohorts.append(createdCohort)
            cohorts.sort { $0.name < $1.name }
            
            // Reset and close
            showCreateCohort = false
            isCreating = false
        } catch {
            print("Error saving cohort: \(error)")
            errorMessage = error.localizedDescription
            isCreating = false
        }
    }
}

#Preview {
    return CohortsList()
}
