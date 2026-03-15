import ActivitzerKit
import SwiftUI

struct SelectedConnection: View {
  @ObservedObject var viewModel: LikesViewModel
  @Binding var isConnectionPickerVisible: Bool
  var selectedConnection: GarminUserConnection?

  var body: some View {
    VStack {
      if selectedConnection != nil {
        HStack {
          Text("Selected connection:")
          ConnectionsPickerLabel(user: self.selectedConnection!)
        }
      }
      Button(action: { isConnectionPickerVisible.toggle() }) {
        Text("Select connection")
      }
      .buttonStyle(.borderedProminent)
      if viewModel.selection != nil {
        ActivitiesList(
          activities: $viewModel.userActivities,
          likesProgressInfo: $viewModel.likesProgressInfo,
          userProfile: $viewModel.userProfile
        )
        LikesProgress(
          likesProgressInfo: $viewModel.likesProgressInfo,
          isProcessingLikes: $viewModel.isProcessingLikes,
          action: { viewModel.triggerLikes() }
        )
      }
      Spacer()
    }
  }
}

#Preview {
  SelectedConnection(
    viewModel: LikesViewModel.preview,
    isConnectionPickerVisible: .constant(false),
    selectedConnection: GarminUserConnection.preview
  )
}
