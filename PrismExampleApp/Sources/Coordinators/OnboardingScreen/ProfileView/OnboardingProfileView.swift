//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import SwiftUI
import PrismSDK

struct OnboardingProfileView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.userSex) private var userSex: Sex?
    @Preference(\.userHeight) private var userHeight: Int
    @Preference(\.userWeight) private var userWeight: Int
    @Preference(\.userAge) private var userAge: Int

    @State private var action: Int? = 0

    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 1)

                ScrollView {
                    NavigationTitle(
                        title: "Profile.Title",
                        titleComment: "Profile title",
                        subtitle: "Profile.Subtitle",
                        subtitleComment: "Profile subtitle"
                    )
                    .padding(.horizontal)
                    .padding(.top, 15)
                    .padding(.bottom, 25)

                    VStack(spacing: 20) {
                        ProfileEmailSection()
                        ProfileSexSection()
                        ProfileHeightSection()
                        ProfileWeightSection()
                        ProfileAgeSection()
                    }
                    .padding()

                    NavigationLink(destination: TermsAndConditionsView(isPresented: self.$isPresented), tag: 1, selection: self.$action) {
                        EmptyView()
                    }
                }
                Button {
                    HapticFeedback.light()
                    self.updateUser()
                } label: {
                    Text("Button.Continue", comment: "Profile continue button title")
                }
                .buttonStyle(PrimaryActionButtonStyle())
                .padding()
                .disabled(self.userSex == nil || self.userEmail.isEmpty)
            }
        }
    }

    func updateUser() {
        let data = NewUser(
            token: self.userEmail.lowercased(),
            email: self.userEmail.lowercased(),
            sex: self.userSex ?? .neutral,
            usaResidence: nil,
            birthDate: Date(fromAge: self.userAge),
            weight: .init(value: Double(self.userWeight), unit: .pounds),
            height: .init(value: Double(self.userHeight), unit: .inches),
            termsOfService: TermsOfService(accepted: true, version: nil)
        )
        Task {
            do {
                let client = UserClient(client: self.apiClient)
                _ = try await client.create(user: data)
                self.action = 1
            } catch {
                print("Error creating user: \(error)")
            }
        }
    }
}

 struct OnboardingProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingProfileView(isPresented: .constant(true))
            .environmentObject(ApiClient.preview)
    }
 }
