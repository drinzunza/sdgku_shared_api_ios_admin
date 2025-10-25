import SwiftUI

struct StudentDetails: View {
    
    @State private var student: Student
    var onStudentUpdated: ((Student) -> Void)?
    
    @State private var isPassKeyVisible = false
    @State private var bouncevalue = 0
    @State private var addVisible = false
    @State private var errorMessage: String?
    
    init(student: Student, onStudentUpdated: ((Student) -> Void)? = nil) {
        _student = State(initialValue: student)
        self.onStudentUpdated = onStudentUpdated
    }
    
    var body: some View {
        ZStack {
            Backgrounds.gradient3
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                // Error message banner
                if let error = errorMessage {
                    HStack {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Button("Dismiss") {
                            errorMessage = nil
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(8)
                }
                
                // Student Info Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Student Information")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    StudentInfoRow(label: "Name", value: student.fullName)
                    StudentInfoRow(label: "Cohort", value: student.cohort)
                    StudentInfoRow(label: "Email", value: student.email)
                    SecureStudentInfoRow(
                        label: "Pass Key",
                        value: student.authKey,
                        isVisible: $isPassKeyVisible
                    )
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 5)
                
                // Allowed Entities Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Allowed Entities")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        Spacer()
                        Button(action: {
                            bouncevalue += 1
                            self.addVisible = true
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                                .font(.title2)
                                .symbolEffect(.bounce, value: bouncevalue)
                        }
                        .sheet(isPresented: $addVisible) {
                            CreateSheet(
                                title: "Add Entity",
                                inputPlaceholder: "Entity Name",
                                okText:"Add",
                                onConfirm: addEntity,
                                onCancel: {
                                    self.addVisible = false
                                }
                            )
                            .presentationDetents([.height(160)])
                            .presentationDragIndicator(.visible)
                        }
                    }
                    
                    if student.allowedEntities.isEmpty {
                        Text("No entities assigned")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        List {
                            ForEach(student.allowedEntities, id: \.self) { entity in
                                Text(entity)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteEntity)
                        }
                        .listStyle(.plain)
                        .cornerRadius(6)
                        
                    }
                }
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(12)
                .shadow(radius: 5)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(student.fullName)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private func addEntity(_ entityName: String) {
        guard let studentId = student.id else {
            errorMessage = "Student ID not found"
            return
        }
        
        Task {
            do {
                var updatedEntities = student.allowedEntities
                updatedEntities.append(entityName)
                
                let updatedStudent = try await StudentService.updateStudentEntities(id: studentId, entities: updatedEntities)
                student = updatedStudent
                onStudentUpdated?(updatedStudent)
                self.addVisible = false
            } catch {
                errorMessage = "Failed to add entity: \(error.localizedDescription)"
                print("Add entity failed: \(error)")
            }
        }
    }
    
    private func deleteEntity(at offsets: IndexSet) {
        guard let studentId = student.id else {
            errorMessage = "Student ID not found"
            return
        }
        
        Task {
            do {
                var updatedEntities = student.allowedEntities
                updatedEntities.remove(atOffsets: offsets)
                
                let updatedStudent = try await StudentService.updateStudentEntities(id: studentId, entities: updatedEntities)
                student = updatedStudent
                onStudentUpdated?(updatedStudent)
            } catch {
                errorMessage = "Failed to delete entity: \(error.localizedDescription)"
                print("Delete entity failed: \(error)")
            }
        }
    }
}


#Preview {
    let student = Student(
        fullName: "Sergio Inzunza",
        cohort: "MDI1 Ch1",
        email: "sergio@example.com",
        passKey: "pass123",
        allowedEntities: ["projects", "grades"]
    )

    StudentDetails(student: student)
}
