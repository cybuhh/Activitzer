import ActivitzerKit
import Combine
import SwiftUI

class LikesViewModel: ObservableObject {
  @Published var selection: Int?
  @Published var userConnections: [GarminUserConnection] = []
  @Published var userActivities: [GarminActivity] = []
  private var cancellables = Set<AnyCancellable>()

  init() {
    $selection
      .dropFirst()
      .sink { [weak self] _ in
        guard let self else { return }

        runMainTask {
          let activities = try await self.loadActivities()
          self.userActivities = activities
        }
      }
      .store(in: &cancellables)
  }

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

  func refreshConnections() {
    if userConnections.count != 0 {
      print(userConnections.first!.displayName)
      return
    }

    runMainTask {
      let garminService = try GarminService()
      let connections = try await garminService.fetchUserConnections()

      self.userConnections = connections
    }
    loadConnections()
  }

  func loadActivities() async throws -> [GarminActivity] {
    let garminService = try GarminService()
    let activities = try await garminService.fetchNewsfeedActivies()

    if let selection {
      return activities.filter { $0.ownerId != selection }
    }

    return activities
  }
}
