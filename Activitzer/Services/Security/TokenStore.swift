import Foundation
import Security

struct OAuthTokens: Codable {
  let accessToken: String
  let refreshToken: String
  let expiresAt: Date
}

final class TokenStore {
  private let service = "com.yourapp.oauth"
  private let account = "oauthTokens"

  func save(_ tokens: OAuthTokens) throws {
    let data = try JSONEncoder().encode(tokens)

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecValueData as String: data,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
    ]

    SecItemDelete(query as CFDictionary)
    let status = SecItemAdd(query as CFDictionary, nil)

    guard status == errSecSuccess else {
      throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
    }
  }

  func load() -> OAuthTokens? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess,
          let data = result as? Data,
          let tokens = try? JSONDecoder().decode(OAuthTokens.self, from: data)
    else { return nil }

    return tokens
  }

  func clear() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]

    SecItemDelete(query as CFDictionary)
  }
}
