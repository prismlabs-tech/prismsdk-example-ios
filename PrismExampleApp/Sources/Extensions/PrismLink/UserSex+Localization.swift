/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import PrismSDK

extension Sex {
    var name: LocalizedStringKey {
        switch self {
            case .male: return "UserSex.Male"
            case .female: return "UserSex.Female"
            case .neutral: return "UserSex.NonBinary"
        }
    }
}

extension Sex {
    var rawValue: RawValue {
        switch self {
            case .male: return "male"
            case .female: return "female"
            case .neutral: return "neutral"
        }
    }

    init?(rawValue: RawValue) {
        switch rawValue {
            case "male": self = .male
            case "female": self = .female
            case "neutral": self = .neutral
            default: return nil
        }
    }
}
