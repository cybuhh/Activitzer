import Combine
import Foundation

class SettingsViewModel: ObservableObject {
  lazy var credentialsService: CredentialsService = .init(KeychainService.shared)

  private let debounceTime = RunLoop.SchedulerTimeType.Stride.milliseconds(1000)
  @Published var username: String = ""
  @Published var password: String = ""

  private var cancellables = Set<AnyCancellable>()

  func setupDebounce() {
    $username
      .dropFirst()
      .removeDuplicates()
      .debounce(for: debounceTime, scheduler: RunLoop.main)
      .sink { [weak self] value in
        self?.saveCredentials(for: value)
      }
      .store(in: &cancellables)
    $password
      .dropFirst()
      .removeDuplicates()
      .debounce(for: debounceTime, scheduler: RunLoop.main)
      .sink { [weak self] value in
        self?.saveCredentials(for: value)
      }
      .store(in: &cancellables)
  }

  func loadCredentails() {
    let garminCredentails = try? credentialsService.loadGarminCredentails()
    if let garminCredentails {
      username = garminCredentails.username
      password = garminCredentails.password
    }
  }

  private func saveCredentials(for text: String) {
    print("Debounced input: \(text)")
    let gamrinCredentials = GarminCredentials(username: username, password: password)
    try? credentialsService.saveGarminCredentails(gamrinCredentials)
  }
}
