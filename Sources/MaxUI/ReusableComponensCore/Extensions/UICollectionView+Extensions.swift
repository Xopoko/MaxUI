import UIKit

extension UICollectionView {

    func register(collectionCell: AnyCollectionCellClass.Type) {
        register(collectionCell, forCellWithReuseIdentifier: collectionCell.reuseIdentifier)
    }

    func registerHeader(collectionCell: AnyCollectionCellClass.Type) {
        register(
            collectionCell,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: collectionCell.reuseIdentifier
        )
    }

    func registerFooter(collectionCell: AnyCollectionCellClass.Type) {
        register(
            collectionCell,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: collectionCell.reuseIdentifier
        )
    }
}

public extension UICollectionView {
    var flowLayout: UICollectionViewFlowLayout? {
        collectionViewLayout as? UICollectionViewFlowLayout
    }

    var headerHeight: CGFloat {
        get {
            flowLayout?.headerReferenceSize.height ?? .zero
        }
        set {
            flowLayout?.headerReferenceSize.height = newValue
        }
    }

    var footerHeight: CGFloat {
        get {
            flowLayout?.footerReferenceSize.height ?? .zero
        }
        set {
            flowLayout?.footerReferenceSize.height = newValue
        }
    }

    var fullHeight: CGFloat {
        headerHeight +
        contentSize.height +
        contentInset.top +
        contentInset.bottom +
        footerHeight
    }
}
