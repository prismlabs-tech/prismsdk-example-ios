/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct Checkbox: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    @Binding var value: Bool
    var title: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top) {
            Button {
                self.value.toggle()
            } label: {
                if self.value {
                    Image.checkboxChecked
                        .foregroundColor(self.isEnabled ? .prismBlack : .prismBase50)
                } else {
                    Image.checboxUnchecked
                        .foregroundColor(self.isEnabled ? .prismBlack : .prismBase50)
                }
            }
            .disabled(!self.isEnabled)

            Text(self.title)
                .font(.body)
                .foregroundColor(self.isEnabled ? .prismBlack : .prismBase50)
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkbox(value: .constant(true), title: "Testing Checked")
            Checkbox(value: .constant(false), title: "Testing Unchecked")
            Checkbox(value: .constant(false), title: "Testing Disabled")
                .disabled(true)
        }
    }
}
