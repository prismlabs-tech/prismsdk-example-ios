/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct NewScanChecklist: View {
    @Environment(\.prismThemeConfiguration) var theme: PrismThemeConfiguration

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("NewScanCard.Checklist.Title", comment: "New scan checklist title")
                    .font(.body.weight(.bold))
                VStack(alignment: .leading) {
                    Checkmark(title: "NewScanCard.Checklist.Volume")
                    Checkmark(title: "NewScanCard.Checklist.FaceCovering")
                    Checkmark(title: "NewScanCard.Checklist.Hair")
                    Checkmark(title: "NewScanCard.Checklist.Clothing")
                    Checkmark(title: "NewScanCard.Checklist.Space")
                    Checkmark(title: "NewScanCard.Checklist.Phone")
                }
                .padding(.leading, 10)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(self.theme.borderColor, lineWidth: 1)
                .shadow(color: .prismBase10, radius: 2)
        )
    }
}

struct NewScanChecklist_Previews: PreviewProvider {
    static var previews: some View {
        NewScanChecklist()
    }
}
