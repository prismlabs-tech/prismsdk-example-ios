/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct AgePicker: View {
    private let ageRange: ClosedRange<Int> = 18 ... 100

    @Preference(\.userAge) private var age: Int

    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        return formatter
    }

    var body: some View {
        Picker("Weight", selection: self.$age) {
            ForEach(self.ageRange, id: \.self) { index in
                Text(
                    "\(index) Profile.Form.Age.Value",
                    comment: "The age of the user for the profile"
                )
                .tag(index)
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .frame(width: 250)
    }
}

struct AgePicker_Previews: PreviewProvider {
    static var previews: some View {
        AgePicker()
    }
}
