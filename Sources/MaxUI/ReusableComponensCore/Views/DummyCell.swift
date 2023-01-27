import UIKit

public final class DummyCell: UIView, ReusableView {
    public struct Model: ComponentViewModelProtocol {
        public typealias ViewType = DummyCell
        
        public init() {}
    }
    
    public func configure(with data: DummyCell.Model) { }

    public func prepareForReuse() { }
}
