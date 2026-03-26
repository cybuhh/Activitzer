import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct ActivitiesList: View {
  @Binding var activities: [GarminActivity]
  @Binding var likesProgressInfo: LikesProgressInfo
  @Binding var userProfile: GarminUserProfile?

  func isLiked(at index: Int) -> Bool {
    let activity = activities[index]
    return (
      activity.activityLikeUserIds?.contains(userProfile!.profileId) == true
    ) || index < likesProgressInfo.progress
  }

  var body: some View {
    if activities.isEmpty {
      Text("No activites found.")
    } else {
      ScrollView {
        VStack(spacing: 10) {
          ForEach(activities.indices, id: \.self) { index in
            HStack {
              Image(systemName: isLiked(at: index) ? "hand.thumbsup.fill" : "hand.thumbsup")
              Text("\(index + 1). \(activities[index].activityName)").frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }.padding(.horizontal, 25)
      }
    }
  }
}

#Preview {
  ActivitiesList(
    activities: .constant([
      GarminActivity.preview,
      GarminActivity.preview,
      GarminActivity.previewLiked,
    ]),
    likesProgressInfo: .constant(LikesProgressInfo(
      total: 3,
      progress: 1
    )),
    userProfile: .constant(GarminUserProfile.preview)
  )
}
