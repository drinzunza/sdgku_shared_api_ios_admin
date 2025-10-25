import SwiftUI
import Foundation

struct CohortsList: View {
    @State private var cohorts: [Cohort] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showAdminSettings: Bool = false
    @State private var showCreateCohort: Bool = false
    @State private var newCohortName: String = ""
    @State private var isCreating: Bool = false
    
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
                createCohortSheet
            }
            .task {
                await fetchCohorts()
            }
        }
    }
    
    // MARK: - Create Cohort Sheet
    
    private var createCohortSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Cohort Information")) {
                    TextField("Cohort Name", text: $newCohortName)
                        .textFieldStyle(.roundedBorder)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("New Cohort")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showCreateCohort = false
                        newCohortName = ""
                        errorMessage = nil
                    }
                    .disabled(isCreating)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveCohort()
                        }
                    }
                    .disabled(newCohortName.isEmpty || isCreating)
                }
            }
            .overlay {
                if isCreating {
                    ProgressView("Creating cohort...")
                        .padding()
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .shadow(radius: 10)
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
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func saveCohort() async {
        isCreating = true
        errorMessage = nil
        
        do {
            let newCohort = Cohort(name: newCohortName)
            let createdCohort = try await CohortService.createCohort(cohort: newCohort)
            
            // Add to local list
            cohorts.append(createdCohort)
            cohorts.sort { $0.name < $1.name }
            
            // Reset and close
            newCohortName = ""
            showCreateCohort = false
            isCreating = false
        } catch {
            errorMessage = error.localizedDescription
            isCreating = false
        }
    }
}

#Preview {
    return CohortsList()
}
