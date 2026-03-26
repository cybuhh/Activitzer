import ActivitzerKit
import SwiftUI

struct Activities: View {
  @ObservedObject var viewModel: LikesViewModel

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
          actionLike: { viewModel.triggerLikeAction(newState: true, profileId: viewModel.userProfile!.profileId) },
          actionUnlike: { viewModel.triggerLikeAction(newState: false, profileId: viewModel.userProfile!.profileId) }
        )
      }
      Spacer()
    }
  }
}

#Preview {
  Activities(
    viewModel: LikesViewModel.preview
  )
}
