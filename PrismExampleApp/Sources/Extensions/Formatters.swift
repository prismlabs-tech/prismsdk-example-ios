/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

extension Date {
    var scanListFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d 'at' h:mm a"
        return formatter.string(from: self)
    }
}
