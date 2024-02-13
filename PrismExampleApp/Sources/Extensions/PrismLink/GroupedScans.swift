/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import PrismSDK

struct GroupedScans: Identifiable, Codable {
    let month: Int
    let year: Int
    let scans: [Scan]

    var date: Date {
        Date(year: self.year, month: self.month, day: 1)
    }

    var id: Date { self.date }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self.date)
    }

    init(date: Date, scans: [Scan]) {
        self.month = date.month
        self.year = date.year
        self.scans = scans.sorted(by: \.createdAt, isAscending: false)
    }

    init(date: (month: Int, year: Int), scans: [Scan]) {
        self.month = date.month
        self.year = date.year
        self.scans = scans.sorted(by: \.createdAt, isAscending: false)
    }

    init(date: String, scans: [Scan]) {
        let strings = date.split(separator: ":")
        self.month = Int(strings.first!)!
        self.year = Int(strings.last!)!
        self.scans = scans.sorted(by: \.createdAt, isAscending: false)
    }
}

extension GroupedScans: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.month)
        hasher.combine(self.year)
        hasher.combine(self.scans)
    }
}

extension GroupedScans: Equatable {
    static func == (lhs: GroupedScans, rhs: GroupedScans) -> Bool {
        lhs.id == rhs.id &&
            lhs.month == rhs.month &&
            lhs.year == rhs.year &&
            lhs.scans == rhs.scans
    }
}
