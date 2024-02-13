/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ScanDetailsGridView: View {
    let data: [ScanSection]

    let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(LinearGradient.prismGradient, lineWidth: 1)

            LazyVGrid(
                columns: self.gridColumns,
                alignment: .leading,
                spacing: 24,
                pinnedViews: []
            ) {
                ForEach(self.data) { section in
                    Section(header: self.header(title: section.title)) {
                        ForEach(section.items) { item in
                            ScanItemView(scanType: item.type, value: item.value)
                        }
                    }
                }
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    func header(title: LocalizedStringKey) -> some View {
        HStack {
            Text(title)
                .font(.title3.weight(.bold))
            Spacer()
        }
    }
}

struct ScanDetailsGridView_Previews: PreviewProvider {
    static var previews: some View {
        ScanDetailsGridView(
            data: [
                .init(
                    title: "Jan 1, 2023",
                    items: [
                        .init(type: .fatMass, value: 5.0),
                        .init(type: .leanMass, value: 5.0),
                    ]
                ),
                .init(
                    title: "ScanDetails.Section.Circumferences",
                    items: [
                        .init(type: .neck, value: 5.0),
                        .init(type: .rightLowerThigh, value: 5.0),
                    ]
                ),
            ]
        )
    }
}
