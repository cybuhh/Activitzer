import ActivitzerKit
import Combine
import SwiftUI

class LikesViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var selection: Int?
  @Published var userConnections: [GarminUserConnection] = []
  @Published var userActivities: [GarminActivity] = []
  @Published var newsfeedActivities: [GarminActivity] = []
  @Published var isProcessingLikes: Bool = false
  @Published var processedLikes: Int = 0
  @Published var progressLikes: Int = 0
  private var cancellables = Set<AnyCancellable>()

  init() {
    $selection
      .dropFirst()
      .sink { [weak self] _ in
        guard let self else { return }

        isLoading = true

        runMainTask {
          self.userActivities = try await self.loadActivities()
          print("Loaded activities activityCount: \(self.userActivities.count)")
          self.isLoading = false
        }
      }
      .store(in: &cancellables)
  }

  func saveUserConnections(_ userConnections: [GarminUserConnection]) {
    if let data = try? JSONEncoder().encode(userConnections) {
      UserDefaults.standard.set(data, forKey: "userConnections")
    }
    print("stored connections in cache \(userConnections.count)")
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
    print("loaded connections from cache \(userConnections.count)")
  }

  func refreshConnections() {
    runMainTask {
      let garminService = try GarminService()
      let connections = try await garminService.fetchUserConnections()
      print("fetched connections from api \(connections.count)")
      self.saveUserConnections(connections)
      self.userConnections = connections
    }
  }

  func loadActivities() async throws -> [GarminActivity] {
    if newsfeedActivities.count == 0 {
      let garminService = try GarminService()
      newsfeedActivities = try await garminService.fetchNewsfeedActivies()
    }

    if let selection {
      let activities = newsfeedActivities.filter { $0.ownerId == selection }
      print("Loading activities for \(selection), count \(activities.count) from \(newsfeedActivities.count) total")
      return activities
    } else {
      return []
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
