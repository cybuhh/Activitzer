import ActivitzerKit
import Combine
import SwiftUI

class LikesViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var selection: Int?
  @Published var userConnections: [GarminUserConnection] = []
  @Published var userActivities: [GarminActivity] = []
  @Published var isProcessingLikes: Bool = false
  @Published var isCredentailsMissing: Bool = false
  @Published var userProfile: GarminUserProfile?
  @Published var likesProgressInfo: LikesProgressInfo = .init(total: 0, progress: 0)

  private var cancellables = Set<AnyCancellable>()

  private var garminService: GarminService?

  private let credentialService: CredentialsService = .init(KeychainService.shared)

  private func getGarminService() -> GarminService {
    if garminService == nil {
      garminService = GarminService()
    }
    return garminService!
  }

  init() {
    $selection
      .dropFirst()
      .sink { [weak self] newValue in
        guard let self else { return }

        isLoading = true

        print("connection selected \(newValue!)")
        if self.userActivities.first?.ownerId != newValue {
          print("triggering loadActivities")
          runMainTask {
            self.userActivities = try await self.loadActivities()
            print("loaded activities activityCount: \(self.userActivities.count)")
            self.isLoading = false
          }
        }
      }
      .store(in: &cancellables)
  }

  func checkCredentials() {
    let credentials = try! credentialService.loadGarminCredentails()
    isCredentailsMissing = credentials.username.isEmpty || credentials.password.isEmpty
  }

  func saveUserConnections(_ userConnections: [GarminUserConnection]) {
    if let data = try? JSONEncoder().encode(userConnections) {
      UserDefaults.standard.set(data, forKey: "userConnections")
    }
    print("stored connections in cache \(userConnections.count)")
  }

  func loadConnections() {
    guard let data = UserDefaults.standard.data(forKey: "userConnections"),
          let connections = try? JSONDecoder().decode([GarminUserConnection].self, from: data)
    else {
      userConnections = []
      return
    }

    userConnections = connections
  }

  func loadUserProfile() {
    runMainTask {
      self.userProfile = try await self.getGarminService().fetchUserProfile()
    }
  }

  func refreshConnections() {
    runMainTask {
      let connections = try await self.getGarminService().fetchUserConnections()
      print("fetched connections from api \(connections.count)")
      self.saveUserConnections(connections)
      self.userConnections = connections
    }
  }

  func loadActivities() async throws -> [GarminActivity] {
    if let selection {
      print("Loading activities for \(selection)")
      let activities = try await getGarminService().getUserActivitiesFromNewsfeed(id: selection)
      likesProgressInfo = LikesProgressInfo(total: activities.count, progress: 0)
      return activities
    } else {
      return []
    }
  }

  func triggerLikes() {
    Task {
      isProcessingLikes = true
      for i in 0 ... userActivities.count - 1 {
        if userActivities[i].likedByUser != true {
//          _ = try a  wait self.getGarminService().likeActivity(id: userActivities[i].id)
          try await Task.sleep(for: .seconds(1))
        }
        likesProgressInfo = LikesProgressInfo(total: userActivities.count, progress: likesProgressInfo.progress + 1)
      }
      isProcessingLikes = false
    }
  }

  static let preview: LikesViewModel = {
    let userConnection = GarminUserConnection.preview

    let vm = LikesViewModel()
    vm.userConnections = [userConnection]
    vm.userActivities = [GarminActivity.preview]
    vm.userProfile = GarminUserProfile.preview
    vm.selection = userConnection.id
    return vm
  }()
}
