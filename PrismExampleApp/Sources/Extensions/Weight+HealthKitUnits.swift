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

extension Weight {
    
    var healthKitUnit: HKUnit {
        switch(self.unit) {
        case .kilograms:
            return HKUnit.gram()   // TODO: Our data is in KG, maybe additional conversion is needed
        case .pounds:
            return HKUnit.pound()
        }
    }
}
