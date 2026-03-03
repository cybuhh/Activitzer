import KeychainAccess

enum KeychainService {
  static let keychainService = "com.cybidev.activitzer"
  static let shared = Keychain(service: keychainService)
}
