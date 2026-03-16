import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()
  @State private var isConnectionPickerVisible: Bool = false

  var body: some View {
    ZStack {
      if viewModel.isCredentailsMissing {
        Text("Please set up a Garmin account in the settings.")
      } else {
        if viewModel.isLoading {
          ProgressView("Loading...")
        } else {
          VStack {
            ConnectionsPicker(
              viewModel: viewModel,
              isVisible: $isConnectionPickerVisible
            )

            if !viewModel.isLoading && !isConnectionPickerVisible {
              SelectedConnection(
                viewModel: viewModel,
                isConnectionPickerVisible: $isConnectionPickerVisible
              )
            }
          }
        }
      }
    }.onAppear { viewModel.checkCredentials() }
  }
}

#Preview {
  LikesView()
}
