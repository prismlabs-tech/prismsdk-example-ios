/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import PrismSDK

enum DownloadError: Error {
    case invalidUrl
    case assetNotSupported
    case assetSignedUrlDoesNotExist
}

protocol AssetsBundleFileExtensions {
    var modelFileExtension: String { get }
    var previewFileExtension: String? { get }
    var textureFileExtension: String? { get }
    var materialFileExtension: String? { get }
    var stripesFileExtension: String? { get }
}

struct PlyAssetsBundle: AssetsBundleFileExtensions {
    var modelFileExtension: String = "ply"
    var previewFileExtension: String? = "png"
    var textureFileExtension: String? = nil
    var materialFileExtension: String? = nil
    var stripesFileExtension: String? = nil
}

struct ObjTextureBasedAssetsBundle: AssetsBundleFileExtensions {
    var modelFileExtension: String = "obj"
    var previewFileExtension: String? = "png"
    var textureFileExtension: String? = "png"
    var materialFileExtension: String? = "mtl"
    var stripesFileExtension: String? = nil
}


func getAssetsBundleFileExtensions(for assetConfigId: AssetConfigId) -> AssetsBundleFileExtensions {
    switch(assetConfigId){
    case .singlePlyOnly:
        return PlyAssetsBundle()
    case .objTextureBased:
        return ObjTextureBasedAssetsBundle()
    }
}

struct Downloader {
    
    private let assetConfigId: AssetConfigId
    private let assetsBundleFileExtensions: AssetsBundleFileExtensions
    
    init(assetConfigId: AssetConfigId) {
        self.assetConfigId = assetConfigId
        self.assetsBundleFileExtensions = getAssetsBundleFileExtensions(for: assetConfigId)
    }
    
    func download(file type: PrismFile.File, from signedURL: String?) async -> URL? {
        switch(type) {
        case .preview:
            return try? await self.downloadFile(from: signedURL, with: assetsBundleFileExtensions.previewFileExtension)
        case .model:
            return try? await self.downloadFile(from: signedURL, with: assetsBundleFileExtensions.modelFileExtension)
        case .stripes:
            return try? await self.downloadFile(from: signedURL, with: assetsBundleFileExtensions.stripesFileExtension)
        case .texture:
            return try? await self.downloadFile(from: signedURL, with: assetsBundleFileExtensions.textureFileExtension)
        case .material:
            return try? await self.downloadFile(from: signedURL, with: assetsBundleFileExtensions.materialFileExtension)
        }
    }
    
    private func downloadFile(from signedURL: String?, with fileExtension: String?) async throws -> URL {
        guard let fileExtension = fileExtension else { throw DownloadError.assetNotSupported  }
        guard let signedUrl = signedURL else { throw DownloadError.assetSignedUrlDoesNotExist }
        guard let url = URL(string: signedUrl) else { throw DownloadError.invalidUrl }
        
        return try await self.downloadFile(from: url, with: fileExtension)
    }
    
    private func downloadFile(from url: URL, with fileExtension: String) async throws -> URL {
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
                    let lastPathComponent = tempUrl.lastPathComponent.replacingOccurrences(of: "tmp", with: fileExtension)
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
