/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

extension Scan.Status {
    var name: LocalizedStringKey {
        switch self {
        case .created: return "ScanStatus.Started"
        case .processing: return "ScanStatus.Processing"
        case .ready: return "ScanStatus.Ready"
        case .failed: return "ScanStatus.Failed"
        @unknown default:
            fatalError()
        }
    }
}
