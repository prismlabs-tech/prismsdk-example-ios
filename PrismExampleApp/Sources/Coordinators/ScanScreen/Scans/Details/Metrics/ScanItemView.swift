/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

extension LinearGradient {
    static let prismBase10Gradient = LinearGradient(
        colors: [
            Color.prismBase10,
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct ScanItemView: View {
    let scanType: ScanItemType
    let value: Double
    var isHighlighted: Bool = false

    var body: some View {
        if self.scanType == .spacer {
            Spacer()
                .frame(height: 30)
        } else {
            VStack(alignment: .leading, spacing: 0.0) {
                Text(self.scanType.name)
                    .font(.footnote.weight(.bold))
                    .foregroundColor(Color.prismBlack)
                    .padding(.bottom, 5.0)
                let (measurement, unit) = self.scanType.format(self.value)
                HStack {
                    Text(measurement)
                        .font(.title.weight(.regular))
                        .foregroundColor(Color.prismBlack) +
                        Text(unit)
                        .font(.title3.weight(.light))
                        .foregroundColor(Color.prismBlack)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .padding(.horizontal, 8.0)
            .padding(.vertical)
            .background(Color.white.cornerRadius(12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(self.isHighlighted ? LinearGradient.prismGradient : LinearGradient.prismBase10Gradient, lineWidth: self.isHighlighted ? 2 : 1)
            )
        }
    }
}

struct ScanItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ScanItemView(scanType: .bodyFat, value: 0.56, isHighlighted: true)
            ScanItemView(scanType: .weight, value: 0.56)
            ScanItemView(scanType: .leftLowerThigh, value: 0.40)
        }
    }
}
