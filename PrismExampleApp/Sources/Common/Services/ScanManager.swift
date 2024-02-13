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

extension Notification.Name {
    static let refreshLatestScans = Notification.Name("refreshLatestScans")
}

class ScanManager: ObservableObject {
    static let preview: ScanManager = {
        let manager = ScanManager(apiClient: ApiClient.preview)
        manager.shouldPaginate = false
        manager.scans = [GroupedScans(date: Date(), scans: [Scan.readyPreview, Scan.failedPreview, Scan.processingPreview, Scan.createdPreview])]
        return manager
    }()

    @Preference(\.hasScanned) private var hasScanned: Bool
    @Preference(\.userEmail) private var userEmail: String

    @Published var scans: [GroupedScans] = []
    @Published var pageInfo: PageInfo?
    @Published var shouldPaginate: Bool = true

    private static let limit: Int = 10

    private let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    private var timerCancelable: Cancellable?

    private let apiClient: ApiClient
    private let scanClient: ScanClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
        self.scanClient = ScanClient(client: self.apiClient)
        self.timerCancelable = self.timer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.refreshScansFromNotification()
            })

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshScansFromNotification), name: .refreshLatestScans, object: nil)
    }

    deinit {
        self.timerCancelable?.cancel()

        NotificationCenter.default.removeObserver(self)
    }

    func fetchMoreScans() async throws {
        let response = try await self.refreshScans(at: self.pageInfo?.cursor)
        self.pageInfo = response.pageInfo
        self.shouldPaginate = response.pageInfo.cursor != nil && response.results.count == ScanManager.limit

        self.cleanUploads()

        NotificationCenter.default.post(Notification(name: .checkUploading))
    }

    func refreshScans(at cursor: String? = nil) async throws -> Paginated<Scan> {
        let response = try await self.scanClient.getScans(forUser: self.userEmail.lowercased(), limit: ScanManager.limit, cursor: cursor)

        if !self.userEmail.isEmpty {
            self.scans = self.parseScanList(with: response.results)
            self.hasScanned = !self.scans.isEmpty
        } else {
            self.scans = []
            self.hasScanned = false
        }
        return response
    }

    func remove(_ scan: Scan) {
        var currentScans = self.scans.list
        currentScans.removeAll(where: { $0.id == scan.id })
        self.scans = currentScans.grouped
        Task {
            do {
                let _ = try await self.scanClient.deleteScan(scan.id)
            } catch {
                print("Error Deleteing Scan: \(scan.id) \(error)")
            }
        }
    }

    private func parseScanList(with newScans: [Scan]) -> [GroupedScans] {
        let currentScans = self.scans.list

        var scans = Set<Scan>(newScans)
        currentScans.forEach { currentScan in
            if !scans.contains(where: { $0.id == currentScan.id }) {
                scans.insert(currentScan)
            }
        }

        return Array(scans).grouped
    }

    @objc
    private func refreshScansFromNotification() {
        Task {
            try await self.refreshScans()
        }
    }

    private func cleanUploads() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let readyScans = self.scans.map(\.scans).compactMap { $0 }.flatMap { $0 }.filter { ![Scan.Status.created].contains($0.status) }
        for scan in readyScans {
            let file = documentsDirectory.appendingPathComponent("scan_\(scan.id).zip")
            guard FileManager.default.fileExists(atPath: file.path) else { continue }
            try? FileManager.default.removeItem(at: file)
            print("Removed Scan: \(scan.id)")
        }
    }

    func clearDocuments() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch {
            print(error)
        }
    }

    func resetScanList() {
        self.scans = []
        self.pageInfo = nil
    }
}
