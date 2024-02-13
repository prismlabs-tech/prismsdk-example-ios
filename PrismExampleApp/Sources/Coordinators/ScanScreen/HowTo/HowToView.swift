/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct HowToView: View {

    @Binding var isPresented: Bool
    let isDoneButton: Bool

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 1)

            ScrollView {
                VStack {
                    NavigationTitle(
                        title: "HowTo.Title",
                        titleComment: "How To title",
                        subtitle: "HowTo.Subtitle",
                        subtitleComment: "How To subtitle"
                    )
                    HowToSteps()
                        .padding(.horizontal)
                }
            }
            Button {
                HapticFeedback.light()
                self.isPresented = false
            } label: {
                if self.isDoneButton {
                    Text("Button.Done", comment: "How To continue button title")
                } else {
                    Text("Button.Continue", comment: "How To continue button title")
                }
            }
            .buttonStyle(PrimaryActionButtonStyle())
            .padding()
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}

struct HowToView_Previews: PreviewProvider {
    static var previews: some View {
        HowToView(
            isPresented: .constant(true),
            isDoneButton: false
        )
    }
}
