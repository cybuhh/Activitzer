import ActivitzerKit
import SwiftUI

struct ConnectionsPicker: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 15) {
        ConnectionsPickerHeader(isPickerVisible: $viewModel.isPickerVisible)
        ConnectionsPickerList(viewModel: viewModel)
        Button("Refresh list",
               systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle")
        {
          runMainTask {
            try? await viewModel.refreshConnections()
          }
        }
        .buttonStyle(.borderedProminent)
        .padding(.bottom, 20)
      }.background(Color(.systemGroupedBackground))
        .onAppear {
          viewModel.loadUserProfile()
          viewModel.loadConnections()
        }
        .onChange(of: viewModel.selection) {
          print("picket onChange tiggered")
          viewModel.selectedConnection = viewModel.userConnections.first(where: { $0.id == viewModel.selection
          })!
        }
    }.refreshable {
      try? await viewModel.refreshConnections()
    }
  }
}

#Preview {
  ConnectionsPicker(
    viewModel: LikesViewModel.preview
  )
}
