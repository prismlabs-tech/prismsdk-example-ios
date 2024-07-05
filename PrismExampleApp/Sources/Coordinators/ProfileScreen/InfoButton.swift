//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//
import SwiftUI

struct InfoButton: View {
    @State var info: String
    @State private var showingPopover = false

    var body: some View {
        Button {
            showingPopover = true
        } label: {
            Image(systemName: "info.circle")
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $showingPopover) {
            Text(self.info)
                .font(.headline)
                .padding()
        
            Button("Close Info") {
                showingPopover = false
            }
        }
    }
}

struct InfoButton_Previews: PreviewProvider {
    static var previews: some View {
        InfoButton(info: "Sample Text")
    }
}

