import SwiftUI

struct StudentInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct SecureStudentInfoRow: View {
    let label: String
    let value: String
    @Binding var isVisible: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(isVisible ? value : String(repeating: "•", count: value.count))
                .font(.subheadline)
                .foregroundColor(.primary)
                .fontDesign(.monospaced)
            
            Spacer()
            
            Button(action: {
                isVisible.toggle()
            }) {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
