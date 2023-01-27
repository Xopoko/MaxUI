import UIKit

final class ContainerCollectionCell<ViewType: ReusableView>: UICollectionViewCell,
                                                                AnyCollectionCellClass {
    
    let view: ViewType
    
    override init(frame: CGRect) {
        view = ViewType()
        
        super.init(frame: frame)
        view.fill(in: contentView)
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
extension ContainerCollectionCell: DataConfigurable {
    
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

// MARK: - CollectionCellProtocol
extension ContainerCollectionCell: CollectionCellProtocol {}
