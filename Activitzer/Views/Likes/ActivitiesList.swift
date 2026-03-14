import ActivitzerKit
import Combine
import Foundation
import SwiftUI

struct ActivitiesList: View {
  @ObservedObject var viewModel: LikesViewModel

  var body: some View {
    ScrollView {
      VStack {
        ForEach(Array(viewModel.userActivities.enumerated()), id: \.element.id) { idx, activity in
          Text("\(idx + 1). \(activity.activityName)").frame(maxWidth: .infinity, alignment: .leading)
        }
      }.padding(.horizontal, 15)
    }
  }
}
