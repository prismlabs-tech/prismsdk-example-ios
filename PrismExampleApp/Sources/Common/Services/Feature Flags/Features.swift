//
//  FeatureManager.swift
//  PrismReference
//
//  Created by Anthony Castelli on 4/6/23.
//

import SwiftUI
import GrowthBook

public class Features: ObservableObject {
    public static let shared = Features()
    private var instance: GrowthBookSDK?

    private var attributes: [String: Any] = [:]
    @Published var features: [String: Bool] = [:]

    init() { }

    public func setup(grownBookUrl: String, attributes: [String: Any] = [:]) {
        self.attributes = attributes

        self.instance = GrowthBookBuilder(url: grownBookUrl, attributes: attributes, trackingCallback: { _, _ in }).initializer()

        let features = self.instance?.getFeatures() ?? [:]
        self.features = Dictionary(uniqueKeysWithValues: features.map({ ($0.key, self.instance?.isOn(feature: $0.key) ?? false) }))
    }

    public func setAttributes( _ attributes: [String: Any]) {
        let mutableAttributes = attributes
        // Apply any required attributes such as deviceId
        self.instance?.setAttributes(attributes: mutableAttributes)
    }

    public func isOn(_ key: String) -> Bool {
        return self.instance?.isOn(feature: key) ?? false
    }

    func value<T>(for key: String) -> T? {
        return self.instance?.evalFeature(id: key).value?.object as? T
    }
}

extension Features: EnvironmentKey {
    public static let defaultValue = Features.shared
}

extension EnvironmentValues {
    var features: Features {
        get { self[Features.self] }
        set { self[Features.self] = newValue }
    }
}

extension View {
    func feature<T>(_ keyPath: WritableKeyPath<Features, T>, _ value: T) -> some View {
        self.transformEnvironment(\.features) {
            $0[keyPath: keyPath] = value
        }
    }

    func feature(_ key: String, _ value: Bool) -> some View {
        self.transformEnvironment(\.features) {
            $0.features[key] = value
        }
    }
}
