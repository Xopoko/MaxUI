import UIKit

extension UITableView {

    func register(tableCell: AnyTableCellClass.Type) {
        register(tableCell, forCellReuseIdentifier: tableCell.reuseIdentifier)
    }
}
