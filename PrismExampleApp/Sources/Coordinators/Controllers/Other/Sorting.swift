/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

enum Sorting: String, Identifiable, CaseIterable {
    case latest
    case newest

    var id: Self { self }

    var name: LocalizedStringKey {
        switch self {
        case .latest: "Sorting.Latest"
        case .newest: "Sorting.Newest"
        }
    }

    var key: String {
        switch self {
        case .latest: "desc"
        case .newest: "asc"
        }
    }
}

extension Sorting {
    var rawValue: RawValue {
        switch self {
        case .latest: "latest"
        case .newest: "newest"
        }
    }

    init?(rawValue: RawValue) {
        switch rawValue {
        case "latest": self = .latest
        case "newest": self = .newest
        default: return nil
        }
    }
}
