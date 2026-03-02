import ActivitzerKit
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()

  var body: some View {
    List {
      ConnectionsPicker(selection: $viewModel.selection, users: viewModel.userConnections)
      Button("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle", action: viewModel.refreshConnections)
    }
    .onAppear {
      viewModel.loadConnections()
    }
  }
}

#Preview {
  LikesView()
}
