/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SceneKit
import SwiftUI

struct ModelViewer: View {
    let model: SCNScene?
    let stripes: SCNScene?
    @State private var camera: Camera?

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PrismSceneView(
                model: self.model,
                stripes: self.stripes,
                stripeColor: Color.prismPink,
                camera: self.$camera
            )

            Button {
                HapticFeedback.light()
                self.camera = .default
            } label: {
                Label("ScanDetails.ModelViewer.ResetButton", systemImage: "arrow.clockwise")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.25))
            .foregroundColor(.prismBlack)
            .cornerRadius(12)
        }
    }
}

struct ModelViewer_Previews: PreviewProvider {
    static var previews: some View {
        ModelViewer(
            model: SCNScene(named: "avatar.ply"),
            stripes: SCNScene(named: "stripes_fit.ply")
        )
        .padding()
    }
}
