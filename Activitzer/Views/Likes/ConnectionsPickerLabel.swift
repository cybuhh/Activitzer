import ActivitzerKit
import Kingfisher
import SwiftUI

struct ConnectionsPickerLabel: View {
  let user: GarminUserConnection

  var body: some View {
    HStack(spacing: 6) {
      if let url = user.profileImageUrlSmall {
        KFImage(url)
          .resizable()
          .scaledToFill()
          .frame(width: 16, height: 16)
          .clipShape(Circle())
      } else {
        Image(systemName: "person.crop.circle")
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)
          .clipShape(Circle())
      }

      Text(user.fullName)
    }
  }
}
