import SwiftUI

struct CreateSheet: View {
    let title: String
    let subTitle: String
    let inputPlaceholder: String
    let multiline: Bool
    let okText: String
    let errorMessage: String?
    let isLoading: Bool
    let loadingMessage: String
    let onConfirm: (String) -> Void
    let onCancel: () -> Void
    
    @State var inputText: String = ""    
    
    init(
        title: String,
        subTitle: String = "",
        inputPlaceholder: String = "",
        okText: String = "Ok",
        multiline: Bool = false, // ✅ default is optional
        isLoading: Bool = false, // loading message is shown when set to true
        loadingMessage: String = "Loading...",
        errorMessage: String? = nil, // error is shown when not nil
        onConfirm: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.subTitle = subTitle
        self.inputPlaceholder = inputPlaceholder
        self.multiline = multiline
        self.okText = okText
        self.isLoading = isLoading
        self.loadingMessage = loadingMessage
        self.errorMessage = errorMessage
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(self.subTitle)) {
                                        
                    if !multiline {
                        TextField(self.inputPlaceholder, text: $inputText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 0)
                    } else {
                        TextEditor(text: $inputText)
                            .frame(minHeight: 180)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3))
                            )
                            .padding(.horizontal, 0)
                    }
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle(self.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                    .buttonStyle(.bordered)
                    .frame(width: 100)
                    .disabled(isLoading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(self.okText) {
                            onConfirm(self.inputText)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(minWidth: 100)
                    .disabled(self.inputText.isEmpty || isLoading)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView("Saving data...")
                        .padding()
                        .background(Color(.lightGray))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        }
    }
}
    
#Preview("Single line") {
    CreateSheet(
        title: "Cohort Name",
        inputPlaceholder: "input data",
        onConfirm: { x in
            print(x)
        },
        onCancel: {}
    )
}


#Preview("Multi line") {
    CreateSheet(
        title: "Import students",
        inputPlaceholder: "input data",
        okText:"Import students",
        multiline: true,
        onConfirm: { x in
            print(x)
        },
        onCancel: {}
    )
}
