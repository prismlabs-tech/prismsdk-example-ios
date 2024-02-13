/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

struct FAQList: View {
    let title: LocalizedStringKey
    let items: [FAQItem]

    var body: some View {
        EmptyView()
        // We are completely removing the FAQ View for now.
//        Card(alignment: .leading) {
//            Text(self.title)
//                .font(.title3.weight(.medium))
//                .multilineTextAlignment(.leading)
//
//            ForEach(self.items) { item in
//                LearnMoreButton(title: item.title) {
//
//                }
//            }
//
//            Button {
//
//            } label: {
//                HStack {
//                    Text("Button.ShowMore")
//                    Image.plus
//                    Spacer()
//                }
//                .font(.body)
//                .foregroundColor(.prismBase50)
//                .frame(maxWidth: .infinity)
//                .padding()
//            }
//        }
    }
}

struct FAQList_Previews: PreviewProvider {
    static var previews: some View {
        FAQList(
            title: "This is a test title",
            items: [
                .init(title: "Test"),
            ]
        )
        .padding()
    }
}
