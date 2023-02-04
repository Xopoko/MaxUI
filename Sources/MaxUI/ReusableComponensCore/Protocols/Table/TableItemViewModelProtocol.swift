import UIKit

public protocol AnyTableCellClass: UITableViewCell {}

public protocol TableItemViewModelProtocol {

    var tableCell: AnyTableCellClass.Type { get }
}

extension AnyTableCellClass {

    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
