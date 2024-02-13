/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftUI

struct FAQItem: Identifiable {
    let id: UUID = .init()

    let title: LocalizedStringKey
}
