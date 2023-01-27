import UIKit

public protocol AnyCollectionCellClass: UICollectionViewCell {}

public protocol CollectionItemViewModelProtocol {
    
    var collectionCell: AnyCollectionCellClass.Type { get }
}

extension AnyCollectionCellClass {
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
