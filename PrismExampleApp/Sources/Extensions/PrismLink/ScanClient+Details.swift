/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import PrismSDK

struct ScanDetails {
    let scan: Scan
    let measurements: Measurements?

    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self.scan.createdAt)
    }

    init(scan: Scan, measurements: Measurements? = nil) {
        self.scan = scan
        self.measurements = measurements
    }
}

extension ScanDetails {
    var items: [ScanItem] {
        [
            // Key Stats
            .init(type: .bodyFat, value: self.scan.bodyfat?.bodyfatPercentage ?? 0.0),
            .init(type: .leanMassPercentage, value: self.scan.bodyfat?.leanMassPercentage ?? 0.0),
            .init(type: .fatMass, value: self.scan.bodyfat?.fatMass ?? 0.0),
            .init(type: .leanMass, value: self.scan.bodyfat?.leanMass ?? 0.0),
            .init(type: .weight, value: self.scan.weight.value),
            .init(type: .waistToHip, value: self.measurements?.waistToHipRatio ?? 0.0),

            // Upper Torso
            .init(type: .neck, value: self.measurements?.neckFit ?? 0.0),
            .init(type: .shoulders, value: self.measurements?.shoulderFit ?? 0.0),
            .init(type: .upperChest, value: self.measurements?.upperChestFit ?? 0.0),
            .init(type: .chest, value: self.measurements?.chestFit ?? 0.0),

            // Lower Torso
            .init(type: .waist, value: self.measurements?.waistFit ?? 0.0),
            .init(type: .hips, value: self.measurements?.hipsFit ?? 0.0),

            // Arms
            .init(type: .leftBicep, value: self.measurements?.midArmLeftFit ?? 0.0),
            .init(type: .rightBicep, value: self.measurements?.midArmRightFit ?? 0.0),
            .init(type: .leftForearm, value: self.measurements?.forearmLeftFit ?? 0.0),
            .init(type: .rightForearm, value: self.measurements?.forearmRightFit ?? 0.0),
            .init(type: .leftWrist, value: self.measurements?.wristLeftFit ?? 0.0),
            .init(type: .rightWrist, value: self.measurements?.wristRightFit ?? 0.0),

            // Legs
            .init(type: .leftThigh, value: self.measurements?.thighLeftFit ?? 0.0),
            .init(type: .rightThigh, value: self.measurements?.thighRightFit ?? 0.0),
            .init(type: .leftCalf, value: self.measurements?.calfLeftFit ?? 0.0),
            .init(type: .rightCalf, value: self.measurements?.calfRightFit ?? 0.0)
        ]
    }

    var data: [ScanSection] {
        [
            ScanSection(
                title: "ScanDetails.Section.KeyStats",
                items: [
                    .init(type: .bodyFat, value: self.scan.bodyfat?.bodyfatPercentage ?? 0.0),
                    .init(type: .leanMassPercentage, value: self.scan.bodyfat?.leanMassPercentage ?? 0.0),
                    .init(type: .fatMass, value: self.scan.bodyfat?.fatMass ?? 0.0),
                    .init(type: .leanMass, value: self.scan.bodyfat?.leanMass ?? 0.0),
                    .init(type: .weight, value: self.scan.weight.value),
                    .init(type: .waistToHip, value: self.measurements?.waistToHipRatio ?? 0.0)
                ]
            ),
            ScanSection(
                title: "ScanDetails.Section.UpperTorso",
                items: [
                    .init(type: .neck, value: self.measurements?.neckFit ?? 0.0),
                    .init(type: .shoulders, value: self.measurements?.shoulderFit ?? 0.0),
                    .init(type: .upperChest, value: self.measurements?.upperChestFit ?? 0.0),
                    .init(type: .chest, value: self.measurements?.chestFit ?? 0.0),
                ]
            ),
            ScanSection(
                title: "ScanDetails.Section.LowerTorso",
                items: [
                    .init(type: .waist, value: self.measurements?.waistFit ?? 0.0),
                    .init(type: .hips, value: self.measurements?.hipsFit ?? 0.0),
                ]
            ),
            ScanSection(
                title: "ScanDetails.Section.Arms",
                items: [
                    .init(type: .leftBicep, value: self.measurements?.midArmLeftFit ?? 0.0),
                    .init(type: .rightBicep, value: self.measurements?.midArmRightFit ?? 0.0),
                    .init(type: .leftForearm, value: self.measurements?.forearmLeftFit ?? 0.0),
                    .init(type: .rightForearm, value: self.measurements?.forearmRightFit ?? 0.0),
                    .init(type: .leftWrist, value: self.measurements?.wristLeftFit ?? 0.0),
                    .init(type: .rightWrist, value: self.measurements?.wristRightFit ?? 0.0)
                ]
            ),
            ScanSection(
                title: "ScanDetails.Section.Legs",
                items: [
                    .init(type: .leftThigh, value: self.measurements?.thighLeftFit ?? 0.0),
                    .init(type: .rightThigh, value: self.measurements?.thighRightFit ?? 0.0),
                    .init(type: .leftCalf, value: self.measurements?.calfLeftFit ?? 0.0),
                    .init(type: .rightCalf, value: self.measurements?.calfRightFit ?? 0.0),
                ]
            ),
        ]
    }
}

extension ScanClient {
    func getDetails(for id: String) async throws -> ScanDetails {
        let scan = try await self.getScan(forScan: id)
        if scan.status == .processing || scan.status == .failed {
            return .init(scan: scan)
        }
        let measurements = try await self.measurements(forScan: id)
        return .init(scan: scan, measurements: measurements)
    }
}
