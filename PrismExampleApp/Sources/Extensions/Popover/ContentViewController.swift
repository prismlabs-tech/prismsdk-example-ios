/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

class ContentViewController<V>: UIHostingController<V>, UIPopoverPresentationControllerDelegate where V: View {
    var isPresented: Binding<Bool>

    init(rootView: V, isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        super.init(rootView: rootView)
    }

    @MainActor @objc
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let size = self.sizeThatFits(in: UIView.layoutFittingExpandedSize)
        self.preferredContentSize = size
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.isPresented.wrappedValue = false
    }
}
