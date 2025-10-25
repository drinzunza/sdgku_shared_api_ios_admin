import SwiftUI

struct CreateSheet: View {
    let title: String
    let subTitle: String
    let inputPlaceholder: String
    let multiline: Bool
    let okText: String
    let onConfirm: (String) -> Void
    let onCancel: () -> Void
    
    
    @State var inputText: String = ""
    
    init(
        title: String,
        subTitle: String = "",
        inputPlaceholder: String = "",
        okText: String = "Ok",
        multiline: Bool = false, // ✅ default is optional
        onConfirm: @escaping (String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.title = title
        self.subTitle = subTitle
        self.inputPlaceholder = inputPlaceholder
        self.multiline = multiline
        self.okText = okText
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }
    
    
    var body: some View {
        VStack(spacing: 12) {
            Text(self.title)
                .font(.headline)
            
            Text(self.subTitle)
                .font(.footnote)
            
            if !multiline {
                TextField(self.inputPlaceholder, text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 16)
            } else {
                TextEditor(text: $inputText)
                    .frame(minHeight: 140)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
                    .padding(.horizontal, 16)
            }
            
            HStack(spacing: 16) {
                Button(okText) {
                    onConfirm(self.inputText)
                }
                    .buttonStyle(.borderedProminent)
                
                Button("Cancel", action:onCancel)
                    .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 16)
        .fixedSize(horizontal: false, vertical: true)
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
