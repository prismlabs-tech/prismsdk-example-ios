/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import UIKit

extension CollectionView {
    class HostedCollectionViewCell: UICollectionViewCell {
        var viewController: UIHostingController<CellContent>?

        func provide(_ content: CellContent) {
            if let viewController = self.viewController {
                viewController.rootView = content
            } else {
                let hostingController = UIHostingController(rootView: content)
                hostingController.view.backgroundColor = nil
                self.viewController = hostingController
            }
        }

        func attach(to parentController: UIViewController) {
            let hostedController = self.viewController!
            let hostedView = hostedController.view!
            let contentView = self.contentView

            parentController.addChild(hostedController)

            hostedView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostedView)
            hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            hostedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

            hostedController.didMove(toParent: parentController)
        }

        func detach() {
            let hostedController = self.viewController!
            guard hostedController.parent != nil else { return }
            let hostedView = hostedController.view!

            hostedController.willMove(toParent: nil)
            hostedView.removeFromSuperview()
            hostedController.removeFromParent()
        }
    }
}
