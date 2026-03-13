import ActivitzerKit
import Combine
import SwiftUI

class LikesViewModel: ObservableObject {
  @Published var isActivitiesLoading: Bool = false
  @Published var selection: Int?
  @Published var userConnections: [GarminUserConnection] = []
  @Published var userActivities: [GarminActivity] = []
  @Published var isProcessingLikes: Bool = false
  @Published var processedLikes: Int = 0
  @Published var progressLikes: Int = 0
  private var cancellables = Set<AnyCancellable>()

  init() {
    $selection
      .dropFirst()
      .sink { [weak self] _ in
        guard let self else { return }

        isActivitiesLoading = true
        runMainTask {
          let activities = try await self.loadActivities()
          self.userActivities = activities
        }
        isActivitiesLoading = false
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
    runMainTask {
      let garminService = try GarminService()
      let connections = try await garminService.fetchUserConnections()

      self.userConnections = connections
      print(connections)
    }
    loadConnections()
  }

  func loadActivities() async throws -> [GarminActivity] {
    let garminService = try GarminService()
    let activities = try await garminService.fetchNewsfeedActivies()
    if let selection {
      return activities.filter { $0.ownerId != selection }
    } else {
      return activities
    }
  }

  func triggerLikes() {
    Task {
      isProcessingLikes = true
      for i in 0 ... userActivities.count {
        try await Task.sleep(for: .seconds(1))
        processedLikes = i
        progressLikes = Int(Double(i) / Double(userConnections.count) * 100)
      }
      isProcessingLikes = false
    }
  }

  static let preview: LikesViewModel = {
    let userConnection = GarminUserConnection.preview

    let vm = LikesViewModel()
    vm.userConnections = [userConnection]
    vm.selection = userConnection.id
    return vm
  }()
}
