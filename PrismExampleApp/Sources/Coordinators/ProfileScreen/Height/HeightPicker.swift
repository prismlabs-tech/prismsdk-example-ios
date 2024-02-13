/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct HeightPicker: View {
    @State private var feet = 5
    @State private var inches = 9

    @Preference(\.userHeight) private var height: Int

    var body: some View {
        HeightPickerView(feet: self.$feet, inches: self.$inches)
            .onChange(of: self.feet) { newValue in
                self.height = self.inches + (newValue * 12)
            }
            .onChange(of: self.inches) { newValue in
                self.height = newValue + (self.feet * 12)
            }
            .onChange(of: self.height) { newValue in
                self.feet = Int(newValue / 12)
                self.inches = Int(newValue - (self.feet * 12))
            }
            .onAppear {
                self.feet = Int(self.height / 12)
                self.inches = Int(self.height - (self.feet * 12))
            }
    }
}

struct HeightPicker_Previews: PreviewProvider {
    static var previews: some View {
        HeightPicker()
            .padding()
    }
}
