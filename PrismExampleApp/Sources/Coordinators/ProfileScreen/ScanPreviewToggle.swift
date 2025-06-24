//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import PrismSDK
import SwiftUI

struct ScanPreviewToggle: View {
    @Environment(\.prismThemeConfiguration) private var theme: PrismThemeConfiguration
    @Preference(\.useScanReview) private var useScanReview: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: self.$useScanReview) {
                HStack {
                    Text("Profile.Form.ScanPreviewEnable")
                        .font(.body)
                        .fontWeight(.bold)
                    InfoButton(info: "Enabled scan preview at the end of capture session")
                }
            }
            .tint(self.theme.primaryColor)
            .frame(height: 40)
        }
    }
}

#Preview {
    ScanPreviewToggle()
}
