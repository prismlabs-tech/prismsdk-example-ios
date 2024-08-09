/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import PrismSDK
import SceneKit
import Combine

struct ScanDetailsView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @EnvironmentObject private var scanManager: ScanManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var healthStore: HealthKitManager = HealthKitManager.shared
    
    @State private var details: ScanDetails?
    @State private var confirmDelete: Bool = false
    @State private var showToast: Bool = false
    
    var scan: Scan

    var body: some View {
        ZStack {
            VStack {
                ModelViewer(scan: self.scan)
                    .padding()
                    .frame(maxHeight: .infinity)

                MetricsListSectionView(items: self.details?.items ?? [])
            }
        }
        .background(Color.prismBase2)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(self.scan.createdAt.scanListFormatted))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        UIPasteboard.general.string = self.scan.id
                        withAnimation {
                            showToast.toggle()
                        }
                    } label: {
                        Label("ScanDetails.Metadata.ScanID.Text", systemImage: "doc.on.doc.fill")
                    }
                    
                    Button {
                        self.healthStore.write(PrismQuantityData(self.scan))
                    } label: {
                        Label("Save Health Data", systemImage: "heart.fill")
                    }

                    Button {
                        self.confirmDelete = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("More", systemImage: "ellipsis")
                }
                .foregroundColor(.prismBlue)
            }
        }
        .onAppear {
            self.fetchScanDetails()
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
                    }
                ]
            )
        }
    }
    
    private func fetchScanDetails() {
        Task {
            let client = ScanClient(client: self.apiClient)
            self.details = try await client.getDetails(for: self.scan.id)
        }
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
