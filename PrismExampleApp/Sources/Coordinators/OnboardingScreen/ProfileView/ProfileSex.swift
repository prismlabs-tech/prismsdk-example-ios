/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

enum ProfileSex: String, Identifiable, CaseIterable, Codable {
    case male
    case female
    case nonBinary

    var id: Self { self }
}
