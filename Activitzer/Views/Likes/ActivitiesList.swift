import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct ActivitiesList: View {
  @Binding var activities: [GarminActivity]
  @Binding var processedLikes: Int

  var body: some View {
    ScrollView {
      VStack {
        ForEach(activities.indices, id: \.self) { index in
          HStack {
            Image(systemName: activities[index].likedByUser == true || index < processedLikes ? "hand.thumbsup.fill" : "hand.thumbsup")
            Text("\(index + 1). \(activities[index].activityName)").frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }.padding(.horizontal, 15)
    }
  }
}

#Preview {
  ActivitiesList(
    activities: .constant([
      GarminActivity.preview,
      GarminActivity.preview,
      GarminActivity.preview
    ]),
    processedLikes: .constant(1)
  )
}
