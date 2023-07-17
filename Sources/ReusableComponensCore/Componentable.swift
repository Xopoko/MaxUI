import Foundation

/*
 * Aggregate protocol that represents all types of ViewModels,
 * but without associated type and default realisation
 */
public protocol MView: ViewModelProtocol,
                                    CollectionItemViewModelProtocol,
                                    TableItemViewModelProtocol {

}

/*
 * The base protocol for view model that can be used as Component
 */
public protocol Componentable: MView {
    /// The view type associated with this component.
    associatedtype ViewType: ReusableView

    var view: AnyViewClass.Type { get }
    var tableCell: AnyTableCellClass.Type { get }
    var collectionCell: AnyCollectionCellClass.Type { get }
}

extension Componentable {

    public var view: AnyViewClass.Type {
        return ViewType.self
    }

    public var tableCell: AnyTableCellClass.Type {
        return ContainerTableCell<ViewType>.self
    }

    public var collectionCell: AnyCollectionCellClass.Type {
        return ContainerCollectionCell<ViewType>.self
    }
}
