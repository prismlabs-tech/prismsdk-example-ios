//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import SwiftUI

struct TermsConsentCheckbox: View {
    
    @Binding var agreedToTerms: Bool
    
    let linkText = "Prism's policy"
    let link = "https://www.prismlabs.tech/privacy"
    
    var body: some View {
        HStack(alignment: .top) {
            let checkboxText = NSLocalizedString("Terms.Consent.Checkbox", comment: "")
            let checkboxTextWithLink = String(format: checkboxText, "[\(self.linkText)](\(self.link))")

            Checkbox(value: self.$agreedToTerms, title: "")
            Text(.init(checkboxTextWithLink))
        }
        .padding()
        
    }
}

#Preview {
    TermsConsentCheckbox(agreedToTerms: .constant(false))
}
