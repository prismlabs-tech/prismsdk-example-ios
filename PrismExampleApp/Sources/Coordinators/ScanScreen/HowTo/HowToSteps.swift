/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct HowToSteps: View {
    @State private var show: Bool = false

    let transition = AnyTransition.asymmetric(insertion: .slide, removal: .slide).combined(with: .opacity)

    var body: some View {
        VStack(alignment: .leading) {
            HowToStep(
                image: .user,
                color: .prismPurple,
                title: "HowTo.PrepareYourselfTitle",
                subtitle: "HowTo.PrepareYourselfDescription"
            )
            .padding()
            .offset(x: self.show ? 0 : 5)
            .scaleEffect(self.show ? 1 : 0.9, anchor: .bottomLeading)
            .animation(.interpolatingSpring(stiffness: 170, damping: 8), value: self.show)

            HowToStep(
                image: .ruler,
                color: .prismBlue,
                title: "HowTo.PrepareSpaceTitle",
                subtitle: "HowTo.PrepareSpaceDescription"
            )
            .padding()
            .offset(x: self.show ? 0 : 5)
            .scaleEffect(self.show ? 1 : 0.9, anchor: .bottom)
            .rotationEffect(.degrees(self.show ? 0 : -5))
            .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.1), value: self.show)

            HowToStep(
                image: .phone,
                color: .prismTurquoise,
                title: "HowTo.PreparePhoneTitle",
                subtitle: "HowTo.PreparePhoneDescription"
            )
            .padding()
            .scaleEffect(self.show ? 1 : 0.9, anchor: .topTrailing)
            .rotationEffect(.degrees(self.show ? 0 : 5))
            .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.2), value: self.show)

            HowToStep(
                image: .bodyScan,
                color: .prismGreen,
                title: "HowTo.StartTitle",
                subtitle: "HowTo.StartDescription"
            )
            .padding()
            .scaleEffect(self.show ? 1 : 0.9, anchor: .bottom)
            .animation(.interpolatingSpring(stiffness: 170, damping: 8).delay(0.3), value: self.show)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.prismBase10, lineWidth: 1)
                .shadow(color: .prismBase10, radius: 2)
        )
        .onAppear {
            withAnimation {
                self.show = true
            }
        }
    }
}

struct HowToSteps_Previews: PreviewProvider {
    static var previews: some View {
        HowToSteps()
    }
}
