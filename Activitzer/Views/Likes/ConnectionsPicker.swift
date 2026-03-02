import ActivitzerKit
import SwiftUI

struct ConnectionsPicker: View {
  var selection: Binding<Int?>
  var users: [GarminUserConnection] = []

  var body: some View {
    Picker(selection: selection) {
      ForEach(users) { user in
        ConnectionsPickerLabel(user: user).tag(Optional(user.id))
      }
    } label: {
      if selection.wrappedValue == nil || !users.contains(where: { $0.id == selection.wrappedValue }) {
        Text("Select connection")
      }
//      if let selectedUser = users.first(where: { $0.id == selection.wrappedValue }) {
//        ConnectionsPickerLabel(user: selectedUser)
//      } else {
//        Text("Select connection")
//      }
    }
    .pickerStyle(.automatic)
  }
}
