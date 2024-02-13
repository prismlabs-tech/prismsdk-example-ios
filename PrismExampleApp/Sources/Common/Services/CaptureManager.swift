/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Combine
import Foundation
import PrismSDK

class CaptureManager: ObservableObject {
    static let preview: CaptureManager = {
        CaptureManager(apiClient: ApiClient.preview)
    }()

    @Preference(\.agreedToSharingData) private var agreedToSharingData: Bool
    @Preference(\.hasScanned) private var hasScanned: Bool
    @Preference(\.lastScanId) private var lastScanId: String
    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.userWeight) private var userWeight: Int

    let apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func createScan(with file: URL) async throws {
        let _ = try await UserClient(client: self.apiClient)
            .update(
                user: .init(
                    token: self.userEmail.lowercased(),
                    weight: .init(
                        value: Double(self.userWeight),
                        unit: .pounds
                    ),
                    researchConsent: self.agreedToSharingData
                )
            )
        let client = ScanClient(client: self.apiClient)
        let result = try await client.createScan(NewScan(deviceConfigName: "IPHONE_SCANNER", userToken: self.userEmail.lowercased()))
        self.lastScanId = result.id
        self.hasScanned = true

        // Rename the scan with the new id
        var newFilePath = file.path
        newFilePath = newFilePath.replacingOccurrences(of: file.lastPathComponent, with: "scan_\(result.id).zip")
        let newFile = URL(fileURLWithPath: newFilePath)
        try FileManager.default.moveItem(at: file, to: newFile)

        // Upload
        NotificationCenter.default.post(Notification(name: .uploadScan, object: newFile, userInfo: ["id": result.id]))

        // Refresh
        NotificationCenter.default.post(Notification(name: .refreshLatestScans))
    }
}
