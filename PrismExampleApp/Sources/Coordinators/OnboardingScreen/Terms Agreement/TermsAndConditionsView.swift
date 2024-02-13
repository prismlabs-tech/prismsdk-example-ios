/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import BetterSafariView
import PrismSDK
import SwiftUI

struct TermsAndConditionsView: View {
    @EnvironmentObject private var apiClient: ApiClient

    @Preference(\.agreedToTerms) private var agreedToTerms: Bool
    @Preference(\.agreedToSharingData) private var agreedToSharingData: Bool
    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.onboardingComplete) private var onboardingComplete: Bool

    @State private var viewedTerms: Bool = false
    @State private var presentingSafariView: Bool = false
    @State private var action: Int? = 0

    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            NavigationTitle(
                title: "Terms.Title",
                titleComment: "Terms and Conditions title",
                subtitle: "Terms.Subtitle",
                subtitleComment: "Terms and Conditions subtitle"
            )
            .padding(.horizontal)

            LearnMoreButton(title: "Terms.Button.Title") {
                self.presentingSafariView = true
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 10)

            HStack {
                Checkbox(value: self.$agreedToTerms, title: "Terms.Checkbox.Title")
                    .disabled(!self.viewedTerms && !self.agreedToTerms)
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Checkbox(value: self.$agreedToSharingData, title: "Terms.DataSharing.Checkbox.Title")
                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            NavigationLink(
                destination: HowToView(isPresented: self.$isPresented, isDoneButton: false),
                tag: 1,
                selection: self.$action
            ) {
                EmptyView()
            }
            Button {
                HapticFeedback.light()
                self.action = 1
                self.updateUser()
            } label: {
                Text("Button.Continue", comment: "Profile continue button title")
            }
            .buttonStyle(PrimaryActionButtonStyle())
            .padding()
            .disabled(!self.viewedTerms)
            .disabled(!self.agreedToTerms)
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .safariView(isPresented: self.$presentingSafariView) {
            self.viewedTerms = true
        } content: {
            SafariView(
                url: URL(string: "https://www.prismlabs.tech/privacy")!,
                configuration: SafariView.Configuration(
                    entersReaderIfAvailable: false,
                    barCollapsingEnabled: true
                )
            )
            .preferredControlAccentColor(.accentColor)
            .dismissButtonStyle(.done)
        }
    }

    func updateUser() {
        let data = ExistingUser(
            token: self.userEmail.lowercased(),
            researchConsent: self.agreedToSharingData
        )

        Task {
            do {
                let _ = try await UserClient(client: self.apiClient).update(user: data)
                self.onboardingComplete = true
            } catch {
                print("Error updating user: \(error)")
                self.onboardingComplete = true
            }
        }
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsAndConditionsView(isPresented: .constant(true))
        }
    }
}
