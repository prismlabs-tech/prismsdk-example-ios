/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct ScanMetricsListView: View {
    @Binding var selectedIndex: Int
    let items: [ScanItem]

    init(selectedIndex: Binding<Int>, items: [ScanItem]) {
        self._selectedIndex = selectedIndex
        self.items = items
    }

    var body: some View {
        CollectionView(
            collection: self.items,
            selection: self.$selectedIndex,
            contentSize: .fixed(CGSize(width: 150, height: 75)),
            itemSpacing: .init(mainAxisSpacing: 8, crossAxisSpacing: 0),
            rawCustomize: { collectionView in
                collectionView.showsHorizontalScrollIndicator = false
            },
            contentForData: { data -> ScanItemView in
                let index = self.items.firstIndex(where: { $0.id == data.id })
                return ScanItemView(scanType: data.type, value: data.value, isHighlighted: index == self.selectedIndex)
            }
        )
    }
}

struct ScanMetricsListView_Previews: PreviewProvider {
    static var previews: some View {
        ScanMetricsListView(
            selectedIndex: .constant(0),
            items: [
                ScanItem(type: .bodyFat, value: 1.0),
                ScanItem(type: .chest, value: 1.0),
                ScanItem(type: .fatMassPercentage, value: 1.0),
                ScanItem(type: .leanMass, value: 1.0),
                ScanItem(type: .leanMassPercentage, value: 1.0),
                ScanItem(type: .hips, value: 1.0),
            ]
        )
    }
}
