import UIKit

public struct EquidistantSpacingContainer: Componentable {
    public typealias ViewType = EquidistantSpacingContainerView
    
    fileprivate let model: MView
    
    public init(_ model: @escaping () -> MView) {
        self.model = model()
    }
}

public class EquidistantSpacingContainerView: UIView, ReusableView {
    public func configure(with data: EquidistantSpacingContainer) {
        data.model.configure(in: self)
    }
}

extension EquidistantSpacingContainerView: EquidistantSpacingAdaptable {
    var isReadyForEquidistantSpacing: Bool { true }
}

extension MView {
    public func toEquidistantSpacingContainer() -> EquidistantSpacingContainer {
        EquidistantSpacingContainer {
            self
        }
    }
}
