import ActivitzerKit
import SwiftUI

struct ConnectionsPicker: View {
  @ObservedObject var viewModel: LikesViewModel
  @Binding var isVisible: Bool

  var body: some View {
    if isVisible {
      ScrollView {
        VStack(alignment: .center) {
          List {
            ForEach(viewModel.userConnections) { user in
              Button {
                viewModel.selection = user.id
              } label: {
                ConnectionsPickerLabel(user: user).tag(Optional(user.id))
              }
            }
          }.scrollDisabled(true)
            .frame(height: CGFloat(viewModel.userConnections.count * 55))
          Button("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle", action: viewModel.refreshConnections)
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 20)
        }.background(Color(.systemGroupedBackground))
          .onAppear {
            viewModel.loadUserProfile()
            viewModel.loadConnections()
          }
          .onChange(of: viewModel.selection) {
            isVisible.toggle()
            viewModel.selectedConnection = viewModel.userConnections.first(where: { $0.id == viewModel.selection
            })!
          }
      }
    } else {
      VStack {
        Button(action: { isVisible.toggle() }) {
          Text(viewModel.selectedConnection == nil ? "Select connection" : "Select different connection")
        }.padding(.bottom, 10)
          .buttonStyle(.borderedProminent)
        if viewModel.selectedConnection != nil {
          ConnectionsPickerLabel(user: viewModel.selectedConnection!).padding(.bottom, 10)
        }
      }
    }
  }
}

#Preview {
  ConnectionsPicker(
    viewModel: LikesViewModel.preview,
    isVisible: .constant(false)
  )
}
