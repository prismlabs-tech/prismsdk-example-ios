//
//  ProfileView.swift
//  PrismReference
//
//  Created by Anthony Castelli on 3/29/23.
//

import SwiftUI
import PrismSDK

enum ScanTheme: String, Codable, CaseIterable, Identifiable {
    case prism
    case sample

    var id: Self { self }

    var name: String {
        switch self {
        case .prism: return "Prism"
        case .sample: return "Sample"
        }
    }

    var theme: PrismThemeConfiguration {
        switch self {
        case .prism: return .default
        case .sample: return .init(
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
    @AppStorage("assetConfigId") var selectedAssetConfigId: AssetConfigId = .objTextureBased
    @AppStorage("bodyfatMethod") var selectedBodyfatMethod: BodyfatMethod = .coco_bri

    var version: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        return "Version \(version ?? "-") (\(build ?? "-"))"
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
    
    var assetConfigIdPicker: some View {
        VStack {
            Text("Assets Bundle ID:")
            
            Menu {
                Picker(selection: self.$selectedAssetConfigId, label: EmptyView()) {
                    ForEach(AssetConfigId.allCases, id: \.self) {
                        Text($0.name)
                            .tag($0)
                    }
                }
                .pickerStyle(.automatic)
            } label: {
                HStack {
                    Text(self.selectedAssetConfigId.name)
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
    
    var bodyfatMethodPicker: some View {
        VStack {
            HStack {
                InfoButton(
                    info: "Changing the body composition method will only apply to new scans. Existing scans will remain with method set at the time of the scan."
                ).lineLimit(nil)
                Text("Body fat method:")
            }
            
            Menu {
                Picker(selection: self.$selectedBodyfatMethod, label: EmptyView()) {
                    ForEach(BodyfatMethod.allCases, id: \.self) {
                        Text($0.name)
                            .tag($0)
                    }
                }
                .pickerStyle(.automatic)
            } label: {
                VStack {
                    HStack {
                        Text(self.selectedBodyfatMethod.name)
                            .font(.body.weight(.bold))
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.bold))
                    }
                }
                .font(.body.weight(.medium))
                .foregroundColor(.prismBlack)
            }
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
                .padding(.horizontal)

                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                
                TermsConsentCheckbox(agreedToTerms: self.$agreedToSharingData)

                Divider()
                    .padding()

                self.themePicker
                
                Divider()
                    .padding()
                
                self.bodyfatMethodPicker
        
                    Divider()
                        .padding()
                    
                    self.assetConfigIdPicker
                    
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
                _ = try await client.update(user: data)
                self.isPresented = false
            } catch {
                print("Error updating user: \(error)")
                self.isPresented = false
            }
        }
    }

    func logoutUser() {
        Preferences.reset()
        
        // First we remove the cached scans dirs
        self.cache.clear()
        
        // Then we remove the apps "Prism" document dir and reset the state
        // of the scan manager
        self.scanManager.clearDocuments()
        self.scanManager.resetScanList()
        
        self.onboardingComplete = false
        self.isPresented = false
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
