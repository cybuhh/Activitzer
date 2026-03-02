import KeychainAccess

struct KeychainService {
  static let keychainService = "com.cybidev.activitzer"
  private let keychain = Keychain(service: keychainService)

  func saveGarminCredentails(_ garminCredentials: GarminCredentials) throws {
    try keychain.set(garminCredentials.username, key: "garminUsername")
    try keychain.set(garminCredentials.password, key: "garminPassword")
  }

  func loadGarminCredentails() throws -> GarminCredentials {
    let username = try keychain.get("garminUsername") ?? ""
    let password = try keychain.get("garminPassword") ?? ""

    return GarminCredentials(username: username, password: password)
  }
}
