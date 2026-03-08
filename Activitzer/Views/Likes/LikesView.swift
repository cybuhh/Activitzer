import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()

  var body: some View {
    if viewModel.isActivitiesLoading {
      ProgressView("Loading activities")
    } else {
      VStack(alignment: .leading) {
        List {
          ConnectionsPicker(selection: $viewModel.selection, users: viewModel.userConnections)
          Button("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle", action: viewModel.refreshConnections)
          if $viewModel.selection.wrappedValue != nil && viewModel.userActivities.count > 0 {
            ProgressView(value: Double(viewModel.processedLikes), total: Double(viewModel.userActivities.count)) {
              Text("\(viewModel.processedLikes) / \(viewModel.userActivities.count)")
            } currentValueLabel: {
              Text("\(viewModel.progressLikes)%")
            }.tint(.purple)
              .progressViewStyle(.linear)
              .padding(.horizontal, 10)
            if viewModel.isProcessingLikes == false {
              Button("do it", systemImage: "hand.thumbsup", action: viewModel.triggerLikes)
            }
          }
        }
        .onAppear {
          viewModel.loadConnections()
        }
        .border(.red)
      }
    }
  }
}

#Preview {
  LikesView()
}
