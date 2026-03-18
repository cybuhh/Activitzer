import SwiftUI

struct ConnectionPickerButton: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    VStack {
      Button(action: { viewModel.isPickerVisible.toggle() }) {
        Text(viewModel.selectedConnection == nil ? "Select connection" : "Select different connection")
      }.padding(.bottom, 10)
        .buttonStyle(.borderedProminent)
      if viewModel.selectedConnection != nil {
        ConnectionsPickerLabel(user: viewModel.selectedConnection!).padding(.bottom, 10)
      }
    }
  }
}
