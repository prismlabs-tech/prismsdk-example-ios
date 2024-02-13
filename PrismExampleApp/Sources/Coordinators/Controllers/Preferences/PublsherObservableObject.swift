/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Combine
import Foundation

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?

    init(publisher: AnyPublisher<Void, Never>) {
        self.subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}
