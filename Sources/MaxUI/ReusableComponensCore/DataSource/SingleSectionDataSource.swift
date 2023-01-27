import UIKit

public protocol SingleSectionDataSourceProtocol {
    
    /// Array of sections
    var section: CollectionSectionViewModelProtocol { get }
    
    /// Array of all items
    var items: [CollectionItemViewModelProtocol] { get }
    
    /// Scroll Delegate
    var scrollDelegate: UIScrollViewDelegate? { get set }
    
    /// Method updates section
    /// - Parameters:
    ///     - section: for updating
    func update(section: CollectionSectionViewModelProtocol)

    /// Method will call the block every time the user scrolls through the collection to the treshold.
    /// - Parameters:
    ///     - treshold: Number of list elements to indent from the end
    ///     - block: Called when the user has scrolled to the end of the list minus the treshold
    func trackDataConsumed(treshold: Int, block: @escaping () -> Void)
}

public final class SingleSectionDataSource: NSObject, SingleSectionDataSourceProtocol {
    public var section: CollectionSectionViewModelProtocol = CollectionSection(items: [])
    
    public var items: [CollectionItemViewModelProtocol] {
        return section.items
    }
    
    public weak var scrollDelegate: UIScrollViewDelegate?
    
    public func update(section: CollectionSectionViewModelProtocol) {
        self.section = section
    }
    
    private weak var collectionView: UICollectionView?
    
    private var reuseIdentifiers: Set<String> = []
    private var reuseHeaderIdentifiers: Set<String> = []
    private var reuseFooterIdentifiers: Set<String> = []

    private var trackDataConsumedBlock: (() -> Void)?
    private var trackDataConsumedTreshold: Int = 0
    
    private lazy var dummyCell = DummyCell.Model()
    private var flowLayout: UICollectionViewFlowLayout? {
        collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
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

// MARK: - CollectionViewDataSource
extension SingleSectionDataSource: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection count: Int
    ) -> Int {
        return section.items.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let viewModel = section.items[indexPath.item]
        
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
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        registerDummyIfNeeded()
        let supplementaryKind = SupplementaryKind(from: kind)
        
        switch supplementaryKind {
        case .header:
            guard let headerModel = section.header else {
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: dummyCell.collectionCell.reuseIdentifier,
                    for: indexPath
                )
            }
            let reuseIdentifier = headerModel.collectionCell.reuseIdentifier
            if !reuseHeaderIdentifiers.contains(reuseIdentifier) {
                collectionView.registerHeader(collectionCell: headerModel.collectionCell)
                reuseHeaderIdentifiers.insert(reuseIdentifier)
            }
            
            let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            if let header = headerCell as? CollectionCellProtocol {
                header.configureWithValue(headerModel)
            }
            
            return headerCell
            
        case .footer:
            guard let footerModel = section.footer else {
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: dummyCell.collectionCell.reuseIdentifier,
                    for: indexPath
                )
            }
            let reuseIdentifier = footerModel.collectionCell.reuseIdentifier
            if !reuseFooterIdentifiers.contains(reuseIdentifier) {
                collectionView.registerFooter(collectionCell: footerModel.collectionCell)
                reuseFooterIdentifiers.insert(reuseIdentifier)
            }
            
            let footerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            if let footer = footerCell as? CollectionCellProtocol {
                footer.configureWithValue(footerModel)
            }
            
            return footerCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SingleSectionDataSource: UICollectionViewDelegate {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let viewModel = section.items[safe: indexPath.row] else {
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
        guard let viewModel = section.items[safe: indexPath.row] else {
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
extension SingleSectionDataSource: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}

// MARK: - Private methods
extension SingleSectionDataSource {
    private func registerDummyIfNeeded() {
        let id = dummyCell.collectionCell.reuseIdentifier
        if !reuseHeaderIdentifiers.contains(id) {
            collectionView?.registerHeader(collectionCell: dummyCell.collectionCell)
            reuseHeaderIdentifiers.insert(id)
        }
        
        if !reuseFooterIdentifiers.contains(id) {
            collectionView?.registerFooter(collectionCell: dummyCell.collectionCell)
            reuseFooterIdentifiers.insert(id)
        }
    }
}
