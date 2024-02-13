/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

enum DownloadError: Error {
    case invalidUrl
}

struct Downloader {
    func download(_ urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else { throw DownloadError.invalidUrl }
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.downloadTask(with: URLRequest(url: url)) { tempUrl, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let tempUrl = tempUrl else {
                    continuation.resume(throwing: DownloadError.invalidUrl)
                    return
                }
                // Rename  the file
                do {
                    let lastPathComponent = tempUrl.lastPathComponent.replacingOccurrences(of: "tmp", with: "ply")
                    var newUrl = tempUrl.deletingLastPathComponent()
                    newUrl = newUrl.appendingPathComponent(lastPathComponent)
                    try FileManager.default.moveItem(at: tempUrl, to: newUrl)
                    continuation.resume(returning: newUrl)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            task.resume()
        }
    }
}
