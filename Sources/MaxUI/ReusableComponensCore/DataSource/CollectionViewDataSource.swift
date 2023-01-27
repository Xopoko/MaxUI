import UIKit

public protocol CollectionViewDataSourceProtocol {
    
    /// Array of sections
    var sections: [CollectionSectionViewModelProtocol] { get }
    
    /// Array of all items
    var items: [CollectionItemViewModelProtocol] { get }
    
    /// Scroll Delegate
    var scrollDelegate: UIScrollViewDelegate? { get set }
    
    /// Method updates all sections
    /// - Parameters:
    ///     - sections: The array of sections for update
    func update(sections: [CollectionSectionViewModelProtocol])
    
    /// Method insert items after specific index path
    /// - Parameters:
    ///     - items: The array of items to insert
    ///     - after: IndexPath after which to insert items
    func insert(items: [CollectionItemViewModelProtocol], after indexPath: IndexPath) -> [IndexPath]
    
    /// Method inserts sections after specific section index
    /// - Parameters:
    ///     - sections: The array of sections to insert
    ///     - sectionIndex: Index after which to insert sections
    func insert(
        sections: [CollectionSectionViewModelProtocol],
        after sectionIndex: Int
    ) -> IndexSet?
    
    /// Method updates item at given index path
    /// - Parameters:
    ///     - indexPath: Index path of the updated item
    ///     - item: New item for update
    func replaceItem(at indexPath: IndexPath, item: CollectionItemViewModelProtocol)
    
    /// Method returns index path of the item with the given type, otherwise nil
    /// - Parameters:
    ///     - type: Type of the item
    ///     - section: Section where item is placed
    func findItemIndexPath<T: CollectionItemViewModelProtocol>(
        of type: T.Type, in section: Int
    ) -> IndexPath?
    
    /// Method will call the block every time the user scrolls through the collection to the treshold.
    /// - Parameters:
    ///     - treshold: Number of list elements to indent from the end
    ///     - block: Called when the user has scrolled to the end of the list minus the treshold
    func trackDataConsumed(treshold: Int, block: @escaping () -> Void)
}

public final class CollectionViewDataSource: NSObject, CollectionViewDataSourceProtocol {
    public var sections: [CollectionSectionViewModelProtocol] = []
    
    public var items: [CollectionItemViewModelProtocol] {
        return sections.flatMap { $0.items }
    }
    
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    public func update(sections: [CollectionSectionViewModelProtocol]) {
        self.sections = sections
    }
    
    private weak var collectionView: UICollectionView?
    
    private var reuseIdentifiers: Set<String> = []
    private var trackDataConsumedBlock: (() -> Void)?
    private var trackDataConsumedTreshold: Int = 0

    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
                
        super.init()
        
        configure(collectionView)
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    public func trackDataConsumed(treshold: Int, block: @escaping () -> Void) {
        trackDataConsumedBlock = block
        trackDataConsumedTreshold = treshold
    }
}

// MARK: - Mutating functions
extension CollectionViewDataSource {
    public func insert(
        items: [CollectionItemViewModelProtocol],
        after indexPath: IndexPath
    ) -> [IndexPath] {
        guard
            let section = sections[safe: indexPath.section],
            section.items[safe: indexPath.row] != nil else {
                return []
            }
    
        let insertedElementsCount = items.count
        let insertedIndex = indexPath.row + 1

        section.items.insert(contentsOf: items, at: insertedIndex)
        return (insertedIndex ... (indexPath.row + insertedElementsCount))
            .map { IndexPath(row: $0, section: indexPath.section) }
    }
    
    public func insert(
        sections: [CollectionSectionViewModelProtocol],
        after sectionIndex: Int
    ) -> IndexSet? {
        guard self.sections[safe: sectionIndex] != nil else { return nil }
        
        let startIndex = sectionIndex + 1
        let endIndex = startIndex + sections.count
        self.sections.insert(contentsOf: sections, at: startIndex)
        
        return IndexSet(integersIn: startIndex..<endIndex)
    }
}

// MARK: - CollectionViewDataSource
extension CollectionViewDataSource: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let viewModel = sections[indexPath.section].items[indexPath.item]
        
        let reuseIdentifier = viewModel.collectionCell.reuseIdentifier
        if !reuseIdentifiers.contains(reuseIdentifier) {
            collectionView.register(collectionCell: viewModel.collectionCell)
            reuseIdentifiers.insert(reuseIdentifier)
        }        
            
        let collectionCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        if let cell = collectionCell as? CollectionCellProtocol {
            cell.configureWithValue(viewModel)
        }
                
        return collectionCell
    }
    
    public func replaceItem(at indexPath: IndexPath, item: CollectionItemViewModelProtocol) {
        guard
            let section = sections[safe: indexPath.section],
            section.items[safe: indexPath.item] != nil else {
                return
            }
        
        sections[indexPath.section].items[indexPath.item] = item
    }
    
    public func findItemIndexPath<T: CollectionItemViewModelProtocol>(
        of type: T.Type,
        in section: Int
    ) -> IndexPath? {
        guard
            let targetSection = sections[safe: section],
            let itemIndex = targetSection.items.firstIndex(where: { $0 is T }) else {
            return nil
        }
        
        return IndexPath(item: itemIndex, section: section)
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewDataSource: UICollectionViewDelegate {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let items = sections[safe: indexPath.section]?.items,
              let viewModel = items[safe: indexPath.row] else {
            return
        }
        
        if let item = viewModel as? ListItemActionable {
            item.didSelect?()
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let items = sections[safe: indexPath.section]?.items,
              let viewModel = items[safe: indexPath.row] else {
            return
        }
        
        if let collectionCell = cell as? CollectionCellProtocol {
            collectionCell.willDisplay(viewModel)
        }
        
        guard let trackDataConsumedBlock = trackDataConsumedBlock else {
            return
        }
        if indexPath.row > items.count - trackDataConsumedTreshold {
            trackDataConsumedBlock()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CollectionViewDataSource: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
}
