import ActivitzerKit
import SwiftUI

struct SelectedConnection: View {
  @ObservedObject var viewModel: LikesViewModel
  @Binding var isConnectionPickerVisible: Bool

  var body: some View {
    VStack(spacing: 15) {
      if viewModel.selection != nil {
        ActivitiesList(
          activities: $viewModel.userActivities,
          likesProgressInfo: $viewModel.likesProgressInfo,
          userProfile: $viewModel.userProfile
        )
        LikesProgress(
          likesProgressInfo: $viewModel.likesProgressInfo,
          isProcessingLikes: $viewModel.isProcessingLikes,
          actionLike: { viewModel.triggerLikeAction(newState: true) },
          actionUnlike: { viewModel.triggerLikeAction(newState: false) }
        )
      }
      Spacer()
    }
  }
}

#Preview {
  SelectedConnection(
    viewModel: LikesViewModel.preview,
    isConnectionPickerVisible: .constant(false)
  )
}
