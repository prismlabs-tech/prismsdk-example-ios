/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ProfileHeightContent: View {
    @Preference(\.userHeight) private var userHeight: Int

    @Binding var showPicker: Bool

    var body: some View {
        HStack {
            Button {
                self.showPicker = true
            } label: {
                HStack {
                    Text(self.userHeight.personHeight)
                    Spacer()
                }
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

            CustomStepper(value: self.$userHeight, range: 36 ... 107)
                .padding(.leading, 10.0)
        }
    }
}

struct ProfileHeightContent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeightContent(showPicker: .constant(false))
    }
}
