/*
 * Copyright (c) Prismlabs, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftUI
import UIKit

struct CollectionView<Collections, CellContent>: UIViewControllerRepresentable where
    Collections: RandomAccessCollection,
    Collections.Index == Int,
    Collections.Element: RandomAccessCollection,
    Collections.Element.Index == Int,
    Collections.Element.Element: Identifiable,
    CellContent: View {
    typealias Row = Collections.Element
    typealias Data = Row.Element
    typealias ContentForData = (Data) -> CellContent
    typealias ScrollDirection = UICollectionView.ScrollDirection
    typealias SizeForData = (Data) -> CGSize
    typealias CustomSizeForData = (UICollectionView, UICollectionViewLayout, Data) -> CGSize
    typealias RawCustomize = (UICollectionView) -> Void

    enum ContentSize {
        case fixed(CGSize)
        case variable(SizeForData)
        case crossAxisFilled(mainAxisLength: CGFloat)
        case custom(CustomSizeForData)
    }

    struct ItemSpacing: Hashable {
        var mainAxisSpacing: CGFloat
        var crossAxisSpacing: CGFloat
    }

    @Binding var selection: Int

    let collections: Collections
    let contentForData: ContentForData
    let scrollDirection: ScrollDirection
    let contentSize: ContentSize
    let itemSpacing: ItemSpacing
    let rawCustomize: RawCustomize?

    init(
        collections: Collections,
        selection: Binding<Int>,
        scrollDirection: ScrollDirection = .horizontal,
        contentSize: ContentSize,
        itemSpacing: ItemSpacing = ItemSpacing(mainAxisSpacing: 0, crossAxisSpacing: 0),
        rawCustomize: RawCustomize? = nil,
        contentForData: @escaping ContentForData
    ) {
        self.collections = collections
        self._selection = selection
        self.scrollDirection = scrollDirection
        self.contentSize = contentSize
        self.itemSpacing = itemSpacing
        self.rawCustomize = rawCustomize
        self.contentForData = contentForData
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }

    func makeUIViewController(context: Context) -> ViewController {
        let coordinator = context.coordinator
        let viewController = ViewController(coordinator: coordinator, scrollDirection: self.scrollDirection)
        coordinator.viewController = viewController
        self.rawCustomize?(viewController.collectionView)
        viewController.collectionView.reloadData()
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        context.coordinator.view = self
        uiViewController.layout.scrollDirection = self.scrollDirection
        if case let .fixed(size) = self.contentSize {
            uiViewController.layout.itemSize = size
        }
        uiViewController.layout.minimumLineSpacing = self.itemSpacing.mainAxisSpacing
        self.rawCustomize?(uiViewController.collectionView)
        uiViewController.collectionView.reloadData()
        if uiViewController.layout.currentCenteredPage != self.selection {
            uiViewController.layout.scrollToPage(atIndex: self.selection, animated: true)
        }
    }
}

extension CollectionView {
    init<Collection>(
        collection: Collection,
        selection: Binding<Int>,
        scrollDirection: ScrollDirection = .horizontal,
        contentSize: ContentSize,
        itemSpacing: ItemSpacing = ItemSpacing(mainAxisSpacing: 0, crossAxisSpacing: 0),
        rawCustomize: RawCustomize? = nil,
        contentForData: @escaping ContentForData
    ) where Collections == [Collection] {
        self.init(
            collections: [collection],
            selection: selection,
            scrollDirection: scrollDirection,
            contentSize: contentSize,
            itemSpacing: itemSpacing,
            rawCustomize: rawCustomize,
            contentForData: contentForData
        )
    }
}

extension CollectionView {
    class ViewController: UIViewController {
        let layout: CollectionViewCarouselLayout
        let collectionView: UICollectionView

        init(coordinator: Coordinator, scrollDirection: ScrollDirection) {
            let layout = CollectionViewCarouselLayout()
            layout.scrollDirection = scrollDirection
            if case let .fixed(size) = coordinator.view.contentSize {
                layout.itemSize = size
            }

            layout.minimumLineSpacing = coordinator.view.itemSpacing.mainAxisSpacing
            self.layout = layout

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.decelerationRate = .fast
            collectionView.backgroundColor = nil
            collectionView.register(CollectionView.HostedCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.dataSource = coordinator
            collectionView.delegate = coordinator
            self.collectionView = collectionView
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("In no way is this class related to an interface builder file.")
        }

        override func loadView() {
            self.view = self.collectionView
        }
    }
}

extension CollectionView {
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        fileprivate var view: CollectionView
        fileprivate var viewController: ViewController?

        init(view: CollectionView) {
            self.view = view
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            self.view.collections.count
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            self.view.collections[section].count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionView.HostedCollectionViewCell else {
                fatalError()
            }
            let data = self.view.collections[indexPath.section][indexPath.item]
            let content = self.view.contentForData(data)
            cell.provide(content)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let cell = cell as? CollectionView.HostedCollectionViewCell else { return }
            cell.attach(to: self.viewController!)
        }

        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            guard let cell = cell as? CollectionView.HostedCollectionViewCell else { return }
            cell.detach()
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.viewController?.layout.scrollToPage(atIndex: indexPath.row, animated: true)
            self.view.selection = indexPath.row
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch self.view.contentSize {
            case let .fixed(size):
                return size
            case let .variable(sizeForData):
                let data = self.view.collections[indexPath.section][indexPath.item]
                return sizeForData(data)
            case let .crossAxisFilled(mainAxisLength):
                switch self.view.scrollDirection {
                case .horizontal:
                    return CGSize(width: mainAxisLength, height: collectionView.bounds.height)
                case .vertical:
                    fallthrough
                @unknown default:
                    return CGSize(width: collectionView.bounds.width, height: mainAxisLength)
                }
            case let .custom(customSizeForData):
                let data = self.view.collections[indexPath.section][indexPath.item]
                return customSizeForData(collectionView, collectionViewLayout, data)
            }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            self.view.itemSpacing.mainAxisSpacing
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            self.view.itemSpacing.crossAxisSpacing
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            HapticFeedback.selection()
            guard let indexPath = self.viewController?.layout.currentCenteredIndexPath else { return }
            self.view.selection = indexPath.row
        }
    }
}

struct DemoData: Identifiable {
    let id: String
}

struct DemoCell: View {
    let data: DemoData
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .center) {
            Text(self.data.id)
                .font(.system(size: 24))
                .foregroundColor(self.isSelected ? Color.white : Color.black)
                .fontWeight(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.cornerRadius(14))
    }
}

struct CollectionViewDemoView: View {
    @State var items = (0 ... 30).map { DemoData(id: "\($0)") }
    @State var selectedIndex: Int = 0

    var body: some View {
        VStack {
            CollectionView(
                collection: self.items,
                selection: self.$selectedIndex,
                contentSize: .fixed(CGSize(width: 150, height: 60)),
                itemSpacing: .init(mainAxisSpacing: 8, crossAxisSpacing: 0),
                rawCustomize: { collectionView in
                    collectionView.showsHorizontalScrollIndicator = false
                },
                contentForData: { data -> DemoCell in
                    let index = self.items.firstIndex(where: { $0.id == data.id })
                    return DemoCell(data: data, isSelected: index == self.selectedIndex)
                }
            )
            .frame(height: 60)
            Text("Seleceted Item: \(self.selectedIndex)")
            Button("Scroll to Index") {
                self.selectedIndex = 5
            }
        }
    }
}

struct CollectionViewDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionViewDemoView()
    }
}
