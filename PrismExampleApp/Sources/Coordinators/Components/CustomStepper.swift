/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct CustomStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var step: Int = 1

    var body: some View {
        HStack {
            Button {
                self.value -= self.step
                HapticFeedback.light()
            } label: {
                Image.minus
                    .frame(width: 50, height: 50)
                    .foregroundColor(self.value == self.range.lowerBound ? .prismBase5 : .prismBlack)
                    .overlay(
                        Circle()
                            .stroke(Color.prismBase10, lineWidth: 1)
                    )
            }
            .disabled(self.value == self.range.lowerBound)

            Button {
                self.value += self.step
                HapticFeedback.light()
            } label: {
                Image.plus
                    .frame(width: 50, height: 50)
                    .foregroundColor(self.value == self.range.upperBound ? .prismBase5 : .prismBlack)
                    .overlay(
                        Circle()
                            .stroke(Color.prismBase10, lineWidth: 1)
                    )
            }
            .disabled(self.value == self.range.upperBound)
        }
    }
}

struct CustomStepper_Previews: PreviewProvider {
    static var previews: some View {
        CustomStepper(value: .constant(10), range: 10 ... 50)
    }
}
