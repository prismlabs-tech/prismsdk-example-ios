/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct NavigationTitle: View {
    let title: LocalizedStringKey
    let titleComment: StaticString?

    let subtitle: LocalizedStringKey
    let subtitleComment: StaticString?

    var body: some View {
        VStack {
            Text(self.title, comment: self.titleComment)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(self.subtitle, comment: self.subtitleComment)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct NavigationTitle_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTitle(
            title: "Testing 123",
            titleComment: "A comment",
            subtitle: "Subtitle",
            subtitleComment: "Subtitle"
        )
    }
}
