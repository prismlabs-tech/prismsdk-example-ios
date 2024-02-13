/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct NewScanView: View {
    @EnvironmentObject private var captureManager: CaptureManager
    @Binding var isPresented: Bool
    @AppStorage("theme") var selectedTheme: ScanTheme = .prism

    var body: some View {
        PrismSessionView { url in
            self.upload(url)
        } onStatus: { status in

        } onDismiss: {
            self.isPresented = false
        }
        .applyTheme(self.selectedTheme.theme)
    }

    func upload(_ file: URL) {
        Task {
            do {
                print("Preparing to upload")
                try await self.captureManager.createScan(with: file)
            } catch {
                print("Failed to upload: \(error)")
            }
        }
    }
}

struct NewScanView_Previews: PreviewProvider {
    static var previews: some View {
        NewScanView(isPresented: .constant(true))
            .environmentObject(CaptureManager.preview)
    }
}
