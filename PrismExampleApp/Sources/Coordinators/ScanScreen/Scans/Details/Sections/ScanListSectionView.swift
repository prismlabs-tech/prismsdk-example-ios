/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct SectionItem: Hashable {
    let title: LocalizedStringKey

    func hash(into hasher: inout Hasher) {}
}

struct ScanListSectionView: View {
    @Binding var selectedIndex: Int
    @State var selectedSection: SectionItem?
    let sections: [SectionItem]

    init(selectedIndex: Binding<Int>, sections: [LocalizedStringKey]) {
        self._selectedIndex = selectedIndex
        let mapped = sections.map { SectionItem(title: $0) }
        self.selectedSection = mapped.first
        self.sections = mapped
    }

    var body: some View {
        VStack {
            HorizontalPicker(selectedOption: self.$selectedSection, options: self.sections) { item in
                Text(item.title)
            }
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 4.0)
            Divider()
        }
        .background(Color.prismWhite)
        .onChange(of: self.selectedSection) { newValue in
            guard let newValue else { return }
            guard let index = self.sections.firstIndex(of: newValue) else { return }
            self.selectedIndex = index
        }
        .onChange(of: self.selectedIndex) { newValue in
            withAnimation {
                self.selectedSection = self.sections[newValue]
            }
        }
    }
}

struct ScanListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ScanListSectionView(
            selectedIndex: .constant(0),
            sections: ["Test", "Test 1", "Test 2", "Test 3"]
        )
    }
}
