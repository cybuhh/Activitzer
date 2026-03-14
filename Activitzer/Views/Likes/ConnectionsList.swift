import ActivitzerKit
import SwiftUI

struct ConnectionsList: View {
  @ObservedObject var viewModel: LikesViewModel
  @Binding var isVisible: Bool
  @Binding var selectedConnection: GarminUserConnection?

  var body: some View {
    VStack(alignment: .leading) {
      List {
        ConnectionsPicker(selection: $viewModel.selection, users: viewModel.userConnections)
        Button(action: viewModel.refreshConnections) {
          Label("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle")
        }
      }
      .onAppear {
        viewModel.loadConnections()
      }
      .onChange(of: viewModel.selection) {
        isVisible.toggle()
        self.selectedConnection = viewModel.userConnections.first(where: { $0.id == viewModel.selection
        })!
      }
    }
  }
}
