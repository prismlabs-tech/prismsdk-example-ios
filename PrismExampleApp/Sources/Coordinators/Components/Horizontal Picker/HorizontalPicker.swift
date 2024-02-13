/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI

extension Binding {
    func withDefault<T>(_ defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(get: {
            self.wrappedValue ?? defaultValue
        }, set: { newValue in
            self.wrappedValue = newValue
        })
    }
}

struct HorizontalPicker<Option, OptionView>: View where Option: Hashable, OptionView: View {
    @Namespace var environment
    @Binding private var selectedOption: Option
    let options: [Option]
    let content: (Option) -> OptionView

    init(selectedOption: Binding<Option?>, options: [Option], @ViewBuilder content: @escaping (Option) -> OptionView) {
        self._selectedOption = selectedOption.withDefault(options.first!)
        self.options = options
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .matchedGeometryEffect(
                    id: self.selectedOption,
                    in: self.environment,
                    properties: .frame,
                    isSource: false
                )
                .foregroundColor(Color.prismPink)

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollProxy in
                    HStack {
                        ForEach(self.options, id: \.self) { option in
                            self.content(option)
                                .padding(.vertical, 8.0)
                                .padding(.horizontal, 12.0)
                                .foregroundColor(option == self.selectedOption ? Color.white : Color.prismBase30)
                                .font(.body.weight(option == self.selectedOption ? .bold : .medium))
                                .matchedGeometryEffect(id: option, in: self.environment, isSource: true)
                                .onTapGesture {
                                    HapticFeedback.light()
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        self.selectedOption = option
                                    }
                                }
                        }
                        .fixedSize()
                        .alignmentGuide(HorizontalAlignment.center, computeValue: { dimension in
                            dimension[.leading]
                        })
                    }
                    .onChange(of: self.selectedOption) { newValue in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            scrollProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

/*
 extension HorizontalPicker where Option: StringProtocol, OptionView == Text {
     init(selectedOption: Binding<Option>, options: [Option]) {
         self.options = options
         self._selectedOption = selectedOption
         self.content = { option in
             Text(option)
         }
     }
 }
 */

struct HorizontalPickerDemo: View {
    @State var items: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    @State var selectedItem: String? // = "Item 1"

    var body: some View {
        HorizontalPicker(
            selectedOption: self.$selectedItem,
            options: self.items
        ) { option in
            Text(option)
        }
    }
}

struct HorizontalPicker_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalPickerDemo()
    }
}
