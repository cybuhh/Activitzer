import ActivitzerKit
import SwiftUI

struct ConnectionsPicker: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 0) {
        HStack(alignment: .center) {
          Image(systemName: "person.circle")
            .foregroundColor(.accentColor)
            .font(.system(size: 32))
          Text("Select connection")
            .foregroundColor(.accentColor)
          Spacer()
          Button("", systemImage: "xmark") {
            viewModel.isPickerVisible.toggle()
          }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        List {
          ForEach(viewModel.userConnections) { user in
            Button {
              viewModel.isPickerVisible.toggle()
              viewModel.selection = user.id
            } label: {
              ConnectionsPickerLabel(user: user).tag(Optional(user.id))
            }
          }
        }
        .scrollDisabled(true)
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
          print("picket onChange tiggered")
          viewModel.selectedConnection = viewModel.userConnections.first(where: { $0.id == viewModel.selection
          })!
        }
    }
  }
}

#Preview {
  ConnectionsPicker(
    viewModel: LikesViewModel.preview
  )
}
