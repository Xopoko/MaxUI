import UIKit

/// The methods adopted by the object is using to manage
/// actions with BaseTableItems in a table view.
public protocol TableViewDataSourceDelegate: AnyObject {
    
    /// The method called when user taps on the table item
    /// - Parameters:
    ///     - item: The selected item
    func didSelect(item: TableItemViewModelProtocol)
    
    /// The method called when scroll action occurs
    /// - Parameters:
    ///     - contentOffset: The content offset value from the `UIScrollView`
    func didScroll(contentOffset: CGPoint)
}

public protocol TableViewDataSourceProtocol {
    /// Array of sections
    var sections: [TableSectionViewModelProtocol] { get }
    
    /// Array of all items
    var items: [TableItemViewModelProtocol] { get }
    
    /// The object that acts as the delegate of the table data source.
    var delegate: TableViewDataSourceDelegate? { get set }
    
    /// Method updates all sections
    /// - Parameters:
    ///     - sections: The array of sections for update
    func update(sections: [TableSectionViewModelProtocol])
    
    /// Method insert items after specific index path
    /// - Parameters:
    ///     - items: The array of items to insert
    ///     - after: IndexPath after which to insert items
    func insert(items: [TableItemViewModelProtocol], after indexPath: IndexPath) -> [IndexPath]
    
    /// Method inserts sections after specific section index
    /// - Parameters:
    ///     - sections: The array of sections to insert
    ///     - sectionIndex: Index after which to insert sectionsw
    func insert(sections: [TableSectionViewModelProtocol], after sectionIndex: Int) -> IndexSet?
    
    /// Method will call the block every time the user scrolls through the collection to the treshold.
    /// - Parameters:
    ///     - treshold: Number of list elements to indent from the end
    ///     - block: Called when the user has scrolled to the end of the list minus the treshold
    func trackDataConsumed(treshold: Int, block: @escaping () -> Void)
}

public class TableViewDataSource: NSObject, TableViewDataSourceProtocol {    
    public var sections: [TableSectionViewModelProtocol] = []
    
    public var items: [TableItemViewModelProtocol] {
        return sections.flatMap { $0.items }
    }
    
    public weak var delegate: TableViewDataSourceDelegate?
    weak var tableView: UITableView?
                        
    private var reuseIdentifiers: Set<String> = []
    private var trackDataConsumedBlock: (() -> Void)?
    private var trackDataConsumedTreshold: Int = 0
    
    public init(tableView: UITableView, appearance: Appearance = Appearance()) {
        self.tableView = tableView
        
        super.init()
        
        configureTableView(tableView, appearance: appearance)
    }
    
    public func update(sections: [TableSectionViewModelProtocol]) {
        self.sections = sections
    }
    
    private func configureTableView(_ tableView: UITableView, appearance: Appearance) {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = appearance.rowHeight
        tableView.estimatedRowHeight = appearance.estimatedRowHeight
        tableView.estimatedSectionHeaderHeight = appearance.estimatedSectionFooterHeight
        tableView.estimatedSectionFooterHeight = appearance.estimatedSectionFooterHeight
        tableView.backgroundColor = appearance.backgroundColor
        tableView.separatorStyle = appearance.separatorStyle
        tableView.showsVerticalScrollIndicator = appearance.showsVerticalScrollIndicator
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = appearance.sectionHeaderTopPadding
        }
    }
    
    public func trackDataConsumed(treshold: Int, block: @escaping () -> Void) {
        trackDataConsumedBlock = block
        trackDataConsumedTreshold = treshold
    }
}

// MARK: - Mutating functions
extension TableViewDataSource {
    public func insert(
        sections: [TableSectionViewModelProtocol],
        after sectionIndex: Int
    ) -> IndexSet? {
        guard self.sections[safe: sectionIndex] != nil else { return nil }
        
        let startIndex = sectionIndex + 1
        let endIndex = startIndex + sections.count
        self.sections.insert(contentsOf: sections, at: startIndex)
        
        return IndexSet(integersIn: startIndex..<endIndex)
    }
    
    public func insert(
        items: [TableItemViewModelProtocol],
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
}

// MARK: UITableViewDataSource
extension TableViewDataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sections[safe: section] else {
            return .zero
        }
        return section.items.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let viewModel = sections[indexPath.section].items[indexPath.row]
        
        let reuseIdentifier = viewModel.tableCell.reuseIdentifier
        if !reuseIdentifiers.contains(reuseIdentifier) {
            tableView.register(tableCell: viewModel.tableCell)
            reuseIdentifiers.insert(reuseIdentifier)
        }
        
        let tableCell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        if let cell = tableCell as? TableCellProtocol {
            cell.configureWithValue(viewModel)
        }
        
        tableCell.selectionStyle = .none
        
        return tableCell
    }
}

// MARK: UITableViewDelegate
extension TableViewDataSource: UITableViewDelegate {
    
    public func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let section = sections[safe: indexPath.section] else {
            return
        }
        
        if let tableCell = cell as? TableCellProtocol,
           let viewModel = section.items[safe: indexPath.row] {
            tableCell.willDisplay(viewModel)
        }
    }
    
    public func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let section = sections[safe: indexPath.section] else {
            return
        }
        
        if let tableCell = cell as? TableCellProtocol,
           let viewModel = section.items[safe: indexPath.row] {
            tableCell.didEndDisplay(viewModel)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = sections[indexPath: indexPath] {
            delegate?.didSelect(item: item)
            
            if let actionable = item as? ListItemActionable {
                actionable.didSelect?()
            }
        }
                
        tableView.deselectRow(at: indexPath, animated: false)
    }
                
    public func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .none
    }

    public func tableView(
        _ tableView: UITableView,
        shouldIndentWhileEditingRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(contentOffset: scrollView.contentOffset)
        guard let trackDataConsumedBlock = trackDataConsumedBlock else {
            return
        }
        
        let count = items.count
        let treshold = count - trackDataConsumedTreshold
        if let lastRow = tableView?.indexPathsForVisibleRows?.last?.row, lastRow > treshold {
            trackDataConsumedBlock()
        }
    }
}

extension TableViewDataSource {
    public struct Appearance {
        var rowHeight: CGFloat = UITableView.automaticDimension
        var estimatedRowHeight: CGFloat
        var estimatedSectionHeaderHeight: CGFloat
        var estimatedSectionFooterHeight: CGFloat
        var backgroundColor: UIColor = .clear
        var separatorStyle: UITableViewCell.SeparatorStyle
        var showsVerticalScrollIndicator: Bool
        var sectionHeaderTopPadding: CGFloat
        
        public init(
            rowHeight: CGFloat = UITableView.automaticDimension,
            estimatedRowHeight: CGFloat = 64,
            estimatedSectionHeaderHeight: CGFloat = 100,
            estimatedSectionFooterHeight: CGFloat = 100,
            backgroundColor: UIColor = .clear,
            separatorStyle: UITableViewCell.SeparatorStyle = .none,
            showsVerticalScrollIndicator: Bool = false,
            sectionHeaderTopPadding: CGFloat = 0
        ) {
            self.rowHeight = rowHeight
            self.estimatedRowHeight = estimatedRowHeight
            self.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
            self.estimatedSectionFooterHeight = estimatedSectionFooterHeight
            self.backgroundColor = backgroundColor
            self.separatorStyle = separatorStyle
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.sectionHeaderTopPadding = sectionHeaderTopPadding
        }
    }
}

private extension Array where Element == TableSectionViewModelProtocol {
    
    subscript (indexPath indexPath: IndexPath) -> TableItemViewModelProtocol? {
        guard let section = self[safe: indexPath.section] else {
            return nil
        }
        
        guard let item = section.items[safe: indexPath.row] else {
            return nil
        }
        
        return item
    }
}
