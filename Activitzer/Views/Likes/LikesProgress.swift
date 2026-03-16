import ActivitzerKit
import SwiftUI

struct LikesProgress: View {
  @Binding var likesProgressInfo: LikesProgressInfo
  @Binding var isProcessingLikes: Bool
  var actionLike: () -> Void
  var actionUnlike: () -> Void

  var body: some View {
    if likesProgressInfo.total > 0 {
      ProgressView(value: Double(likesProgressInfo.progress), total: Double(likesProgressInfo.total)) {
        Text("\(likesProgressInfo.progress) / \(likesProgressInfo.total)")
      } currentValueLabel: {
        Text("\(likesProgressInfo.percentage)%")
      }.tint(.clear)
        .progressViewStyle(.linear)
        .padding(.horizontal, 10)
      HStack {
        Spacer()
        Button(action: actionLike) {
          Label("like", systemImage: "hand.thumbsup")
        }.buttonStyle(.glassProminent)
        Spacer()
        Button(action: actionUnlike) {
          Label("unlike", systemImage: "hand.thumbsdown")
        }.buttonStyle(.glassProminent)
        Spacer()
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
    actionLike: {},
    actionUnlike: {}
  )
}
