import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Label("Welcome", systemImage: "house")
        }
      ActivitiesView()
        .tabItem {
          Label("Activities", systemImage: "figure.mixed.cardio")
        }
      LikesView().tabItem {
        Label("Likes", systemImage: "heart")
      }
      SettingsView().tabItem {
        Label("Settings", systemImage: "gearshape")
      }
    }
  }
}

#Preview {
  ContentView()
}
