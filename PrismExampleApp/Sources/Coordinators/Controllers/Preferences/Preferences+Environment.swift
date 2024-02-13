/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import SwiftUI

extension Preferences: EnvironmentKey {
    static let defaultValue = Preferences(userDefaults: .standard)
}

extension EnvironmentValues {
    var preference: Preferences {
        get { self[Preferences.self] }
        set { self[Preferences.self] = newValue }
    }
}

extension View {
    func preference<T>(_ keyPath: WritableKeyPath<Preferences, T>, _ value: T) -> some View {
        self.transformEnvironment(\.preference) {
            $0[keyPath: keyPath] = value
        }
    }
}
