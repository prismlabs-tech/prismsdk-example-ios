/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI
import SwipeCell

struct ScansListView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @EnvironmentObject private var scanManager: ScanManager
    @EnvironmentObject private var uploader: RecordingUploader

    @Preference(\.onboardingComplete) private var onboardingComplete: Bool
    @Preference(\.userEmail) private var userEmail: String

    @Binding var showNewScan: Bool
    @AppStorage("theme") private var selectedTheme: ScanTheme = .prism

    @State private var presentNewScanCard: Bool = false
    @State private var isShowingBanner: Bool = false
    @State private var isShowingProfile: Bool = false
    @State private var confirmDelete: Bool = false
    @State private var scanToDelete: Scan?

    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(self.scanManager.scans, id: \.self) { group in
                    Section(
                        header: Text(group.formattedDate)
                            .font(.title3.weight(.bold))
                            .padding(.vertical)
                    ) {
                        ForEach(group.scans, id: \.self) { scan in
                            ScanListItemView(scan: scan)
                                .tag(scan)
                                .contextMenu {
                                    if scan.status != .processing {
                                        Button {
                                            self.scanToDelete = scan
                                            self.confirmDelete = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }

                                        Button {
                                            UIPasteboard.general.string = scan.id
                                        } label: {
                                            Label("Scan ID", systemImage: "doc.on.doc.fill")
                                        }
                                    }
                                }
                                .swipeCell(
                                    cellPosition: .right,
                                    leftSlot: nil,
                                    rightSlot: SwipeCellSlot(
                                        slots: [
                                            SwipeCellButton(
                                                buttonStyle: .view,
                                                title: "",
                                                systemImage: "",
                                                titleColor: .white,
                                                imageColor: .white,
                                                view: {
                                                    AnyView(
                                                        VStack {
                                                            Image(systemName: "trash")
                                                                .foregroundColor(.white)
                                                                .font(.body)
                                                                .padding(15)
                                                                .background(Color.red)
                                                                .cornerRadius(30)
                                                        }
                                                    )
                                                },
                                                backgroundColor: .clear,
                                                action: {
                                                    self.scanToDelete = scan
                                                    self.confirmDelete = true
                                                },
                                                feedback: true
                                            )
                                        ],
                                        slotStyle: .normal,
                                        buttonWidth: 60
                                    ),
                                    disable: scan.status == .processing
                                )
                                .dismissSwipeCellForScrollViewForLazyVStack()
                        }
                    }
                    .tag(group)
                }
                if self.scanManager.shouldPaginate {
                    HStack {
                        Spacer()
                        ProgressView()
                            .onAppear(perform: self.fetchScans)
                        Spacer()
                    }
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
        .background(Color.prismBase2.ignoresSafeArea())
        .actionSheet(isPresented: self.$confirmDelete) {
            ActionSheet(
                title: Text("ScanDeletion.Title"),
                message: Text("ScanDeletion.Message"),
                buttons: [
                    .cancel(),
                    .destructive(Text("ScanDeletion.Button.Title")) {
                        guard let scan = self.scanToDelete else { return }
                        self.scanManager.remove(scan)
                    }
                ]
            )
        }
    }

    var bottomContent: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Divider()
                if self.isShowingBanner {
                    BottomBannerView(message: "ScanList.Uploading.Banner.Message") {
                        self.isShowingBanner = false
                    }
                    .transition(.slide)
                }
                Button {
                    HapticFeedback.light()
                    self.presentNewScanCard = true
                } label: {
                    Text("Button.NewScan")
                }
                .buttonStyle(PrimaryActionButtonStyle())
                .padding()
                .padding(.bottom, 25)
                .disabled(self.uploader.isUploading)
            }
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    var body: some View {
        ZStack {
            self.scrollView
            self.bottomContent
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.isShowingProfile = true
                } label: {
                    Image(systemName: "person.circle")
                        .foregroundColor(.prismBlue)
                }
            }
        }
        .navigationTitle("ScanList.Title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: self.$presentNewScanCard) {
            NewScanCardView(isPresented: self.$presentNewScanCard) {
                self.presentNewScanCard = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                    self.showNewScan = true
                }
            }
        }
        .sheet(isPresented: self.$isShowingProfile) {
            ProfileView(isPresented: self.$isShowingProfile)
        }
        .onChange(of: self.onboardingComplete) { newValue in
            guard newValue else { return }
            self.fetchScans()
        }
        .onChange(of: self.uploader.isUploading) { newValue in
            self.isShowingBanner = newValue
        }
        .applyTheme(self.selectedTheme.theme)
    }

    func fetchScans() {
        guard !self.userEmail.isEmpty else { return }
        Task {
            do {
                try await self.scanManager.fetchMoreScans()
            } catch {
                print(error)
            }
        }
    }
}

struct ScansListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScansListView(showNewScan: .constant(false))
        }
        .environmentObject(ApiClient.preview)
        .environmentObject(ScanManager.preview)
        .environmentObject(RecordingUploader.preview)
        .environmentObject(PrismCache())
    }
}
