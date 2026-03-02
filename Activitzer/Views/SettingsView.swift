import Combine
import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
  private let keychain = KeychainService()
  private let debounceTime = RunLoop.SchedulerTimeType.Stride.milliseconds(500)
  @Published var username: String = ""
  @Published var password: String = ""

  private var cancellables = Set<AnyCancellable>()

  init() {
    $username
      .debounce(for: debounceTime, scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] value in
        self?.performAction(for: value)
      }
      .store(in: &cancellables)
    $password
      .debounce(for: debounceTime, scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] value in
        self?.performAction(for: value)
      }
      .store(in: &cancellables)
    loadCredentails()
  }

  private func loadCredentails() {
    let garminCredentails = try? keychain.loadGarminCredentails()
    if let garminCredentails {
      username = garminCredentails.username
      password = garminCredentails.password
    }
  }

  private func performAction(for text: String) {
    print("Debounced input: \(text)")
    let gamrinCredentials = GarminCredentials(username: username, password: password)
    try? keychain.saveGarminCredentails(gamrinCredentials)
  }
}

struct SettingsView: View {
  @StateObject private var viewModel = SettingsViewModel()

  var body: some View {
    NavigationView {
      Form {
        Section {
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
      }.navigationTitle("Garmin Connect")
#if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
  }
}

#Preview {
  SettingsView()
}
