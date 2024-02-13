/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct ProfileSexSection: View {
    @Preference(\.userSex) private var userSex: Sex?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Profile.Form.Sex", comment: "Sex form field label")
                .font(.body)
                .fontWeight(.bold)

            ProfileSexPicker(selectedSex: self.$userSex)
        }
    }
}

struct ProfileSexSection_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSexSection()
    }
}
