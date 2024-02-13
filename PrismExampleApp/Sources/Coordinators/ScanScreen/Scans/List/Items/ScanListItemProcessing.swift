/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

import PrismSDK

struct ScanListItemProcessing: View {
    @EnvironmentObject private var uploader: RecordingUploader
    @Preference(\.lastScanId) private var lastScanId: String

    let scan: Scan

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image.bodyScan
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.prismBlack)
                    .padding(14)
                    .background(Color.prismBase5)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(self.scan.createdAt.scanListFormatted)
                        .font(.body.weight(.bold))
                        .foregroundColor(Color.prismBlack)
                    Text(
                        self.scan.status == .created &&
                            self.scan.id == self.uploader.currentScanId && (0.1 ... 0.99).contains(self.uploader.progress)
                            ?
                            "ScanList.State.Uploading" : self.scan.status.name
                    )
                    .font(.body)
                    .foregroundColor(Color.prismBase50)
                }
                Spacer()
            }
            if
                self.scan.status == .created,
                self.scan.id == self.uploader.currentScanId,
                (0.1 ... 0.99).contains(self.uploader.progress) {
                ProgressView(value: self.uploader.progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.prismYellow))
                    .transition(.slide)
            }
        }
    }
}

struct ScanListItemProcessing_Previews: PreviewProvider {
    static var previews: some View {
        Card {
            ScanListItemProcessing(scan: .processingPreview)
        }
        .padding()
        .environmentObject(RecordingUploader.preview)
    }
}
