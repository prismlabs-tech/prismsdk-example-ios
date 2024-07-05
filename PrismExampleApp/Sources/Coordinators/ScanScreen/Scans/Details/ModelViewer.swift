/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import SceneKit
import PrismSDK

struct ModelViewer: View {
    
    @EnvironmentObject private var apiClient: ApiClient
    @EnvironmentObject private var cache: PrismCache
        
    @State private var model: URL?
    @State private var stripes: URL?
    @State private var texture: URL?
    @State private var material: URL?
    @State private var camera: Camera?
    @State private var isLoading: Bool = false
    
    var scan: Scan

    var loadingModelView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let model = model {
                PrismSceneView(
                    model: self.sceneFrom(model),
                    stripes: self.sceneFrom(self.stripes),
                    stripeColor: Color.prismPink,
                    camera: self.$camera
                )
            } else {
                self.loadingModelView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Button {
                HapticFeedback.light()
                self.camera = .default
            } label: {
                Label("ScanDetails.ModelViewer.ResetButton", systemImage: "arrow.clockwise")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.25))
            .foregroundColor(.prismBlack)
            .cornerRadius(12)
        }
        .onAppear {
            self.fetchScan()
        }
    }
    
    func fetchScan() {
        Task {
            do {
                self.isLoading = true
                let client = ScanClient(client: self.apiClient)
                let urls = try await client.assetUrls(forScan: self.scan.id)
                
                // For texture based assets the order of how assets
                //  are downloaded is important as there exists a
                //  strong reference between the model and texture/material
                //  file
                self.texture = try await self.downloadAssetAndCacheTheAsset(urls.texture, type: .texture)
                self.material = try await self.downloadAssetAndCacheTheAsset(urls.material, type: .material)
                self.model = try await self.downloadAssetAndCacheTheAsset(urls.model, type: .model)

                
                // Stripes currently not supported
                // self.stripes = try await self.downloadModel(urls.stripes, type: .stripes)
                
                try await self.downloadAssetAndCacheTheAsset(urls.previewImage, type: .preview)
            } catch {
                print("Error getting scan details: \(error)")
            }
        }
    }
    
    @discardableResult
    func downloadAssetAndCacheTheAsset(_ url: String?, type: PrismFile.File) async throws -> URL? {
        if let file = self.cache[self.scan.id, type] {
            return file
        }
        guard let url else { return self.cache[self.scan.id, type] }
        
        // There can be scan records prior the assetConfigId was added (they are the ply file only scans)
        let assetConfigId = AssetConfigId(rawValue: self.scan.assetConfigId) ?? .singlePlyOnly
        
        let downloader = Downloader(assetConfigId: assetConfigId)
        let tempFile = await downloader.download(file: type, from: url)
        self.cache[self.scan.id, type] = tempFile
        return self.cache[self.scan.id, type]
    }

    private func sceneFrom(_ url: URL?) -> SCNScene? {
        guard let url else { return nil }
        return try? SCNScene(url: url)
    }
}

struct ModelViewer_Previews: PreviewProvider {
    static var previews: some View {
        ModelViewer(scan: .processingPreview)
            .environmentObject(ApiClient.preview)
    }
}
