import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()
  @State private var isConnectionPickerVisible: Bool = false
  @State private var selectedConnection: GarminUserConnection?

  func toggleConnectionSelector() {
    isConnectionPickerVisible.toggle()
  }

  var body: some View {
    ZStack {
      if isConnectionPickerVisible {
        ConnectionsList(
          viewModel: viewModel,
          isVisible: $isConnectionPickerVisible,
          selectedConnection: $selectedConnection
        )
      }

      if !viewModel.isLoading && !isConnectionPickerVisible {
        VStack {
          if selectedConnection != nil {
            HStack {
              Text("Selected connection:")
              ConnectionsPickerLabel(user: self.selectedConnection!)
            }
          }
          Button(action: toggleConnectionSelector) {
            Text("Select connection")
          }
          .buttonStyle(.borderedProminent)
          if viewModel.selection != nil {
            if viewModel.userActivities.isEmpty {
              Text("No activites found.")
            } else {
              ActivitiesList(
                activities: $viewModel.userActivities,
                processedLikes: $viewModel.processedLikes
              )
              LikesProgress(
                viewModel: viewModel
              )
            }
          }
          Spacer()
        }
      }

      if viewModel.isLoading {
        ProgressView("Loading...")
      }
    }
  }
}

#Preview {
  LikesView()
}
