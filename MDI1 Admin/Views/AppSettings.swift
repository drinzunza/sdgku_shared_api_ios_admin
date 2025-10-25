import SwiftUI

struct AppSettings: View {
    // Persist values in UserDefaults via AppStorage
    @AppStorage("serverURL") private var serverURL: String = ""
    @AppStorage("authKey") private var authKey: String = ""

    // Local UI state
    @State private var tempServerURL: String = "https://sdgku.sergioinzunza.com"
    @State private var tempAdminKey: String = ""
    @State private var showSavedBanner: Bool = false
    @State private var validationMessage: String? = nil

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("Server url", text: $tempServerURL)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.URL)
                    .submitLabel(.done)
                    .onSubmit(validate)
                
                if let validationMessage, !validationMessage.isEmpty {
                    Text(validationMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier("validationMessage")
                }
            }

            Section(header: Text("Admin Key")) {
                SecureField("Admin key", text: $tempAdminKey)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .submitLabel(.done)
            }

            Section {
                Button(action: save) {
                    Label("Save Settings", systemImage: "tray.and.arrow.down")
                }
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("App Settings")
        .onAppear {
            // Load persisted values into editable fields
            if !serverURL.isEmpty {
                tempServerURL = serverURL
            }
            tempAdminKey = authKey
        }
        .overlay(alignment: .top) {
            if showSavedBanner {
                SavedBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
        .animation(.snappy, value: showSavedBanner)
    }

    private var isFormValid: Bool {
        validateURL(tempServerURL) && !tempAdminKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func validate() {
        if !validateURL(tempServerURL) {
            validationMessage = "Please enter a valid URL (including scheme, e.g., https://)."
        } else {
            validationMessage = nil
        }
    }

    private func validateURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString.trimmingCharacters(in: .whitespacesAndNewlines)) else { return false }
        // Require scheme and host
        return url.scheme != nil && url.host != nil
    }

    private func save() {
        // Final validation before saving
        guard isFormValid else {
            validate()
            return
        }
        serverURL = tempServerURL.trimmingCharacters(in: .whitespacesAndNewlines)
        authKey = tempAdminKey.trimmingCharacters(in: .whitespacesAndNewlines)

        // Show a lightweight confirmation
        withAnimation {
            showSavedBanner = true
        }
        // Auto-hide after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation { showSavedBanner = false }
        }
    }
}

private struct SavedBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("Settings saved")
                .font(.callout)
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.thinMaterial, in: Capsule())
        .accessibilityIdentifier("savedBanner")
    }
}

#Preview {
    NavigationStack {
        AppSettings()
    }
}
