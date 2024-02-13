/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

@main
struct PrismExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let client: ApiClient = .shared
    let cache: PrismCache = .init()

    var body: some Scene {
        WindowGroup {
            ScansView()
                .environmentObject(self.client)
                .environmentObject(RecordingUploader(apiClient: self.client))
                .environmentObject(ScanManager(apiClient: self.client))
                .environmentObject(CaptureManager(apiClient: self.client))
                .environmentObject(self.cache)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        PrismCache().validateCache()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String) async {
        print("Async background event: \(identifier)")
    }
}
