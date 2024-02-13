/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

extension LengthFormatter {
    public static let imperialLengthFormatter: LengthFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        let formatter = LengthFormatter()
        formatter.numberFormatter = numberFormatter
        formatter.isForPersonHeightUse = true
        return formatter
    }()
}

extension Int {
    var personHeight: String {
        let measurement = Measurement(value: Double(self) / 12.0, unit: UnitLength.feet)
        let meters = measurement.converted(to: .meters).value
        return LengthFormatter.imperialLengthFormatter.string(fromMeters: meters)
    }
}
