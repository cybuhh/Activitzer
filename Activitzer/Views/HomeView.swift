import SwiftUI

struct HomeView: View {
  var body: some View {
    Form {
      Section {
        VStack {
          Image(systemName: "heart")
            .imageScale(.large)
            .foregroundStyle(.tint)
          Image(systemName: "globe")
            .imageScale(.large)
            .foregroundStyle(.tint)
          Text("Hello, world!")
        }
        .padding()
      }
      Section {
        Text("Navigate with bottom bar")
      }
    }
  }
}

#Preview {
  HomeView()
}
