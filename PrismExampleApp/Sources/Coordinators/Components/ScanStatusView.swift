/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

import PrismSDK

struct ScanStatusView: View {
    var scan: Scan?

    private var status: LocalizedStringKey {
        self.scan?.status.name ?? "ScanStatus.NotStarted"
    }

    var body: some View {
        HStack(alignment: .center) {
            Image.bodyScan
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(Color.prismBlack)
                .padding(15)
                .background(Color.prismBase5)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text("ScanStatus.Title")
                    .font(.title3.weight(.medium))
                Text(self.status)
                    .font(.body)
                    .foregroundColor(Color.prismBase50)
            }
            Spacer()
        }
    }
}

struct ScanStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ScanStatusView()
    }
}
