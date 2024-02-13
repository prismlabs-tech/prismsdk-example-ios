/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ScanListItemView: View {
    let scan: Scan

    var body: some View {
        Card {
            switch self.scan.status {
            case .created, .processing, .failed:
                ScanListItemProcessing(scan: self.scan)
            case .ready:
                NavigationLink(
                    destination: ScanDetailsView(scan: self.scan),
                    label: { ScanListItemContent(scan: self.scan) }
                )
            @unknown default:
                fatalError()
            }
        }
    }
}

struct ScanListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ScanListItemView(scan: .processingPreview)
            .padding()
            .environmentObject(RecordingUploader.preview)
    }
}
