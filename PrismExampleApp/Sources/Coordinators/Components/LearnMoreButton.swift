/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct LearnMoreButton: View {
    let title: LocalizedStringKey
    var action: () -> Void

    var body: some View {
        Button {
            self.action()
        } label: {
            VStack(alignment: .leading, spacing: 5.0) {
                Text(self.title)
                    .font(.title3.weight(.medium))
                    .multilineTextAlignment(.leading)

                HStack {
                    Text("Button.LearnMore")
                    Image.arrowRight
                    Spacer()
                }
            }
            .font(.body)
            .foregroundColor(.prismBlack)
            .frame(maxWidth: .infinity)
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.prismBase10, lineWidth: 1)
                .shadow(color: .prismBase10, radius: 2)
        )
    }
}

struct LearnMoreButton_Previews: PreviewProvider {
    static var previews: some View {
        LearnMoreButton(title: "Test") {}
    }
}
