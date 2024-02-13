/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

extension Array {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, isAscending: Bool = true) -> [Element] {
        self.sorted {
            let lhs = $0[keyPath: keyPath]
            let rhs = $1[keyPath: keyPath]
            return isAscending ? lhs < rhs : lhs > rhs
        }
    }

    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        self.map { $0[keyPath: keyPath] }
    }
}
