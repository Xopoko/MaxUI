import UIKit

public struct MEmptyView: Componentable {
    public typealias ViewType = MEmptyViewView
    
    public init() {}
}

public final class MEmptyViewView: UIView, ReusableView {
    public func configure(with data: MEmptyView) {}
}
