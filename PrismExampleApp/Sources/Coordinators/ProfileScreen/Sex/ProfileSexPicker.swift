/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ProfileSexPicker: View {
    @Environment(\.prismThemeConfiguration) private var theme: PrismThemeConfiguration
    @Binding var selectedSex: Sex?

    func cornersToRound() -> UIRectCorner {
        guard let selectedSex = self.selectedSex else { return [] }
        switch selectedSex {
        case .male: return [.topLeft, .bottomLeft]
        case .female: return []
        case .neutral: return [.topRight, .bottomRight]
        @unknown default:
            fatalError()
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Sex.allCases) { sex in
                let isSelected = self.selectedSex == sex
                ZStack {
                    Rectangle()
                        .fill(Color.clear)

                    Rectangle()
                        .fill(self.theme.primaryColor)
                        .cornerRadius(self.theme.primaryButtonCornerRadius, corners: self.cornersToRound())
                        .opacity(isSelected ? 1 : 0.01)
                        .onTapGesture {
                            HapticFeedback.light()
                            withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 2, blendDuration: 0.5)) {
                                self.selectedSex = sex
                            }
                        }
                }
                .overlay(
                    Text(sex.name)
                        .fontWeight(isSelected ? .bold : .regular)
                        .foregroundColor(isSelected ? self.theme.secondaryIconColor : .gray)
                )
            }
        }
        .frame(height: 60)
        .cornerRadius(self.theme.primaryButtonCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: self.theme.primaryButtonCornerRadius)
                .stroke(self.theme.borderColor, lineWidth: 1)
        )
    }
}

struct ProfileSexPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfileSexPicker(selectedSex: .constant(.male))
                .padding()
        }
    }
}
