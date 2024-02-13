/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct Card<Content: View>: View {

    var alignment: HorizontalAlignment = .center
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: self.alignment) {
            self.content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(color: .prismBase10, radius: 2, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.prismBase10, lineWidth: 1)
        )
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card {
            Text("Hello there")
        }
    }
}
