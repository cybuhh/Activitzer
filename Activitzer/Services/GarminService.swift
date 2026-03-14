import ActivitzerKit
import Foundation

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

  public func fetchNewsfeedActivies(start: Int = 0, limit: Int = 10) async throws -> [ActivitzerKit.GarminActivity] {
    try await garminConnect.getNewsfeed(start: start, limit: limit).activityList
  }

  public func fetchUserConnections() async throws -> [ActivitzerKit.GarminUserConnection] {
    let userConnections = try await garminConnect.getUserConnections()
    return userConnections.userConnections
  }

  public func getUserActivitiesFromNewsfeed(id: Int) async throws -> [ActivitzerKit.GarminActivity] {
    let calendar = Calendar.current
    let now = Date()
    let limit = 200
    var start = 0
    var shouldContinue = true

    var userActivities: [GarminActivity] = []
    repeat {
      let activities = try await fetchNewsfeedActivies(start: start, limit: limit)
      let filteredActivities = activities.filter { $0.ownerId == id }
      userActivities.append(contentsOf: filteredActivities)
      start += limit

      if let last = activities.last {
        if start > 0 {
          try await Task.sleep(for: .seconds(2))
        }
        shouldContinue = calendar.isDate(last.createDate, equalTo: now, toGranularity: .month)
      } else {
        shouldContinue = false
      }
    } while shouldContinue

    return userActivities
  }
}
