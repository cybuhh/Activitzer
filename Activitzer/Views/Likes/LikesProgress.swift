import ActivitzerKit
import SwiftUI

struct LikesProgress: View {
  @Binding var likesProgressInfo: LikesProgressInfo
  @Binding var isProcessingLikes: Bool
  var action: () -> Void

  var body: some View {
    if likesProgressInfo.total > 0 {
      ProgressView(value: Double(likesProgressInfo.progress), total: Double(likesProgressInfo.total)) {
        Text("\(likesProgressInfo.progress) / \(likesProgressInfo.total)")
      } currentValueLabel: {
        Text("\(likesProgressInfo.percentage)%")
      }.tint(.purple)
        .progressViewStyle(.linear)
        .padding(.horizontal, 10)
      if isProcessingLikes == false {
        Button(action: action) {
          Label("do it", systemImage: "hand.thumbsup")
        }
      }
    }
  }
}

struct LikesProgressInfo {
  let total: Int
  let progress: Int
  var percentage: Int {
    guard total > 0 else { return 0 }
    return Int(Double(progress) / Double(total) * 100)
  }
}

#Preview {
  LikesProgress(
    likesProgressInfo: .constant(LikesProgressInfo(total: 10, progress: 5)),
    isProcessingLikes: .constant(true),
    action: {}
  )
}
