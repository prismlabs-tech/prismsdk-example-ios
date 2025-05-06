/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import PrismSDK

struct TermsAndConditionsView: View {
    @EnvironmentObject private var apiClient: ApiClient

    @Preference(\.agreedToTerms) private var agreedToTerms: Bool
    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.onboardingComplete) private var onboardingComplete: Bool

    @State private var viewedTerms: Bool = false
    @State private var presentingSafariView: Bool = false
    @State private var action: Int? = 0

    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Terms.Consent.Title")
                .font(.title2)
                .bold()
                .padding()
                    
            Text("Terms.Consent.Note")
                .multilineTextAlignment(.leading)
                .padding()
            
            Spacer()
            
            TermsConsentCheckbox(agreedToTerms: self.$agreedToTerms)
            
            Spacer()
            
            Button {
                HapticFeedback.light()
                self.action = 1
                self.updateUser()
            } label: {
                Text("Button.Continue", comment: "Profile continue button title")
            }
            .buttonStyle(PrimaryActionButtonStyle())
            .padding()
            .disabled(!self.agreedToTerms)
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .onChange(of: onboardingComplete) { doneOnboarding in
            if doneOnboarding {
                self.isPresented = !doneOnboarding
            }
        }
    }

    func updateUser() {
        let data = ExistingUser(
            token: self.userEmail.lowercased(),
            researchConsent: self.agreedToTerms
        )

        Task {
            do {
                _ = try await UserClient(client: self.apiClient).update(user: data)
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
