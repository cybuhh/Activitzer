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
        ConnectionPickerButton(
          viewModel: viewModel
        )

        if !viewModel.isPickerVisible {
          Activities(
            viewModel: viewModel
          )
        }
      }.sheet(isPresented: $viewModel.isPickerVisible) {
        ConnectionsPicker(
          viewModel: viewModel
        )
      }
    }
  }
}

#Preview {
  LikesView()
}
