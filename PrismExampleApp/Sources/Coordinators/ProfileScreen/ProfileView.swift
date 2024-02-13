/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

enum ScanTheme: String, Codable, CaseIterable, Identifiable {
    case prism
    case sample

    var id: Self { self }

    var name: String {
        switch self {
        case .prism: "Prism"
        case .sample: "Sample"
        }
    }

    var theme: PrismThemeConfiguration {
        switch self {
        case .prism: .default
        case .sample: .init(
                primaryColor: Color(red: 0.125, green: 0.141, blue: 0.176),
                successColor: Color(red: 0.494, green: 0.789, blue: 0.497),
                errorColor: Color(red: 0.881, green: 0.32, blue: 0.278),
                primaryIconColor: Color(red: 0.125, green: 0.141, blue: 0.176),
                secondaryIconColor: Color(red: 1, green: 1, blue: 1),
                iconBackgroundColor: Color(red: 0.769, green: 0.776, blue: 0.8),
                backgroundColor: Color(red: 0.914, green: 0.914, blue: 0.922),
                secondaryBackgroundColor: Color(red: 0.6, green: 0.624, blue: 0.675),
                outlineGradient: LinearGradient(
                    colors: [.clear],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                titleTextColor: Color(red: 0.125, green: 0.141, blue: 0.176),
                textColor: Color(red: 0.125, green: 0.141, blue: 0.176),
                buttonTextColor: .white,
                primaryButtonCornerRadius: 30.0,
                smallButtonCornerRadius: 24.0,
                cardCornerRadius: 24.0,
                sheetCornerRadius: 24.0
            )
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var apiClient: ApiClient
    @EnvironmentObject private var scanManager: ScanManager

    @EnvironmentObject private var cache: PrismCache

    @Preference(\.userEmail) private var userEmail: String
    @Preference(\.userSex) private var userSex: Sex?
    @Preference(\.userHeight) private var userHeight: Int
    @Preference(\.userWeight) private var userWeight: Int
    @Preference(\.userAge) private var userAge: Int
    @Preference(\.onboardingComplete) private var onboardingComplete: Bool
    @Preference(\.agreedToSharingData) private var agreedToSharingData: Bool

    @Binding var isPresented: Bool
    @AppStorage("theme") var selectedTheme: ScanTheme = .prism

    var version: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return "Version \(version!) (\(build!))"
    }

    var themePicker: some View {
        HStack {
            Spacer()
            Menu {
                Picker(selection: self.$selectedTheme, label: EmptyView()) {
                    ForEach(ScanTheme.allCases, id: \.self) {
                        Text($0.name)
                            .tag($0)
                    }
                }
                .pickerStyle(.automatic)
            } label: {
                HStack {
                    Text("Theme:")
                    Text(self.selectedTheme.name)
                        .font(.body.weight(.bold))
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                }
                .font(.body.weight(.medium))
                .foregroundColor(.prismBlack)
            }
            Spacer()
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        ProfileEmailSection()
                            .disabled(true)
                        ProfileSexSection()
                        ProfileHeightSection()
                        ProfileWeightSection()
                        ProfileAgeSection()
                    }
                    .padding()

                    Divider()
                        .padding()

                    HStack {
                        Checkbox(value: self.$agreedToSharingData, title: "Terms.DataSharing.Checkbox.Title")
                        Spacer()
                    }
                    .padding(.horizontal)

                    Divider()
                        .padding()

                    self.themePicker

                    Divider()
                        .padding()
                    Text(self.version)
                        .foregroundColor(.gray)
                        .padding()
                    Button {
                        HapticFeedback.light()
                        self.logoutUser()
                    } label: {
                        Text("Button.Logout", comment: "Profile logout button title")
                    }
                    .buttonStyle(PrimaryActionButtonStyle())
                    .padding()
                    Text("Profile.LogoutInformation")
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Profile.NavigationBar.Title")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Profile.DoneButton.Title") {
                        self.updateUser()
                    }
                }
            }
            .applyTheme(self.selectedTheme.theme)
        }
    }

    func updateUser() {
        let data = ExistingUser(
            token: self.userEmail.lowercased(),
            email: self.userEmail.lowercased(),
            sex: self.userSex ?? .neutral,
            birthDate: Date(fromAge: self.userAge),
            weight: .init(value: Double(self.userWeight), unit: .pounds),
            height: .init(value: Double(self.userHeight), unit: .inches),
            researchConsent: self.agreedToSharingData
        )
        Task {
            do {
                let client = UserClient(client: self.apiClient)
                let _ = try await client.update(user: data)
                self.isPresented = false
            } catch {
                print("Error updating user: \(error)")
                self.isPresented = false
            }
        }
    }

    func logoutUser() {
        Preferences.reset()
        self.scanManager.clearDocuments()
        self.scanManager.resetScanList()
        self.onboardingComplete = false

        self.isPresented = false
        self.cache.clear()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isPresented: .constant(true))
            .environmentObject(ApiClient.preview)
            .environmentObject(ScanManager.preview)
            .environmentObject(PrismCache())
    }
}
