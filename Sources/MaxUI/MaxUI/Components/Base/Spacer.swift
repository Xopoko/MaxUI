import UIKit

public struct Spacer: ComponentViewModelProtocol {
    public typealias ViewType = SpacerView
    
    public let height: CGFloat?
    public let width: CGFloat?
    public let heightLessOrEqual: CGFloat?
    public let widthLessOrEqual: CGFloat?
    public let heightGreaterOrEqual: CGFloat?
    public let widthGreaterOrEqual: CGFloat?
    
    public init() {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    public init(
        height: CGFloat? = nil,
        width: CGFloat? = nil
    ) {
        self.height = height
        self.width = width
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    public init(
        heightLessOrEqual: CGFloat? = nil,
        widthLessOrEqual: CGFloat? = nil
    ) {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = heightLessOrEqual
        self.widthLessOrEqual = widthLessOrEqual
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    public init(
        heightGreaterOrEqual: CGFloat? = nil,
        widthGreaterOrEqual: CGFloat? = nil
    ) {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = heightGreaterOrEqual
        self.widthGreaterOrEqual = widthGreaterOrEqual
    }
}

public final class SpacerView: UIView {
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
}

extension SpacerView: ReusableView {

    public func configure(with data: Spacer) {
        heightConstraint.map { removeConstraint($0) }
        widthConstraint.map { removeConstraint($0) }

        data.height.map {
            heightConstraint = heightAnchor.constraint(equalToConstant: $0)
            heightConstraint?.isActive = true
        }
        
        data.width.map {
            widthConstraint = widthAnchor.constraint(equalToConstant: $0)
            widthConstraint?.isActive = true
        }
        
        data.heightLessOrEqual.map {
            heightConstraint = heightAnchor.constraint(lessThanOrEqualToConstant: $0)
            heightConstraint?.isActive = true
        }
        
        data.widthLessOrEqual.map {
            widthConstraint = widthAnchor.constraint(lessThanOrEqualToConstant: $0)
            widthConstraint?.isActive = true
        }
        
        data.heightGreaterOrEqual.map {
            heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: $0)
            heightConstraint?.isActive = true
        }
        
        data.widthGreaterOrEqual.map {
            widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: $0)
            widthConstraint?.isActive = true
        }
        
        setContentHuggingPriority(.init(.zero), for: .horizontal)
        setContentHuggingPriority(.init(.zero), for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    public func prepareForReuse() {}
}
