//
//  Feature.swift
//  PrismReference
//
//  Created by Anthony Castelli on 4/6/23.
//

import Foundation
import SwiftUI

/*
@propertyWrapper
public struct Feature<Value>: DynamicProperty {
    @ObservedObject private var features: Features

    private let keyPath: KeyPath<Features, Value>

    public init(_ keyPath: KeyPath<Features, Value>, features: Features) {
        self.keyPath = keyPath
        self.features = features
    }

    public var wrappedValue: Value {
        return self.features[keyPath: self.keyPath]
    }
}
*/

@propertyWrapper
public struct Feature: DynamicProperty {
    @ObservedObject private var features: Features

    private let key: String

    public init(_ key: String, features: Features = .shared) {
        self.key = key
        self.features = features
    }

    public var wrappedValue: Bool {
        return self.features.features[self.key] ?? false
    }
}
