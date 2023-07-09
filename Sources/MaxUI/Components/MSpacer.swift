import UIKit
import Combine

/// Represents a spacer component for creating constraints between UI elements.
public struct MSpacer: Componentable {
    public typealias ViewType = MSpacerView
    
    /// The height constraint constant value.
    public var height: MBinding<CGFloat>?
    
    /// The width constraint constant value.
    public let width: MBinding<CGFloat>?
    
    /// The height constraint's less than or equal to constant value.
    public let heightLessOrEqual: MBinding<CGFloat>?
    
    /// The width constraint's less than or equal to constant value.
    public let widthLessOrEqual: MBinding<CGFloat>?
    
    /// The height constraint's greater than or equal to constant value.
    public let heightGreaterOrEqual: MBinding<CGFloat>?
    
    /// The width constraint's greater than or equal to constant value.
    public let widthGreaterOrEqual: MBinding<CGFloat>?
    
    /// Initializes a `MSpacer` instance with no constraints.
    public init() {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }

    /// Initialise a `MSpacer` instance with `height` and `width` constraints.
    ///
    /// - Parameters:
    ///   - height: The height constraint constant value. Default is `nil`.
    ///   - width: The width constraint constant value. Default is `nil`.
    public init(
        height: MBinding<CGFloat>? = nil,
        width: MBinding<CGFloat>? = nil
    ) {
        self.height = height
        self.width = width
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    /// Initialise a `MSpacer` instance with `height` and `width` constraints.
    ///
    /// - Parameters:
    ///   - height: The height constraint constant value. Default is `nil`.
    ///   - width: The width constraint constant value. Default is `nil`.
    public init(
        height: CGFloat? = nil,
        width: CGFloat? = nil
    ) {
        self.height = height.flatMap { .constant($0) }
        self.width = width.flatMap { .constant($0) }
        self.heightLessOrEqual = nil
        self.widthLessOrEqual = nil
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    /// Initialise a `MSpacer` instance with `heightLessOrEqual` and `widthLessOrEqual` constraints.
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
        self.heightLessOrEqual = heightLessOrEqual.flatMap { .constant($0) }
        self.widthLessOrEqual = widthLessOrEqual.flatMap { .constant($0) }
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }
    
    /// Initialise a `MSpacer` instance with `heightLessOrEqual` and `widthLessOrEqual` constraints.
    ///
    /// - Parameters:
    ///   - heightLessOrEqual: The height constraint's less than or equal to constant value. Default is `nil`.
    ///   - widthLessOrEqual: The width constraint's less than or equal to constant value. Default is `nil`.
    public init(
        heightLessOrEqual: MBinding<CGFloat>? = nil,
        widthLessOrEqual: MBinding<CGFloat>? = nil
    ) {
        self.height = nil
        self.width = nil
        self.heightLessOrEqual = heightLessOrEqual
        self.widthLessOrEqual = widthLessOrEqual
        self.heightGreaterOrEqual = nil
        self.widthGreaterOrEqual = nil
    }

    /// Initialise a `MSpacer` instance with `heightGreaterOrEqual` and `widthGreaterOrEqual` constraints.
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
        self.heightGreaterOrEqual = heightGreaterOrEqual.flatMap { .constant($0) }
        self.widthGreaterOrEqual = widthGreaterOrEqual.flatMap { .constant($0) }
    }
    
    /// Initialise a `MSpacer` instance with `heightGreaterOrEqual` and `widthGreaterOrEqual` constraints.
    ///
    /// - Parameters:
    ///   - heightGreaterOrEqual: The height constraint's greater than or equal to constant value. Default is `nil`.
    ///   - widthGreaterOrEqual: The width constraint's greater than or equal to constant value. Default is `nil`.
    public init(
        heightGreaterOrEqual: MBinding<CGFloat>? = nil,
        widthGreaterOrEqual: MBinding<CGFloat>? = nil
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
    private var model: MSpacer?
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var cancellables = Set<AnyCancellable>()
}

extension MSpacerView: ReusableView {
    /// This function will be called every time the view is configured as content
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    public func configure(with data: MSpacer) { // swiftlint:disable:this function_body_length
        self.model = data
        
        data.height?.publisher
            .sink { [weak self] height in
                if let heightConstraint = self?.heightConstraint {
                    heightConstraint.constant = height
                } else {
                    self?.heightConstraint = self?.heightAnchor.constraint(equalToConstant: height)
                    self?.heightConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        data.width?.publisher
            .sink { [weak self] width in
                if let widthConstraint = self?.widthConstraint {
                    widthConstraint.constant = width
                } else {
                    self?.widthConstraint = self?.widthAnchor.constraint(equalToConstant: width)
                    self?.widthConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        data.heightLessOrEqual?.publisher
            .sink { [weak self] heightLessOrEqual in
                if let heightConstraint = self?.heightConstraint {
                    heightConstraint.constant = heightLessOrEqual
                } else {
                    self?.heightConstraint = self?.heightAnchor.constraint(lessThanOrEqualToConstant: heightLessOrEqual)
                    self?.heightConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        data.widthLessOrEqual?.publisher
            .sink { [weak self] widthLessOrEqual in
                if let widthConstraint = self?.widthConstraint {
                    widthConstraint.constant = widthLessOrEqual
                } else {
                    self?.widthConstraint = self?.widthAnchor.constraint(lessThanOrEqualToConstant: widthLessOrEqual)
                    self?.widthConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        data.heightGreaterOrEqual?.publisher
            .sink { [weak self] heightGreaterOrEqual in
                if let heightConstraint = self?.heightConstraint {
                    heightConstraint.constant = heightGreaterOrEqual
                } else {
                    self?.heightConstraint = self?.heightAnchor.constraint(
                        greaterThanOrEqualToConstant: heightGreaterOrEqual
                    )
                    self?.heightConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        data.widthGreaterOrEqual?.publisher
            .sink { [weak self] widthGreaterOrEqual in
                if let widthConstraint = self?.widthConstraint {
                    widthConstraint.constant = widthGreaterOrEqual
                } else {
                    self?.widthConstraint = self?.widthAnchor.constraint(
                        greaterThanOrEqualToConstant: widthGreaterOrEqual
                    )
                    self?.widthConstraint?.isActive = true
                }
            }
            .store(in: &cancellables)
        
        setContentHuggingPriority(.init(.zero), for: .horizontal)
        setContentHuggingPriority(.init(.zero), for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }
}

extension MSpacerView: EquidistantSpacingAdaptable {
    var isReadyForEquidistantSpacing: Bool {
        model?.height == nil &&
        model?.width == nil &&
        model?.heightLessOrEqual == nil &&
        model?.widthLessOrEqual == nil &&
        model?.heightGreaterOrEqual == nil &&
        model?.widthGreaterOrEqual == nil
    }
}
