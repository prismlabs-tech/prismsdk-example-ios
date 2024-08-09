//
//  Copyright (c) Prismlabs, Inc. and affiliates.
//  All rights reserved.
//
//  This source code is licensed under the license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import HealthKit
import PrismSDK


class PrismQuantityData {
    
    let scan: Scan
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
        
    var height: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.height),
            quantity: HKQuantity(
                unit: scan.height.healthKitUnit ,
                doubleValue: scan.height.value
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
    
    var weight: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(
                unit: scan.weight.healthKitUnit ,
                // The HKUnit will convert the value to grams, to
                // keep it in kg we need to multiply it by 1000
                doubleValue: scan.weight.value * 1000
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
    
    var bmi: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.bodyMassIndex),
            quantity: HKQuantity(
                unit: .count(),
                // Currently the response weight is in kg and the height is in meters
                doubleValue: scan.weight.value / pow(scan.height.value, 2)
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
    
    var leanBodyMass: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.leanBodyMass),
            quantity: HKQuantity(
                unit: scan.weight.healthKitUnit,
                // The HKUnit will convert the value to grams, to
                // keep it in kg we need to multiply it by 1000
                doubleValue: (scan.bodyfat?.leanMass ?? 0.0) * 1000
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
     
    var bodyFatPercentage: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.bodyFatPercentage),
            quantity: HKQuantity(
                unit: .percent(),
                // The response percentage is between 0 and 100, but
                //  HealthKit requires a value between 0 and 1
                doubleValue: (scan.bodyfat?.bodyfatPercentage ?? 0.0) / 100
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
    
    var waistCircumference: HKQuantitySample {
        HKQuantitySample(
            type: HKQuantityType(.waistCircumference),
            quantity: HKQuantity(
                unit: scan.height.healthKitUnit,
                doubleValue: scan.measurements?.waistFit ?? 0.0
            ),
            start: scan.createdAt,
            end: scan.createdAt
        )
    }
    
    init(_ scan: Scan) {
        self.scan = scan
    }
    
    func toList() -> [HKQuantitySample] {
        [
            self.height,
            self.weight,
            self.bmi,
            self.leanBodyMass,
            self.bodyFatPercentage,
            self.waistCircumference
        ]
    }
}

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    var supportedQuantityTypeData: Set<HKQuantityType> {
        [
            HKQuantityType(.height),
            HKQuantityType(.bodyMass),
            HKQuantityType(.bodyMassIndex),
            HKQuantityType(.leanBodyMass),
            HKQuantityType(.bodyFatPercentage),
            HKQuantityType(.waistCircumference)
        ]
    }
                
    func write(_ data: PrismQuantityData) {
        self.healthStore.requestAuthorization(toShare: supportedQuantityTypeData, read: nil) { success, error in
            if let error = error {
                print("[ERROR] Health Store Authorization failed: \(error)")
                return
            }
            
            for sample in data.toList() {
                self.write(sample)
            }
        }
    }
    
    func write(_ sample: HKQuantitySample) {
        let sampleType = sample.quantityType
        let predicate = NSPredicate(format: "startDate == %@", sample.startDate as CVarArg)
        let limit = 1
        
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: limit,
            sortDescriptors: nil,
            resultsHandler: { query, samples, error in
                if let error = error {
                    print("[ERROR] Health Store query failed: \(error)")
                    return
                }
                
                guard let samples = samples, samples.isEmpty
                else {
                    print("[INFO] Sample \(sample) exists in Health Store")
                    return
                }
                
                self.healthStore.save([sample]) { success, error in
                    if let error = error {
                        print("[ERROR] Health Store data save failed: \(error)")
                        return
                    } else {
                        print("[INFO] Sample \(sample) saved in Health Store")
                    }
                }
            }
        )
        
        self.healthStore.execute(query)
    }
}
