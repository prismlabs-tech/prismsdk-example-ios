/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import PrismSDK

extension ApiClient {
    static var preview: ApiClient {
        ApiClient(baseURL: nil, clientCredentials: nil)
    }

    static let shared: ApiClient = {
        ApiClient(baseURL: nil, clientCredentials: nil)
    }()
}
