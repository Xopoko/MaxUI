import UIKit

public final class DummyCell: UIView, ReusableView {
    public struct Model: Componentable {
        public typealias ViewType = DummyCell

        public init() {}
    }

    /// This function will be called every time the view is configured as content
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    public func configure(with data: DummyCell.Model) { }
}
