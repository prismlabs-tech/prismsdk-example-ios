/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ProfileEmailSection: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Preference(\.userEmail) private var userEmail: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Profile.Form.Email", comment: "Email form field label")
                .font(.body)
                .fontWeight(.bold)

            TextField("Profile.Form.EmailPlaceholder", text: self.$userEmail)
                .keyboardType(.emailAddress)
                .textCase(.lowercase)
                .autocapitalization(.none)
                .font(.body)
                .foregroundColor(.prismBlack)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16.0)
                .padding(.horizontal, 16.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.prismBase30, lineWidth: 1)
                )
                .disabled(!self.isEnabled)
                .opacity(self.isEnabled ? 1.0 : 0.5)
        }
    }
}

struct ProfileEmailSection_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ProfileEmailSection()
            ProfileEmailSection()
                .environment(\.isEnabled, false)
        }
        .padding()
    }
}
