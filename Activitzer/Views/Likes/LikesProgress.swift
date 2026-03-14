import ActivitzerKit
import SwiftUI

struct LikesProgress: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    if viewModel.selection != nil && viewModel.userActivities.count > 0 {
      ProgressView(value: Double(viewModel.processedLikes), total: Double(viewModel.userActivities.count)) {
        Text("\(viewModel.processedLikes) / \(viewModel.userActivities.count)")
      } currentValueLabel: {
        Text("\(viewModel.progressLikes)%")
      }.tint(.purple)
        .progressViewStyle(.linear)
        .padding(.horizontal, 10)
      if viewModel.isProcessingLikes == false {
        Button(action: viewModel.triggerLikes) {
          Label("do it", systemImage: "hand.thumbsup")
        }
      }
    }
  }
}
