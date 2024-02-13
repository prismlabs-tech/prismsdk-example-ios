/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct HowToStep: View {
    let image: Image
    let color: Color
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top) {
            self.image
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
                .padding(15)
                .background(self.color)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(self.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(self.color)
                Text(self.subtitle)
                    .font(.body)
                    .foregroundColor(.prismBlack)
            }
        }
    }
}

struct HowToStep_Previews: PreviewProvider {
    static var previews: some View {
        HowToStep(
            image: .user,
            color: .prismPurple,
            title: "Test with long text to demo wrapping.",
            subtitle: "Description with lots of text to demo it wraps correctly."
        )
        .padding()
    }
}
