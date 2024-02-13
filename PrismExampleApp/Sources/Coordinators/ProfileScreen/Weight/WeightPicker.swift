/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct WeightPicker: View {
    private let weightRange: ClosedRange<Int> = 10 ... 600

    @Preference(\.userWeight) private var weight: Int

    var formatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        return formatter
    }

    var body: some View {
        Picker("Weight", selection: self.$weight) {
            ForEach(self.weightRange, id: \.self) { index in
                Text(
                    self.formatter.string(
                        from: Measurement(
                            value: Double(index),
                            unit: UnitMass.pounds
                        )
                    )
                ).tag(index)
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .frame(width: 250)
    }
}

struct WeightPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeightPicker()
    }
}
