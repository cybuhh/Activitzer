import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()

  var body: some View {
    if viewModel.isLoading {
      ProgressView("Loading...")
    } else {
      VStack {
        ConnectionsPicker(
          viewModel: viewModel
        )

        if !viewModel.isPickerVisible {
          SelectedConnection(
            viewModel: viewModel
          )
        }
      }
    }
  }
}

#Preview {
  LikesView()
}
