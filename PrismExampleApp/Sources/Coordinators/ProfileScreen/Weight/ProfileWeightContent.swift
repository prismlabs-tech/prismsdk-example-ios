/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ProfileWeightContent: View {
    @Preference(\.userWeight) private var userWeight: Int

    @Binding var showPicker: Bool

    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        return formatter
    }

    var body: some View {
        HStack {
            Button {
                self.showPicker = true
            } label: {
                HStack {
                    Text(
                        self.formatter.string(
                            from: Measurement(
                                value: Double(self.userWeight),
                                unit: UnitMass.pounds
                            )
                        )
                    )
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

                CustomStepper(value: self.$userWeight, range: 10 ... 600)
                    .padding(.leading, 10.0)
            }
        }
    }
}

struct ProfileWeightContent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileWeightContent(showPicker: .constant(false))
    }
}
