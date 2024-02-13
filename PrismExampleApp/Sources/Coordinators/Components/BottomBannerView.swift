/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct BottomBannerView: View {
    @GestureState private var isTapped: Bool = false

    let message: LocalizedStringKey
    var onTap: () -> Void

    var tapGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating(self.$isTapped) { _, isTapped, _ in
                isTapped = true
            }
            .onEnded { _ in
                self.onTap()
            }
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image.close
                        .foregroundColor(Color.prismBlack)
                    Spacer()
                }
                Text(self.message)
                    .foregroundColor(Color.prismBlack)
            }
            .padding()

            LinearGradient.prismGradient
                .frame(height: 2)
        }
        .background(Color.prismYellow.opacity(self.isTapped ? 1.0 : 0.2))
        .gesture(self.tapGesture)
    }
}

struct BottomBannerView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBannerView(message: "This is a very long test message for the banner. We want to see it expand and what happens here.", onTap: {})
    }
}
