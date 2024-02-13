/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import PrismSDK
import SwiftUI

extension PrismCache {
    func image(for scanId: String) -> Image? {
        if let cache = self[scanId, .preview], let image = UIImage(contentsOfFile: cache.path) {
            return Image(uiImage: image)
        }
        return nil
    }
}

struct ScanListItemContent: View {
    @EnvironmentObject var cache: PrismCache
    @Preference(\.userSex) private var userSex: Sex?

    var weightFormat: String {
        let formatter = ScanItemType.weight.format(self.scan.weight.value)
        return "\(formatter.measurement) \(formatter.unit)"
    }

    var bodyFatPercentage: String {
        guard let value = self.scan.bodyfat?.bodyfatPercentage else { return "--%" }
        let formatter = ScanItemType.fatMassPercentage.format(value)
        return "\(formatter.measurement)\(formatter.unit)"
    }

    var leanPercentage: String {
        guard let value = self.scan.bodyfat?.leanMassPercentage else { return "--%" }
        let formatter = ScanItemType.leanMassPercentage.format(value)
        return "\(formatter.measurement)\(formatter.unit)"
    }

    let scan: Scan

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let image = self.cache.image(for: self.scan.id) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                } else {
                    Image(self.userSex == .female ? "female_avatar" : "male_avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                }
                VStack(alignment: .leading) {
                    Text(self.scan.createdAt.scanListFormatted)
                        .font(.body.weight(.bold))
                        .foregroundColor(.prismBlack)
                    Text(self.weightFormat)
                        .font(.body)
                        .foregroundColor(.prismBase50)
                    Text("ScanList.Measurements.FatLean \(self.bodyFatPercentage) \(self.leanPercentage)")
                        .font(.body)
                        .foregroundColor(.prismBase50)
                }
                Spacer()
            }
            HStack {
                Text("ScanList.ViewFullReport")
                Image.arrowRight
            }
            .font(.body.weight(.bold))
            .foregroundColor(.prismBlue)
        }
        .padding(8.0)
    }
}

struct ScanListItemContent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Card {
                ScanListItemContent(scan: .processingPreview)
            }
            Divider()
            Card {
                ScanListItemContent(scan: .processingPreview)
            }
        }
        .padding()
        .environmentObject(PrismCache())
    }
}
