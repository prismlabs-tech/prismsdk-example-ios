//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import SwiftUI
import PrismSDK

extension AssetConfigId {

    var name: LocalizedStringKey {
        switch self {
            case .singlePlyOnly: return "ScanAssetsBundleID.SinglePly"
            case .objTextureBased: return "ScanAssetsBundleID.ObjTextureBased"
            case .objTextureBasedV2: return "ScanAssetsBundleID.ObjTextureBasedV2"
        }
    }
}

extension AssetConfigId {

    var rawValue: RawValue {
        switch self {
            case .singlePlyOnly: return "a7224818-b0ee-44ee-9984-1c47b086d269"
            case .objTextureBased: return "c979ab6b-e46b-4c1c-89e1-bb02435b5cbf"
            case .objTextureBasedV2: return "25f6d3a6-a634-40c3-8452-0342bee242d0"
        }
    }

    init?(rawValue: RawValue) {
        switch rawValue {
            case "a7224818-b0ee-44ee-9984-1c47b086d269": self = .singlePlyOnly
            case "c979ab6b-e46b-4c1c-89e1-bb02435b5cbf": self = .objTextureBased
            case "25f6d3a6-a634-40c3-8452-0342bee242d0": self = .objTextureBasedV2
            default: return nil
        }
    }
}
