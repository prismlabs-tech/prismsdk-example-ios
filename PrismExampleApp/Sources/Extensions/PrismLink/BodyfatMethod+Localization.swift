//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import SwiftUI
import PrismSDK

extension BodyfatMethod {
    var name: LocalizedStringKey {
        switch self {
        case .adam:
            return "BodyfatMethod.Adam"
        case .army:
            return "BodyfatMethod.Army"
        case .army_athlete:
            return "BodyfatMethod.ArmyAthlete"
        case .coco:
            return "BodyfatMethod.Coco"
        case .coco_bri:
            return "BodyfatMethod.CocoBri"
        case .coco_legacy:
            return "BodyfatMethod.CocoLegacy"
        case .extended_navy_thinboost:
            return "BodyfatMethod.ExtendedNavyThinboost"
        case .tina_fit:
            return "BodyfatMethod.TinaFit"
        }
    }
}

extension BodyfatMethod {
    var rawValue: RawValue {
        switch self {
        case .adam:
            return "adam"
        case .army:
            return "army"
        case .army_athlete:
            return "army_athlete"
        case .coco:
            return "coco"
        case .coco_bri:
            return "coco_bri"
        case .coco_legacy:
            return "coco_legacy"
        case .extended_navy_thinboost:
            return "extended_navy_thinboost"
        case .tina_fit:
            return "tina_fit"
        }
    }
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "adam":
            self = .adam
        case "army":
            self = .army
        case "army_athlete":
            self = .army_athlete
        case "coco":
            self = .coco
        case "coco_bri":
            self = .coco_bri
        case "coco_legacy":
            self = .coco_legacy
        case "extended_navy_thinboost":
            self = .extended_navy_thinboost
        case "tina_fit":
            self = .tina_fit
        default:
            return nil
        }
    }
}
