/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ProfileAgeContent: View {
    @Preference(\.userAge) private var userAge: Int
    @Binding var showPicker: Bool

    var body: some View {
        HStack {
            Button {
                self.showPicker = true
            } label: {
                HStack {
                    Text("\(self.userAge) Profile.Form.Age.Value", comment: "The age of the user for the profile")

                    Spacer()
                }
                .font(.body)
                .foregroundColor(.prismBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 16.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.prismBase30, lineWidth: 1)
                )
            }

            CustomStepper(value: self.$userAge, range: 18 ... 100)
                .padding(.leading, 10.0)
        }
    }
}

struct ProfileAgeContent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAgeContent(showPicker: .constant(false))
    }
}
