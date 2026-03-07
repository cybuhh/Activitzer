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
      .onChange(of: viewModel.selection, initial: false) {
        Task {
          do {
            print("create GarminService")
            let garminService = try GarminService()
            print("call fetchNewsfeed")
            let activities = try await garminService.fetchNewsfeedActivies()
            print("activities: \(activities)")
          } catch {
            print("Error occured: \(error)")
          }
        }
      }
      .border(.red)
    }
  }
}

#Preview {
  LikesView()
}
