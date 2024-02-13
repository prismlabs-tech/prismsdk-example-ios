/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct Checkmark: View {
    @Environment(\.prismThemeConfiguration) var theme: PrismThemeConfiguration

    let title: LocalizedStringKey

    var body: some View {
        HStack(alignment: .center) {
            Image.check
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(self.theme.primaryIconColor)
                .padding(3)
                .background(self.theme.iconBackgroundColor)
                .clipShape(Circle())
            Text(self.title)
        }
    }
}

struct Checkmark_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Checkmark(title: "Test")
                .applyTheme(ScanTheme.prism.theme)
            Checkmark(title: "Test")
                .applyTheme(ScanTheme.sample.theme)
        }
    }
}
