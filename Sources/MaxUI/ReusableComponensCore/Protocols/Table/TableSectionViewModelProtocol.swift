import Foundation

public protocol TableSectionViewModelProtocol: AnyObject {
    var items: [TableItemViewModelProtocol] { get set }
}

public class TableSection: TableSectionViewModelProtocol {
    public var items: [TableItemViewModelProtocol]
    
    public init(items: [TableItemViewModelProtocol]) {
        self.items = items
    }
}

public extension Array where Element == TableItemViewModelProtocol {
    func toSection() -> TableSection {
        return TableSection(items: self)
    }
    
    func toSections() -> [TableSection] {
        return [toSection()]
    }
}
