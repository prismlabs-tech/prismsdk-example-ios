/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ScansView: View {
    @Preference(\.onboardingComplete) private var onboardingComplete: Bool

    @State private var showOnboarding: Bool = false
    @State private var showNewScan: Bool = false

    var body: some View {
        NavigationView {
            ScansListView(showNewScan: self.$showNewScan)
        }
        .onAppear {
            self.showOnboarding = !self.onboardingComplete
        }
        .onChange(of: self.onboardingComplete) { newValue in
            guard !newValue else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: self.$showOnboarding) {
            OnboardingProfileView(isPresented: self.$showOnboarding)
        }
        .fullScreenCover(isPresented: self.$showNewScan) {
            NewScanView(isPresented: self.$showNewScan)
        }
    }
}

struct ScansView_Previews: PreviewProvider {
    static var previews: some View {
        ScansView()
            .environmentObject(ApiClient.preview)
            .environmentObject(ScanManager.preview)
            .environmentObject(RecordingUploader.preview)
            .environmentObject(PrismCache())
    }
}
