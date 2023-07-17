import UIKit

final class ContainerTableCell<ViewType: ReusableView>: UITableViewCell, AnyTableCellClass {

    let view: ViewType

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        view = ViewType()

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        view.fill(in: contentView)
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
    }
}

// MARK: - DataConfigurable
extension ContainerTableCell: DataConfigurable {

    func configure(with data: ViewType.ViewData) {
        view.configure(with: data)
    }

    func willBeShown(with data: ViewType.ViewData) {
        view.willBeShown(with: data)
    }

    func wasHidden(with data: ViewType.ViewData) {
        view.wasHidden(with: data)
    }
}

// MARK: - TableViewCellProtocol
extension ContainerTableCell: TableCellProtocol {}
