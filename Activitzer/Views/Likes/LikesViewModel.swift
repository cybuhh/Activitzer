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
//    if let firstUser = userConnections.first {
//      selection = firstUser.id
//    } else {
//      selection = nil
//    }
  }

  @MainActor
  func refreshConnections() {
    if userConnections.count != 0 {
      print(userConnections.first!.displayName)
      return
    }
    let keychain = KeychainService()
    let garminCredentails = try? keychain.loadGarminCredentails()
    if garminCredentails == nil {
      return
    }

    let garminTokenStorageKeychain = GarminConnectTokenStorageKeychain(KeychainService.keychainService)

    Task {
      let garminConnectTokenManager = GarminConnectTokenManager(username: garminCredentails!.username, password: garminCredentails!.password, tokenStorage: garminTokenStorageKeychain)
      let garminConnect = GarminConnectClient(getAccessToken: { try await garminConnectTokenManager.getAccessToken() })
      do {
        let connections = try await garminConnect.getUserConnections()
        userConnections = connections.userConnections
        saveUserConnections(userConnections)
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
