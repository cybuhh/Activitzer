import KeychainAccess

public struct CredentialsService {
  private let keychain: Keychain

  init(_ keychain: Keychain) {
    self.keychain = keychain
  }

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
