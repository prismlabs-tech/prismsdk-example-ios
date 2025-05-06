/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScanSection: Identifiable {
    var id: UUID = .init()
    let title: LocalizedStringKey
    let items: [ScanItem]
}

struct ScanItem: Identifiable, Equatable {
    static let spacer = ScanItem(type: .spacer, value: 0.0)

    var id: ScanItemType { self.type }
    let type: ScanItemType
    let value: Double

    init(type: ScanItemType, value: Double) {
        self.type = type
        self.value = value
    }
}

enum ScanItemType: String, CaseIterable, Identifiable {
    // Key Stats
    case fatMassPercentage
    case leanMassPercentage
    case fatMass
    case leanMass
    case weight
    case bodyFat

    // Upper Torse
    case neck
    case shoulders
    case upperChest
    case chest

    // Lower Torse
    case waistToHip
    case waist
    case hips

    // Arms
    case leftBicep
    case rightBicep
    case leftForearm
    case rightForearm
    case leftWrist
    case rightWrist

    // Legs
    case leftUpperThigh
    case rightUpperThigh

    case leftLowerThigh
    case rightLowerThigh

    case leftThigh
    case rightThigh

    case leftCalf
    case rightCalf

    // Other
    case spacer

    var id: Self { self }
}

extension ScanItemType {
    var name: LocalizedStringKey {
        LocalizedStringKey(stringLiteral: "BodyScanType.\(self.rawValue)")
    }
}

extension ScanItemType {
    func format(_ value: Double) -> (measurement: String, unit: String) {
        switch self {
        case .fatMass, .leanMass:
            let kilos = Measurement(value: value, unit: UnitMass.kilograms)
            let formatter = MeasurementFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.unitStyle = .medium
            formatter.unitOptions = .naturalScale
            formatter.numberFormatter.minimumFractionDigits = 1
            formatter.numberFormatter.maximumFractionDigits = 1
            return formatter.components(for: kilos)

        case .weight:
            let kilos = Measurement(value: value, unit: UnitMass.kilograms)
            let formatter = MeasurementFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.unitStyle = .medium
            formatter.unitOptions = .naturalScale
            formatter.numberFormatter.minimumFractionDigits = 1
            formatter.numberFormatter.maximumFractionDigits = 1
            return formatter.components(for: kilos)

        case .fatMassPercentage, .leanMassPercentage, .bodyFat:
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.numberStyle = .percent
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            let formatted = String(formatter.string(from: NSNumber(value: value / 100.0))?.dropLast(1) ?? "--")
            return (formatted, "%")

        case .waistToHip:
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 2
            let formatted = String(formatter.string(from: NSNumber(value: value)) ?? "--")
            return (formatted, "")

        default:
            let meters = Measurement(value: value, unit: UnitLength.meters)
            let formatter = MeasurementFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.unitStyle = .medium
            formatter.unitOptions = .naturalScale
            formatter.numberFormatter.roundingMode = .halfUp
            formatter.numberFormatter.minimumFractionDigits = 1
            formatter.numberFormatter.maximumFractionDigits = 1
            return formatter.components(for: meters)
        }
    }
}

extension MeasurementFormatter {
    func components<UnitType: Unit>(for measurement: Measurement<UnitType>) -> (measurement: String, unit: String) {
        guard let measurementString = self.string(for: measurement) else { return (measurement: "--", unit: "--") }
        let components = measurementString.split(separator: " ")
        let measurement = (components.first ?? "--").trimmingCharacters(in: .whitespaces)
        let unit = (components.last ?? "--").trimmingCharacters(in: .whitespaces)
        return (measurement: measurement, unit: unit)
    }
}
