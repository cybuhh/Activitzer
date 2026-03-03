import SwiftUI

struct SettingsView: View {
  @StateObject private var viewModel = SettingsViewModel()

  var body: some View {
    NavigationView {
      Form {
        Section("Garmin Connect") {
          HStack {
            Image(systemName: "person.crop.circle").foregroundStyle(.tint).imageScale(.large)
            TextField(
              "username",
              text: $viewModel.username
            )
            .autocorrectionDisabled(true)
#if !os(macOS)
              .textInputAutocapitalization(.never)
#endif
          }
          HStack {
            Image(systemName: "key.circle").foregroundStyle(.tint).imageScale(.large)
            SecureField(
              "password",
              text: $viewModel.password
            )
            .autocorrectionDisabled(true)
#if !os(macOS)
              .textInputAutocapitalization(.never)
#endif
          }
        }.listRowSeparator(.hidden)
      }
      .navigationTitle("Credentials")
      .onAppear {
        print("should load creds")
        viewModel.loadCredentails()
        viewModel.setupDebounce()
      }
#if !os(macOS)
      .navigationBarTitleDisplayMode(.inline)
#endif
    }
  }
}

#Preview {
  SettingsView()
}
