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
    static let uploadScan = Notification.Name("uploadScan")
    static let checkUploading = Notification.Name("checkUploading")
}

class RecordingUploader: ObservableObject {
    static let preview: RecordingUploader = {
        RecordingUploader(apiClient: ApiClient.preview)
    }()

    private let client: ScanClient
    private let uploader = FileUploader()

    private var uploadingCancelable: AnyCancellable?
    private var uploadProgressCancelable: AnyCancellable?
    private var uploadCompleteCancelable: AnyCancellable?

    @Published var isUploading: Bool = false
    @Published var currentScanId: String?
    @Published var currentUploadFile: URL?
    @Published var progress: Double = 0.0

    init(apiClient: ApiClient) {
        self.client = ScanClient(client: ApiClient.shared)
        self.uploader.setup()
        self.listen()

        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadScanNotification), name: .uploadScan, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkUploads), name: .checkUploading, object: nil)
    }

    deinit {
        self.uploadingCancelable?.cancel()
        self.uploadProgressCancelable?.cancel()
        self.uploadCompleteCancelable?.cancel()

        NotificationCenter.default.removeObserver(self)
    }

    func listen() {
        self.uploadProgressCancelable = self.uploader.$progress
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] value in
                self?.progress = value
                print("Upload Progress: \(Int(value * 100))%")
                if self?.currentScanId == nil {
                    self?.checkUploads()
                }
                if value == 1.0 {
                    NotificationCenter.default.post(Notification(name: .refreshLatestScans))
                }
            })

        self.uploadCompleteCancelable = self.uploader.$uploadedFile
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] value in
                do {
                    guard value else { return }
                    guard let file = self?.currentUploadFile else { return }
                    try FileManager.default.removeItem(at: file)
                    self?.currentUploadFile = nil
                    self?.isUploading = false
                    NotificationCenter.default.post(Notification(name: .refreshLatestScans))
                } catch {
                    print("Error deleteing file: \(error)")
                }
            })
    }

    @objc
    func checkUploads() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        guard let contents = try? FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return }
        guard !contents.isEmpty else { return }
        guard let file = contents.first(where: { $0.pathExtension == "zip" }) else { return }
        self.currentUploadFile = file
        self.currentScanId = file.lastPathComponent.replacingOccurrences(of: "scan_", with: "").replacingOccurrences(of: ".zip", with: "")
        self.isUploading = true
    }

    func upload(file: URL, forScan id: String) async throws {
        DispatchQueue.main.async {
            self.isUploading = true
            self.currentUploadFile = file
            self.currentScanId = id
            NotificationCenter.default.post(Notification(name: .refreshLatestScans))
        }
        let response = try await self.client.uploadUrl(forScan: id)
        guard let url = URL(string: response.url) else {
            throw NetworkingError.invalidURL
        }
        self.uploader.upload(file: file, to: url)
    }

    @objc
    func uploadScanNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let file = notification.object as? URL else { return }
        guard let id = userInfo["id"] as? String else { return }

        Task {
            do {
                try await self.upload(file: file, forScan: id)
            } catch {
                print("Error Uploading: \(file) - \(error)")
            }
        }
    }
}
