//
//  NewScanWeightView.swift
//  PrismReference
//
//  Created by Anthony Castelli on 2/14/23.
//

import SwiftUI

struct NewScanWeightView: View {
    @State private var showPicker: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("NewScanCard.Weight", comment: "New scan weight title")
                .font(.body.weight(.bold))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            ProfileWeightContent(showPicker: self.$showPicker)
                .alwaysPopover(isPresented: self.$showPicker) {
                    WeightPicker()
                }
        }
    }
}

struct NewScanWeightView_Previews: PreviewProvider {
    static var previews: some View {
        NewScanWeightView()
    }
}
