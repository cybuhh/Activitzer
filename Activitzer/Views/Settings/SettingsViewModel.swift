import Combine
import Foundation

class SettingsViewModel: ObservableObject {
  lazy var credentialsService: CredentialsService = .init(KeychainService.shared)

  @Published var username: String = ""
  @Published var password: String = ""

  func loadCredentails() {
    let garminCredentails = try? credentialsService.loadGarminCredentails()
    if let garminCredentails {
      username = garminCredentails.username
      password = garminCredentails.password
    }
  }

  func saveCredentials() {
    let gamrinCredentials = GarminCredentials(username: username, password: password)
    try? credentialsService.saveGarminCredentails(gamrinCredentials)
  }
}
