import UIKit

/// Represents a spacer component for creating constraints between UI elements.
public struct MSpacer: Componentable {
    public typealias ViewType = MSpacerView

    /// The height constraint constant value.
    public let height: CGFloat?

    /// The width constraint constant value.
    public let width: CGFloat?

    /// The height constraint's less than or equal to constant value.
    public let heightLessOrEqual: CGFloat?

    /// The width constraint's less than or equal to constant value.
    public let widthLessOrEqual: CGFloat?

    /// The height constraint's greater than or equal to constant value.
    public let heightGreaterOrEqual: CGFloat?

    /// The width constraint's greater than or equal to constant value.
    public let widthGreaterOrEqual: CGFloat?

    /// Initializes a `MSpacer` instance with no constraints.
    public init() {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }

    /// Initializes a `MSpacer` instance with `height` and `width` constraints.
    ///
    /// - Parameters:
    ///   - height: The height constraint constant value. Default is `nil`.
    ///   - width: The width constraint constant value. Default is `nil`.
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

    /// Initializes a `MSpacer` instance with `heightLessOrEqual` and `widthLessOrEqual` constraints.
    ///
    /// - Parameters:
    ///   - heightLessOrEqual: The height constraint's less than or equal to constant value. Default is `nil`.
    ///   - widthLessOrEqual: The width constraint's less than or equal to constant value. Default is `nil`.
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

    /// Initializes a `MSpacer` instance with `heightGreaterOrEqual` and `widthGreaterOrEqual` constraints.
    ///
    /// - Parameters:
    ///   - heightGreaterOrEqual: The height constraint's greater than or equal to constant value. Default is `nil`.
    ///   - widthGreaterOrEqual: The width constraint's greater than or equal to constant value. Default is `nil`.
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

public final class MSpacerView: UIView {
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
}

extension MSpacerView: ReusableView {
    /// This function will be called every time the view is configured as content
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    public func configure(with data: MSpacer) {
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
}
