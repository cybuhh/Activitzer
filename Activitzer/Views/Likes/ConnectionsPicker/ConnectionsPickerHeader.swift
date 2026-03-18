//
//  ConnectionsPickerHeader.swift
//  Activitzer
//
//  Created by cybuhh on 18/03/2026.
//

import SwiftUI

struct ConnectionsPickerHeader: View {
  @Binding var isPickerVisible: Bool

  var body: some View {
    HStack(alignment: .center) {
      Image(systemName: "person.circle")
        .foregroundColor(.accentColor)
        .font(.system(size: 32))
      Text("Select connection")
        .foregroundColor(.accentColor)
      Spacer()
      Button("", systemImage: "xmark") {
        isPickerVisible.toggle()
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
  }
}

#Preview {
  ConnectionsPickerHeader(
    isPickerVisible: .constant(false)
  )
}
