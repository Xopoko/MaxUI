import Foundation

public protocol CollectionSectionViewModelProtocol: AnyObject {
    var items: [CollectionItemViewModelProtocol] { get set }
    var header: CollectionItemViewModelProtocol? { get }
    var footer: CollectionItemViewModelProtocol? { get }
}

public class CollectionSection: CollectionSectionViewModelProtocol {
    public var items: [CollectionItemViewModelProtocol]
    public var header: CollectionItemViewModelProtocol?
    public var footer: CollectionItemViewModelProtocol?

    public init(
        items: [CollectionItemViewModelProtocol],
        header: CollectionItemViewModelProtocol? = nil,
        footer: CollectionItemViewModelProtocol? = nil
    ) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}

public extension Array where Element == CollectionItemViewModelProtocol {
    func toSection() -> CollectionSection {
        return CollectionSection(items: self)
    }

    func toSections() -> [CollectionSection] {
        return [toSection()]
    }
}
