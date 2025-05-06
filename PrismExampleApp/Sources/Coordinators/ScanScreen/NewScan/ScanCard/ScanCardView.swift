//
//  ScanCardView.swift
//  PrismReference
//
//  Created by Anthony Castelli on 2/10/23.
//

import SwiftUI
import PrismSDK

struct ScanCardView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @Preference(\.hasScanned) private var hasScanned: Bool
    @Preference(\.lastScanId) private var lastScanId: String
    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.userWeight) private var userWeight: Int

    @AppStorage("theme") private var selectedTheme: ScanTheme = .prism

    @Binding var isPresented: Bool

    var title: some View {
        VStack(alignment: .leading) {
            Text("NewScanCard.Title", comment: "New scan title")
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            (self.subtitle + self.action)
                .onTapGesture {
                    HapticFeedback.light()
                }
        }
    }

    var subtitle: Text {
        Text("NewScanCard.Subtitle", comment: "new scan subtitle")
            .font(.body)
    }

    var action: Text {
        Text("NewScanCard.Subtitle.Action", comment: "new scan subtitle")
            .font(.body.weight(.medium))
            .underline()
    }

    var callback: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        if self.hasScanned {
                            self.title
                        } else {
                            ScanStatusView()
                        }

                        NewScanChecklist()
                            .padding(.vertical)

                        if self.hasScanned {
                            NewScanWeightView()
                        }
                    }
                    .padding()
                }
                Button {
                    HapticFeedback.light()
                    self.callback()
                } label: {
                    Text("NewScanCard.Button.Title", comment: "New scan continue button title")
                }
                .buttonStyle(PrimaryActionButtonStyle())
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.prismBase10)
                        .frame(width: 64, height: 4)
                        .padding(.bottom, 5)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.isPresented = false
                    } label: {
                        Image.close
                            .foregroundColor(.prismBlack)
                    }
                }
            }
            .applyTheme(self.selectedTheme.theme)
        }
    }
}

struct ScanCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScanCardView(isPresented: .constant(true)) { }
            .environmentObject(ApiClient.preview)
            .previewDisplayName("New Scan")
            .preference(\.hasScanned, false)

        ScanCardView(isPresented: .constant(true)) { }
            .environmentObject(ApiClient.preview)
            .previewDisplayName("Returning Scan")
            .preference(\.hasScanned, true)
    }
}
