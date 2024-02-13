/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

struct HeightPickerView: UIViewRepresentable {
    typealias Context = UIViewRepresentableContext<Self>
    typealias UIViewType = UIPickerView

    private let feetRange: [Int] = Array(3 ... 8)
    private let inchesRange: [Int] = Array(0 ... 11)

    @Binding var feet: Int
    @Binding var inches: Int

    func makeUIView(context: Context) -> UIViewType {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.reloadAllComponents()
        if let index = self.feetRange.firstIndex(of: self.feet), index != uiView.selectedRow(inComponent: 0) {
            uiView.selectRow(index, inComponent: 0, animated: true)
        }
        if let index = self.inchesRange.firstIndex(of: self.inches), index != uiView.selectedRow(inComponent: 1) {
            uiView.selectRow(index, inComponent: 1, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: HeightPickerView

        init(_ parent: HeightPickerView) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: self.parent.feetRange.count
            case 1: self.parent.inchesRange.count
            default: 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: "\(self.parent.feetRange[row]) feet"
            case 1: "\(self.parent.inchesRange[row]) inches"
            default: nil
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: return self.parent.feet = self.parent.feetRange[row]
            case 1: return self.parent.inches = self.parent.inchesRange[row]
            default: break
            }
        }
    }
}

struct HeightPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HeightPickerView(feet: .constant(5), inches: .constant(7))
            .padding()
    }
}
