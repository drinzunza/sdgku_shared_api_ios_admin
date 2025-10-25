import SwiftUI

struct StudentsList: View {
    let cohort: Cohort
    
    @State private var students: [Student] = []
    @State private var addVisible: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Backgrounds.gradient1
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView("Loading students...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Text("Error loading students")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await fetchStudents()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List(students) { student in
                        NavigationLink {
                            StudentDetails(student: student, onStudentUpdated: handleStudentUpdate)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(student.fullName)
                                    .font(.headline)
                                Text(student.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .cornerRadius(7)
                    .listStyle(.plain)
                    .padding(10)
                    .refreshable {
                        await fetchStudents()
                    }
                }
            }
            .navigationTitle("\(cohort.name) students")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        self.addVisible = true
                    }) {
                        Label("Add Students", systemImage: "plus")
                    }
                    .sheet(isPresented: $addVisible) {
                        CreateSheet(
                            title: "Import students",
                            subTitle: "Format: Name,Email,PassKey (one per line)",
                            okText:"Import students",
                            multiline: true,
                            onConfirm: importStudents,
                            onCancel: {
                                self.addVisible = false
                            }
                        )
                        .presentationDetents([.height(320)])
                        .presentationDragIndicator(.visible)
                    }
                }
            }
            .task {
                await fetchStudents()
            }
        }
    }
    
    private func fetchStudents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            students = try await StudentService.getStudentsByCohort(cohort: cohort.name)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func handleStudentUpdate(_ updatedStudent: Student) {
        // Update the student in the local array
        if let index = students.firstIndex(where: { $0.id == updatedStudent.id }) {
            students[index] = updatedStudent
        }
    }
    
    private func importStudents(_ text: String) {
        let lines = text
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        Task {
            do {
                for line in lines {
                    let components = line.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    
                    guard components.count >= 3 else {
                        print("Invalid line format: \(line)")
                        continue
                    }
                    
                    let fullName = String(components[0])
                    let email = String(components[1])
                    let passKey = String(components[2])
                    let student = Student(fullName: fullName, cohort: self.cohort.name, email: email, passKey: passKey)
                    
                    // Create student via API
                    let _ = try await StudentService.createStudent(student: student)
                }
                
                // Refresh the list after import
                await fetchStudents()
                self.addVisible = false
            } catch {
                print("Import failed: \(error)")
                errorMessage = "Failed to import students: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    let cohort = Cohort(name: "FSDO Ch57")
    return StudentsList(cohort: cohort)
}
