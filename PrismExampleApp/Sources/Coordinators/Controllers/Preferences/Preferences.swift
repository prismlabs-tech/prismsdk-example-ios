/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Combine
import Foundation
import PrismSDK

enum PreferenceKey: String {
    case userEmail
    case userSex
    case userHeight
    case userWeight
    case userAge
    case profileSet
    case agreeedToTerms
    case agreeedToSharingData
    case lastScanId
    case hasScanned
}

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    fileprivate let userDefaults: UserDefaults

    static func reset() {
        let preferences = Preferences(userDefaults: .standard)
        preferences.userEmail = ""
        preferences.userSex = .neutral
        preferences.userHeight = 69
        preferences.userWeight = 167
        preferences.userAge = 42
        preferences.onboardingComplete = false
        preferences.agreedToTerms = false
        preferences.agreedToSharingData = true
        preferences.lastScanId = ""
        preferences.hasScanned = false
    }

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    @UserDefault(PreferenceKey.userEmail.rawValue) var userEmail: String = ""

    @UserDefault(wrappedValue: nil, PreferenceKey.userSex.rawValue) var userSex: Sex?

    @UserDefault(PreferenceKey.userHeight.rawValue) var userHeight: Int = 69

    @UserDefault(PreferenceKey.userWeight.rawValue) var userWeight: Int = 167

    @UserDefault(PreferenceKey.userAge.rawValue) var userAge: Int = 42

    @UserDefault(PreferenceKey.profileSet.rawValue) var onboardingComplete: Bool = false

    @UserDefault(PreferenceKey.agreeedToTerms.rawValue) var agreedToTerms: Bool = false

    @UserDefault(PreferenceKey.agreeedToSharingData.rawValue) var agreedToSharingData: Bool = true

    @UserDefault(PreferenceKey.lastScanId.rawValue) var lastScanId: String = ""

    @UserDefault(PreferenceKey.hasScanned.rawValue) var hasScanned: Bool = false
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    // swiftlint:disable unused_setter_value
    var wrappedValue: Value {
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") }
    }

    // swiftlint:enable unused_setter_value

    init(wrappedValue: Value, _ key: String) {
        self.defaultValue = wrappedValue
        self.key = key
    }

    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    )
        -> Value {
        get {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            let defaultValue = instance[keyPath: storageKeyPath].defaultValue
            if let stringValue = container.string(forKey: key) {
                if let sex = Sex(rawValue: stringValue) {
                    return sex as? Value ?? defaultValue
                }
                if let sorting = Sorting(rawValue: stringValue) {
                    return sorting as? Value ?? defaultValue
                }
            }
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            let container = instance.userDefaults
            let key = instance[keyPath: storageKeyPath].key
            if let raw = newValue as? (any RawRepresentable) {
                container.set(raw.rawValue, forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}
