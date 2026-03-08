import ActivitzerKit

public enum APIError: Error {
  case invalidURL
  case tooManyRequests
  case noValidAccessToken
  case unableToComplete
  case cantLogin
//  case invalidResponse
//  case invalidData
}

public struct GarminService {
  private let credentialsService = CredentialsService(KeychainService.shared)
  private let garminTokenStorageKeychain = GarminConnectTokenStorageKeychain(KeychainService.shared)
  private let garminConnect: GarminConnectClient

  public init() throws {
    enum InitError: Error { case missingCredentials }
    let garminCredentails = try? credentialsService.loadGarminCredentails()
    guard let garminCredentails else {
      throw InitError.missingCredentials
    }

    let garminConnectTokenManager = GarminConnectTokenManager(username: garminCredentails.username, password: garminCredentails.password, tokenStorage: garminTokenStorageKeychain)

    garminConnect = GarminConnectClient(getAccessToken: { try await garminConnectTokenManager.getAccessToken() })
  }

  public func fetchNewsfeedActivies() async throws -> [ActivitzerKit.GarminActivity] {
    try await garminConnect.getNewsfeed().activityList
  }

  public func fetchUserConnections() async throws -> [ActivitzerKit.GarminUserConnection] {
    let userConnections = try await garminConnect.getUserConnections()
    return userConnections.userConnections
  }
}
