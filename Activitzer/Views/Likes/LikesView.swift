import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct LikesView: View {
  @StateObject private var viewModel = LikesViewModel()
  @State private var progress: Double = 0.0
  let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack(alignment: .leading) {
      List {
        ConnectionsPicker(selection: $viewModel.selection, users: viewModel.userConnections)
        Button("Refresh list", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle", action: viewModel.refreshConnections)
        if $viewModel.selection.wrappedValue != nil {
          ProgressView(value: progress, total: 100) {
            Text("Linear Progress...")
          } currentValueLabel: {
            Text("\(Int(progress))%")
          }.tint(.purple)
            .progressViewStyle(.linear)
            .onReceive(timer) { _ in
              if progress < 100 {
                progress += 1
              } else {
                progress = 0
              }
            }.padding(.horizontal, 10)
        }
      }
      .onAppear {
        viewModel.loadConnections()
      }
      .border(.red)
    }
  }
}

#Preview {
  LikesView()
}
