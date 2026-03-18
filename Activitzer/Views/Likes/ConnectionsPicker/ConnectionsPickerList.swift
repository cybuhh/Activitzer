import ActivitzerKit
import SwiftUI

struct ConnectionsPickerList: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    VStack(spacing: 0) {
      ForEach(viewModel.userConnections) { user in
        Button {
          viewModel.isPickerVisible.toggle()
          viewModel.selection = user.id
        } label: {
          HStack {
            ConnectionsPickerLabel(user: user).tag(Optional(user.id))
            Spacer()
          }
          .frame(maxWidth: .infinity)
          .frame(height: 55)
          .padding(.horizontal, 16)
          .background(Color(.secondarySystemGroupedBackground))
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        if user.id != viewModel.userConnections.last?.id {
          Divider()
            .padding(.leading, 40)
        }
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .padding(.horizontal, 16)
  }
}
