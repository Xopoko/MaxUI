import UIKit
import Combine

public struct MCollection: Componentable, Withable {
    public typealias ViewType = MCollectionView
    
    @MBinding
    fileprivate var content: [MView]
    fileprivate var appearance: MCollectionView.Appearance = .init()
    
    public init(_ content: [MView]) {
        self.init(.constant(content))
    }
    
    public init(@MViewBuilder _ builder: () -> [MView]) {
        self.init(.constant(builder()))
    }
    
    public init(_ binding: MBinding<[MView]>) {
        self._content = binding
    }
}

public class MCollectionView: UIView, ReusableView {
    private var cancellables = Set<AnyCancellable>()
    private lazy var collectionView = ControlsFriendlyCollectionView.list()
    private lazy var collectionDataSource = CollectionViewDataSource(collectionView: collectionView)

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: MCollection) {
        data.$content.publisher
            .sink { [weak self] in
                let cells: [CollectionItemViewModelProtocol] = $0
                self?.collectionDataSource.update(sections: cells.toSections())
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        updateAppearance(appearance: data.appearance)
    }

    private func setupLayout() {
        collectionView.fill(in: self)
    }
    
    private func updateAppearance(appearance: Appearance) {
        CancellableStorage(in: &cancellables) {
            appearance.contentInset?.publisher
                .weakAssign(to: \.contentInset, on: collectionView)
            appearance.scrollIndicatorInsets?.publisher
                .weakAssign(to: \.scrollIndicatorInsets, on: collectionView)
            appearance.showsVerticalScrollIndicator?.publisher
                .weakAssign(to: \.showsVerticalScrollIndicator, on: collectionView)
            appearance.showsHorizontalScrollIndicator?.publisher
                .weakAssign(to: \.showsHorizontalScrollIndicator, on: collectionView)
            appearance.collectionViewLayout?.publisher
                .weakAssign(to: \.collectionViewLayout, on: collectionView)
            appearance.keyboardDismissMode?.publisher
                .weakAssign(to: \.keyboardDismissMode, on: collectionView)
            appearance.refreshControl?.publisher
                .weakAssign(to: \.refreshControl, on: collectionView)
        }
    }
}

extension MCollectionView {
    public struct Appearance: Withable {
        public var contentInset: MBinding<UIEdgeInsets>?
        public var scrollIndicatorInsets: MBinding<UIEdgeInsets>?
        public var showsVerticalScrollIndicator: MBinding<Bool>?
        public var showsHorizontalScrollIndicator: MBinding<Bool>?
        public var collectionViewLayout: MBinding<UICollectionViewLayout>?
        public var keyboardDismissMode: MBinding<UIScrollView.KeyboardDismissMode>?
        public var refreshControl: MBinding<UIRefreshControl?>?

        public init(
            contentInset: MBinding<UIEdgeInsets>? = nil,
            scrollIndicatorInsets: MBinding<UIEdgeInsets>? = nil,
            showsVerticalScrollIndicator: MBinding<Bool>? = nil,
            showsHorizontalScrollIndicator: MBinding<Bool>? = nil,
            collectionViewLayout: MBinding<UICollectionViewLayout>? = nil,
            refreshControl: MBinding<UIRefreshControl?>? = nil,
            keyboardDismissMode: MBinding<UIScrollView.KeyboardDismissMode>? = nil
        ) {
            self.contentInset = contentInset
            self.scrollIndicatorInsets = scrollIndicatorInsets
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
            self.refreshControl = refreshControl
            self.collectionViewLayout = collectionViewLayout
            self.keyboardDismissMode = keyboardDismissMode
        }
    }
}
extension MCollection {
    /// Sets the content inset of the scroll view.
    ///
    /// - Parameter contentInset: The content inset to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func contentInset(_ contentInset: MBinding<UIEdgeInsets>) -> Self {
        with(\.appearance.contentInset, setTo: contentInset)
    }

    /// Sets the scroll indicator insets of the scroll view.
    ///
    /// - Parameter scrollIndicatorInsets: The scroll indicator insets to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func scrollIndicatorInsets(_ scrollIndicatorInsets: MBinding<UIEdgeInsets>) -> Self {
        with(\.appearance.scrollIndicatorInsets, setTo: scrollIndicatorInsets)
    }

    /// Sets the visibility of the vertical scroll indicator of the scroll view.
    ///
    /// - Parameter showsVerticalScrollIndicator: A boolean value indicating whether to show or hide the vertical scroll indicator.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: MBinding<Bool>) -> Self {
        with(\.appearance.showsVerticalScrollIndicator, setTo: showsVerticalScrollIndicator)
    }

    /// Sets the visibility of the horizontal scroll indicator of the scroll view.
    ///
    /// - Parameter showsHorizontalScrollIndicator: A boolean value indicating whether to show or hide the horizontal scroll indicator.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: MBinding<Bool>) -> Self {
        with(\.appearance.showsHorizontalScrollIndicator, setTo: showsHorizontalScrollIndicator)
    }

    /// Sets the keyboard dismiss mode for the scroll view.
    ///
    /// - Parameter keyboardDismissMode: The keyboard dismiss mode to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func keyboardDismissMode(_ keyboardDismissMode: MBinding<UIScrollView.KeyboardDismissMode>) -> Self {
        with(\.appearance.keyboardDismissMode, setTo: keyboardDismissMode)
    }

    /// Sets the collection view layout for the scroll view.
    ///
    /// - Parameter collectionViewLayout: The collection view layout to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func collectionViewLayout(_ collectionViewLayout: MBinding<UICollectionViewLayout>) -> Self {
        with(\.appearance.collectionViewLayout, setTo: collectionViewLayout)
    }
    
    /// Adds a refresh control to the scroll view.
    ///
    /// - Parameter refreshControl: The refresh control to add.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func refreshControl(_ refreshControl: MBinding<UIRefreshControl?>) -> Self {
        with(\.appearance.refreshControl, setTo: refreshControl)
    }
}

extension MCollection {
    /// Sets the content inset of the scroll view.
    ///
    /// - Parameter contentInset: The content inset to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func contentInset(_ contentInset: UIEdgeInsets) -> Self {
        with(\.appearance.contentInset, setTo: .constant(contentInset))
    }

    /// Sets the scroll indicator insets of the scroll view.
    ///
    /// - Parameter scrollIndicatorInsets: The scroll indicator insets to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func scrollIndicatorInsets(_ scrollIndicatorInsets: UIEdgeInsets) -> Self {
        with(\.appearance.scrollIndicatorInsets, setTo: .constant(scrollIndicatorInsets))
    }

    /// Sets the visibility of the vertical scroll indicator of the scroll view.
    ///
    /// - Parameter showsVerticalScrollIndicator: A boolean value indicating whether to show or hide the vertical scroll indicator.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self {
        with(\.appearance.showsVerticalScrollIndicator, setTo: .constant(showsVerticalScrollIndicator))
    }

    /// Sets the visibility of the horizontal scroll indicator of the scroll view.
    ///
    /// - Parameter showsHorizontalScrollIndicator: A boolean value indicating whether to show or hide the horizontal scroll indicator.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self {
        with(\.appearance.showsHorizontalScrollIndicator, setTo: .constant(showsHorizontalScrollIndicator))
    }

    /// Sets the keyboard dismiss mode for the scroll view.
    ///
    /// - Parameter keyboardDismissMode: The keyboard dismiss mode to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func keyboardDismissMode(_ keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> Self {
        with(\.appearance.keyboardDismissMode, setTo: .constant(keyboardDismissMode))
    }

    /// Sets the collection view layout for the scroll view.
    ///
    /// - Parameter collectionViewLayout: The collection view layout to set.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func collectionViewLayout(_ collectionViewLayout: UICollectionViewLayout) -> Self {
        with(\.appearance.collectionViewLayout, setTo: .constant(collectionViewLayout))
    }
    
    /// Adds a refresh control to the scroll view.
    ///
    /// - Parameter refreshControl: The refresh control to add.
    /// - Returns: The updated scroll view instance.
    @discardableResult
    public func refreshControl(_ refreshControl: UIRefreshControl?) -> Self {
        with(\.appearance.refreshControl, setTo: .constant(refreshControl))
    }
}

#if DEBUG
import SwiftUI
struct MCollection_Previews: PreviewProvider {
    @MBinding
    static var items: [MView] = Array(repeating: MText("Hello"), count: 10)
    
    static var previews: some View {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            items = Array(repeating: MText("Hello"), count: 20)
        }
        return ComponentPreview(distribution: .fill) {
            MCollection($items)
        }
    }
}
#endif
