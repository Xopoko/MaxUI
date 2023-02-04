import UIKit

enum SupplementaryKind: String {
    case header
    case footer

    init(from string: String) {
        switch string {
        case UICollectionView.elementKindSectionHeader:
            self = .header
        case UICollectionView.elementKindSectionFooter:
            self = .footer
        default:
            fatalError("Unsupported supplementary kind in collection")
        }
    }
}
