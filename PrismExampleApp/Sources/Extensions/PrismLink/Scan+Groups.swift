/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import PrismSDK

// Groups scans into Months for display in the view
extension Array where Element == Scan {
    var grouped: [GroupedScans] {
        let dictionary = Dictionary(grouping: self) { "\($0.createdAt.month):\($0.createdAt.year)" }
        let results = dictionary
            .map { GroupedScans(date: $0.key, scans: $0.value) }
            .sorted(by: \.date, isAscending: false)
        return results
    }
}

// Unwraps grouped scans into a list for API updates
extension Array where Element == GroupedScans {
    var list: [Scan] {
        self.map { $0.scans }
            .compactMap { $0 }
            .flatMap { $0 }
            .sorted(by: \.createdAt)
    }
}
