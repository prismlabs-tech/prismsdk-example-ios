/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SceneKit
import SwiftUI

struct ScanDetailsView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @EnvironmentObject private var scanManager: ScanManager

    @EnvironmentObject private var cache: PrismCache

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var isLoading: Bool = false
    @State private var details: ScanDetails?
    @State private var model: URL?
    @State private var stripes: URL?
    @State private var confirmDelete: Bool = false

    let scan: Scan

    var contentView: some View {
        VStack {
            if let url = self.model {
                ModelViewer(
                    model: self.sceneFrom(url),
                    stripes: self.sceneFrom(self.stripes)
                )
                .padding()
                .frame(maxHeight: .infinity)
            } else {
                self.loadingModelView
                    .frame(maxHeight: .infinity)
            }

            MetricsListSectionView(items: self.details?.items ?? [])
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }

    var loadingModelView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    var body: some View {
        VStack {
            self.contentView
        }
        .background(Color.prismBase2)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(self.scan.createdAt.scanListFormatted))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        self.confirmDelete = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .foregroundColor(.prismRed)
                } label: {
                    Label("More", systemImage: "ellipsis")
                }
                .foregroundColor(.prismBlue)
            }
        }
        .onAppear {
            self.fetchScan()
        }
        .actionSheet(isPresented: self.$confirmDelete) {
            ActionSheet(
                title: Text("ScanDeletion.Title"),
                message: Text("ScanDeletion.Message"),
                buttons: [
                    .cancel(),
                    .destructive(Text("ScanDeletion.Button.Title")) {
                        self.scanManager.remove(self.scan)
                        self.presentationMode.wrappedValue.dismiss()
                    },
                ]
            )
        }
    }

    func fetchScan() {
        Task {
            do {
                self.isLoading = true
                let client = ScanClient(client: self.apiClient)
                self.details = try await client.getDetails(for: self.scan.id)
                let urls = try await client.assetUrls(forScan: self.scan.id)
                self.model = try await self.downloadModel(urls.model, type: .model)
                // This is commented out for now as the PLY is in the wrong format.
//                self.stripes = try await self.downloadModel(urls.stripes, type: .stripes)
                try await self.downloadModel(urls.previewImage, type: .preview)
            } catch {
                print("Error getting scan details: \(error)")
            }
        }
    }

    @discardableResult
    func downloadModel(_ url: String?, type: PrismFile.File) async throws -> URL? {
        if let file = self.cache[self.scan.id, type] {
            return file
        }
        guard let url else { return self.cache[self.scan.id, type] }
        let tempFile = try await Downloader().download(url)
        self.cache[self.scan.id, type] = tempFile
        return self.cache[self.scan.id, type]
    }

    func sceneFrom(_ url: URL?) -> SCNScene? {
        guard let url else { return nil }
        return try? SCNScene(url: url)
    }
}

struct ScanDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScanDetailsView(scan: .processingPreview)
        }
        .environmentObject(ApiClient.preview)
        .environmentObject(ScanManager.preview)
        .environmentObject(PrismCache())
    }
}
