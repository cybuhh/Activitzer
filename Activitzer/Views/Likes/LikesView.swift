import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()
  @State private var isConnectionPickerVisible: Bool = false
  @State private var selectedConnection: GarminUserConnection?

  var body: some View {
    ZStack {
      if viewModel.isCredentailsMissing {
        Text("Please set up a Garmin account in the settings.")
      } else {
        ZStack {
          if isConnectionPickerVisible {
            ConnectionsList(
              viewModel: viewModel,
              isVisible: $isConnectionPickerVisible,
              selectedConnection: $selectedConnection
            )
          }

          if !viewModel.isLoading && !isConnectionPickerVisible {
            SelectedConnection(
              viewModel: viewModel,
              isConnectionPickerVisible: $isConnectionPickerVisible,
              selectedConnection: selectedConnection
            )
          }

          if viewModel.isLoading {
            ProgressView("Loading...")
          }
        }
      }
    }.onAppear { viewModel.checkCredentials() }
  }
}

#Preview {
  LikesView()
}
