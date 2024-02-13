/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct MetricsListSectionView: View {
    let items: [ScanItem]

    @State private var selectedSectionIndex: Int = 0
    @State private var selectedMetricIndex: Int = 0

    let keyStatsRange: ClosedRange<Int> = 0 ... 5
    let upperTorsoRange: ClosedRange<Int> = 6 ... 9
    let lowerTorsoRange: ClosedRange<Int> = 10 ... 11
    let armsRange: ClosedRange<Int> = 12 ... 13
    let legsRange: ClosedRange<Int> = 14 ... 17

    var body: some View {
        VStack(spacing: 0) {
            ScanListSectionView(
                selectedIndex: self.$selectedSectionIndex,
                sections: [
                    "ScanDetails.Section.KeyStats",
                    "ScanDetails.Section.UpperTorso",
                    "ScanDetails.Section.LowerTorso",
                    "ScanDetails.Section.Arms",
                    "ScanDetails.Section.Legs",
                ]
            )
            ScanMetricsListView(selectedIndex: self.$selectedMetricIndex, items: self.items)
                .frame(height: 150)
                .padding(.bottom)
                .background(Color.prismBase2)
        }
        .onChange(of: self.selectedSectionIndex) { newValue in
            switch newValue {
            case 0: self.checkMetricRange(self.keyStatsRange)
            case 1: self.checkMetricRange(self.upperTorsoRange)
            case 2: self.checkMetricRange(self.lowerTorsoRange)
            case 3: self.checkMetricRange(self.armsRange)
            case 4: self.checkMetricRange(self.legsRange)
            default: break
            }
        }
        .onChange(of: self.selectedMetricIndex) { newValue in
            switch newValue {
            case self.keyStatsRange: self.selectedSectionIndex = 0
            case self.upperTorsoRange: self.selectedSectionIndex = 1
            case self.lowerTorsoRange: self.selectedSectionIndex = 2
            case self.armsRange: self.selectedSectionIndex = 3
            case self.legsRange: self.selectedSectionIndex = 4
            default: break
            }
        }
    }

    func checkMetricRange(_ range: ClosedRange<Int>) {
        guard !range.contains(self.selectedMetricIndex) else { return }
        self.selectedMetricIndex = range.lowerBound
    }
}

struct MetricsListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsListSectionView(
            items: [
                // Key Stats (0-5)
                ScanItem(type: .bodyFat, value: 0.0),
                ScanItem(type: .leanMassPercentage, value: 0.0),
                ScanItem(type: .fatMass, value: 0.0),
                ScanItem(type: .leanMass, value: 0.0),
                ScanItem(type: .weight, value: 0.0),
                ScanItem(type: .waistToHip, value: 0.0),

                // Upper Torso (6-9)
                ScanItem(type: .neck, value: 0.0),
                ScanItem(type: .shoulders, value: 0.0),
                ScanItem(type: .upperChest, value: 0.0),
                ScanItem(type: .chest, value: 0.0),

                // Lower Torso (10-11)
                ScanItem(type: .waist, value: 0.0),
                ScanItem(type: .hips, value: 0.0),

                // Arms (12-13)
                ScanItem(type: .leftBicep, value: 0.0),
                ScanItem(type: .rightBicep, value: 0.0),

                // Legs (14-17)
                ScanItem(type: .leftThigh, value: 0.0),
                ScanItem(type: .rightThigh, value: 0.0),
                ScanItem(type: .leftCalf, value: 0.0),
                ScanItem(type: .rightCalf, value: 0.0),
            ]
        )
    }
}
