import ActivitzerKit
import Combine
import SwiftUI

class LikesViewModel: ObservableObject {
  @Published var selection: Int?
  @Published var userConnections: [GarminUserConnection] = []

  func saveUserConnections(_ userConnections: [GarminUserConnection]) {
    if let data = try? JSONEncoder().encode(userConnections) {
      UserDefaults.standard.set(data, forKey: "userConnections")
    }
  }

  func loadUserConnections() -> [GarminUserConnection] {
    guard let data = UserDefaults.standard.data(forKey: "userConnections"),
          let userConnections = try? JSONDecoder().decode([GarminUserConnection].self, from: data)
    else {
      return []
    }
    return userConnections
  }

  func loadConnections() {
    userConnections = loadUserConnections()
  }

  @MainActor
  func refreshConnections() {
    if userConnections.count != 0 {
      print(userConnections.first!.displayName)
      return
    }

    Task {
      do {
        let garminService = try GarminService()
        let connections = try await garminService.fetchUserConnections()
        userConnections = connections
      } catch RequestError.tooManyRequests {
        print("Too many requests")
      } catch GarminConnectTokenManager.GetValidTokenError.login {
        print("Can't login and generate new token")
      } catch GarminConnectTokenManager.GetValidTokenError.noValidAccessToken {
        print("No valid access token found")
      } catch {
        print("Error:", error)
      }
    }
    loadConnections()
  }
}
