import ActivitzerKit
import SwiftUI

struct ContentView: View {
  @State var isCredentailsMissing: Bool = false
  private let credentialService: CredentialsService = .init(KeychainService.shared)
  @State private var selectedTab = 0

  func checkCredentials() {
    let credentials = try! credentialService.loadGarminCredentails()
    isCredentailsMissing = credentials.username.isEmpty || credentials.password.isEmpty
  }

  func onChange(oldValue: Int, newValue: Int) {
    if isCredentailsMissing, newValue != 3 {
      selectedTab = 3
    } else {
      selectedTab = newValue
    }
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      HomeView()
        .tabItem {
          Label("Welcome", systemImage: "house")
        }
        .tag(0)
      ActivitiesView()
        .tabItem {
          Label("Activities", systemImage: "figure.mixed.cardio")
        }
        .tag(1)
      LikesView()
        .tabItem {
          Label("Likes", systemImage: "heart")
        }
        .tag(2)
      SettingsView()
        .tabItem {
          Label("Settings", systemImage: "gearshape")
        }
        .tag(3)
    }.onAppear { checkCredentials() }
      .onChange(of: selectedTab, initial: false) { oldValue, newValue in
        onChange(oldValue: oldValue, newValue: newValue)
      }
  }
}

#Preview {
  ContentView()
}
