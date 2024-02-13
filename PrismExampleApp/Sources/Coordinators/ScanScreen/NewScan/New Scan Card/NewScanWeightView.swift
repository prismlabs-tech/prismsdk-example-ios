/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct NewScanWeightView: View {
    @State private var showPicker: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("NewScanCard.Weight", comment: "New scan weight title")
                .font(.body.weight(.bold))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            ProfileWeightContent(showPicker: self.$showPicker)
                .alwaysPopover(isPresented: self.$showPicker) {
                    WeightPicker()
                }
        }
    }
}

struct NewScanWeightView_Previews: PreviewProvider {
    static var previews: some View {
        NewScanWeightView()
    }
}
