/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct AlwaysPopoverModifier<PopoverContent>: ViewModifier where PopoverContent: View {
    typealias UIViewType = UIView

    let isPresented: Binding<Bool>
    let contentBlock: () -> PopoverContent

    // Workaround for missing @StateObject in iOS 13.
    private struct Store {
        var anchorView = UIView()
    }

    @State private var store = Store()

    func body(content: Content) -> some View {
        if self.isPresented.wrappedValue {
            self.presentPopover()
        }

        return content.background(InternalAnchorView(uiView: self.store.anchorView))
    }

    private func presentPopover() {
        let contentController = ContentViewController(rootView: self.contentBlock(), isPresented: self.isPresented)
        contentController.modalPresentationStyle = .popover

        let view = self.store.anchorView
        guard let popover = contentController.popoverPresentationController else { return }
        popover.sourceView = view
        popover.sourceRect = view.bounds
        popover.delegate = contentController

        guard let sourceVC = view.closestVC() else { return }
        if let presentedVC = sourceVC.presentedViewController {
            presentedVC.dismiss(animated: true) {
                sourceVC.present(contentController, animated: true)
            }
        } else {
            sourceVC.present(contentController, animated: true)
        }
    }

    private struct InternalAnchorView: UIViewRepresentable {
        let uiView: UIView

        func makeUIView(context: Self.Context) -> UIViewType {
            self.uiView
        }

        func updateUIView(_ uiView: UIViewType, context: Self.Context) {}
    }
}
