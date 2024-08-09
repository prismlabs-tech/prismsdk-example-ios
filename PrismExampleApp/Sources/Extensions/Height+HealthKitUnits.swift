//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit
import PrismSDK

extension Height {
    
    var healthKitUnit: HKUnit {
        switch(self.unit) {
        case .meters:
            return HKUnit.meter()
        case .inches:
            return HKUnit.inch()
        }
    }
}
