import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()

  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        List {
          ConnectionsPicker(selection: $viewModel.selection, users: viewModel.userConnections)
          Button("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle", action: viewModel.refreshConnections)
          LikesProgress(
            selection: $viewModel.selection.wrappedValue,
            activitiesCount: viewModel.userActivities.count,
            progressLikes: viewModel.progressLikes,
            processedLikes: viewModel.processedLikes,
            isProcessingLikes: viewModel.isProcessingLikes,
            onTriggerLikes: viewModel.triggerLikes
          )
        }
        .onAppear {
          viewModel.loadConnections()
        }
        .border(.red)
      }
      if viewModel.isActivitiesLoading {
        ProgressView("Loading activities")
      }
    }
  }
}

struct LikesProgress: View {
  let selection: Int?
  let activitiesCount: Int
  let progressLikes: Int
  let processedLikes: Int
  let isProcessingLikes: Bool
  let onTriggerLikes: () -> Void

  var body: some View {
    if selection != nil && activitiesCount > 0 {
      ProgressView(value: Double(processedLikes), total: Double(activitiesCount)) {
        Text("\(processedLikes) / \(activitiesCount)")
      } currentValueLabel: {
        Text("\(progressLikes)%")
      }.tint(.purple)
        .progressViewStyle(.linear)
        .padding(.horizontal, 10)
      if isProcessingLikes == false {
        Button("do it", systemImage: "hand.thumbsup", action: onTriggerLikes)
      }
    }
  }
}

#Preview {
  LikesView()
}
