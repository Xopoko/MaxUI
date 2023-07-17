import UIKit
import Combine

/// Defines appearance attributes shared among views
/// and can be easily applied to multiple views.
public enum SharedAppearance: Equatable, Withable {

    /// Layout attributes for the view.
    public struct Layout: Equatable, Withable {

        /// The edge insets of the view.
        public var insets: UIEdgeInsets = .zero

        /// The width of the view.
        public var width: CGFloat?

        /// The height of the view.
        public var height: CGFloat?

        /// The center Y coordinate of the view.
        public var centerY: CGFloat?

        /// The center X coordinate of the view.
        public var centerX: CGFloat?
        
        /// The height constraint's less than or equal to constant value.
        public var heightLessOrEqual: CGFloat?
        
        /// The width constraint's less than or equal to constant value.
        public var widthLessOrEqual: CGFloat?
        
        /// The height constraint's greater than or equal to constant value.
        public var heightGreaterOrEqual: CGFloat?
        
        /// The width constraint's greater than or equal to constant value.
        public var widthGreaterOrEqual: CGFloat?

        /// Initializes layout attributes with the specified width, height and insets.
        ///
        /// - Parameters:
        ///     - insets: The edge insets of the view.
        ///     - width: The width of the view.
        ///     - height: The height of the view.
        public init(
            insets: UIEdgeInsets = .zero,
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            heightLessOrEqual: CGFloat? = nil,
            widthLessOrEqual: CGFloat? = nil,
            heightGreaterOrEqual: CGFloat? = nil,
            widthGreaterOrEqual: CGFloat? = nil
        ) {
            self.insets = insets
            self.width = width
            self.height = height
            self.heightLessOrEqual = heightLessOrEqual
            self.widthLessOrEqual = widthLessOrEqual
            self.heightGreaterOrEqual = heightGreaterOrEqual
            self.widthGreaterOrEqual = widthGreaterOrEqual
        }

        /// Initializes layout attributes with the specified size and insets.
        ///
        /// - Parameters:
        ///     - size: The size of the view.
        ///     - insets: The edge insets of the view.
        public init(
            size: CGSize,
            insets: UIEdgeInsets = .zero
        ) {
            self.width = size.width
            self.height = size.height
            self.insets = insets
            self.heightLessOrEqual = nil
            self.widthLessOrEqual = nil
            self.heightGreaterOrEqual = nil
            self.widthGreaterOrEqual = nil
        }
    }

    /// Priority structure used to set layout priority for views in UIKit
    public struct Priority: Equatable, Withable {
        public var verticalHuggingPriority: UILayoutPriority?
        public var verticalCompressPriority: UILayoutPriority?
        public var horizontalHuggingPriority: UILayoutPriority?
        public var horizontalCompressPriority: UILayoutPriority?

        /// Initializes the Priority structure with optional values for each priority.
        ///
        /// - Parameters:
        ///   - verticalHuggingPriority: The priority of the view to hug its content vertically.
        ///   - verticalCompressPriority: The priority of the view to compress vertically.
        ///   - horizontalHuggingPriority: The priority of the view to hug its content horizontally.
        ///   - horizontalCompressPriority: The priority of the view to compress horizontally.
        public init(
            verticalHuggingPriority: UILayoutPriority? = nil,
            verticalCompressPriority: UILayoutPriority? = nil,
            horizontalHuggingPriority: UILayoutPriority? = nil,
            horizontalCompressPriority: UILayoutPriority? = nil
        ) {
            self.verticalHuggingPriority = verticalHuggingPriority
            self.verticalCompressPriority = verticalCompressPriority
            self.horizontalHuggingPriority = horizontalHuggingPriority
            self.horizontalCompressPriority = horizontalCompressPriority
        }
    }

    /// A structure that contains common properties of a `CALayer`.
    ///
    /// Layer contains a set of optional properties that can be used to configure the appearance of a `CALayer`.
    public struct Layer: Equatable, Withable {
        /// Represents a shadow for the layer.
        public struct Shadow: Equatable {
            /// The offset on the x-axis of the shadow from the layer. Default value is 0.
            public let offsetX: CGFloat
            /// The offset on the y-axis of the shadow from the layer. Default value is -3.
            public let offsetY: CGFloat
            /// The color of the shadow. Default value is UIColor.black.
            public let color: UIColor
            /// The opacity of the shadow. Default value is 0.
            public let opacity: Float
            /// The radius of the shadow. Default value is 3.
            public let radius: CGFloat

            /// Initializes a shadow with specified parameters.
            ///
            /// - Parameters:
            ///   - offsetX: The offset on the x-axis of the shadow from the layer. Default value is 0.
            ///   - offsetY: The offset on the y-axis of the shadow from the layer. Default value is -3.
            ///   - color: The color of the shadow. Default value is UIColor.blakc.
            ///   - opacity: The opacity of the shadow. Default value is 0.
            ///   - radius: The radius of the shadow. Default value is 3.
            public init(
                offsetX: CGFloat = .zero,
                offsetY: CGFloat = -3,
                color: UIColor = .black,
                opacity: Float = .zero,
                radius: CGFloat = 3
            ) {
                self.offsetX = offsetX
                self.offsetY = offsetY
                self.color = color
                self.opacity = opacity
                self.radius = radius
            }
        }

        /// The radius of the rounded corners of the layer.
        public var cornerRadius: MBinding<CGFloat>?
        /// An array of corners to round.
        public var cornersToRound: MBinding<[UIRectCorner]>?
        /// The width of the border of the layer.
        public var borderWidth: MBinding<CGFloat>?
        /// The color of the border of the layer.
        public var borderColor: MBinding<UIColor>?
        /// The shadow for the layer.
        public var shadow: MBinding<Shadow>?
        /// A Boolean value indicating whether the layer's content should be clipped to the bounds.
        public var masksToBounds: MBinding<Bool>?

        /// Initializes a layer with specified parameters.
        ///
        /// - Parameters:
        ///   - cornerRadius: The radius of the rounded corners of the layer.
        ///   - cornersToRound: An array of corners to round.
        ///   - borderWidth: The width of the border of the layer.
        ///   - borderColor: The color of the border of the layer.
        ///   - shadow: The shadow for the layer.
        ///   - masksToBounds: A Boolean value indicating whether the layer's content should be clipped to the bounds.
        public init(
            cornerRadius: MBinding<CGFloat>? = nil,
            cornersToRound: MBinding<[UIRectCorner]>? = nil,
            borderWidth: MBinding<CGFloat>? = nil,
            borderColor: MBinding<UIColor>? = nil,
            shadow: MBinding<Shadow>? = nil,
            masksToBounds: MBinding<Bool>? = nil
        ) {
            self.cornerRadius = cornerRadius
            self.cornersToRound = cornersToRound
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.shadow = shadow
            self.masksToBounds = masksToBounds
        }
        
        public static func == (lhs: Layer, rhs: Layer) -> Bool {
            lhs.cornerRadius?.wrappedValue == rhs.cornerRadius?.wrappedValue &&
            lhs.cornersToRound?.wrappedValue == rhs.cornersToRound?.wrappedValue &&
            lhs.borderWidth?.wrappedValue == rhs.borderWidth?.wrappedValue &&
            lhs.borderColor?.wrappedValue == rhs.borderColor?.wrappedValue &&
            lhs.shadow?.wrappedValue == rhs.shadow?.wrappedValue &&
            lhs.masksToBounds?.wrappedValue == rhs.masksToBounds?.wrappedValue
        }
    }

    /// A structure that contains common properties of a `UIView`.
    ///
    /// Common contains a set of optional properties that can be used to configure the appearance of a `UIView`.
    public struct Common: Equatable, Withable {
        /// A Boolean value indicating whether user interactions are enabled for the view.
        public var isUserInteractionEnabled: MBinding<Bool>?
        /// The opacity of the view.
        public var alpha: MBinding<CGFloat>?
        /// The way the view's content should be scaled and positioned.
        public var contentMode: MBinding<UIView.ContentMode>?
        /// The background color of the view.
        public var backgroundColor: MBinding<UIColor?>?
        /// A Boolean value indicating whether the view should be clipped to its bounds.
        public var clipsToBounds: MBinding<Bool>?
        /// A Boolean value indicating whether the view is hidden.
        public var isHidden: MBinding<Bool>?
        public var gestureRecognizers: MBinding<[UIGestureRecognizer]?>?
        
        /// Initializes a `Common` structure with the specified properties.
        ///
        /// - Parameters:
        ///   - isUserInteractionEnabled: A Boolean value indicating whether user interactions are enabled for the view.
        ///   - alpha: The opacity of the view.
        ///   - contentMode: The way the view's content should be scaled and positioned.
        ///   - backgroundColor: The background color of the view.
        ///   - clipsToBounds: A Boolean value indicating whether the view should be clipped to its bounds.
        ///   - isHidden: A Boolean value indicating whether the view is hidden.
        public init(
            isUserInteractionEnabled: MBinding<Bool>? = nil,
            alpha: MBinding<CGFloat>? = nil,
            contentMode: MBinding<UIView.ContentMode>? = nil,
            backgroundColor: MBinding<UIColor?>? = nil,
            clipsToBounds: MBinding<Bool>? = nil,
            isHidden: MBinding<Bool>? = nil,
            gestureRecognizers: MBinding<[UIGestureRecognizer]?>? = nil
        ) {
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.alpha = alpha
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
            self.clipsToBounds = clipsToBounds
            self.isHidden = isHidden
            self.gestureRecognizers = gestureRecognizers
        }
        
        public static func == (lhs: SharedAppearance.Common, rhs: SharedAppearance.Common) -> Bool {
            lhs.isUserInteractionEnabled?.wrappedValue == rhs.isUserInteractionEnabled?.wrappedValue &&
            lhs.alpha?.wrappedValue == rhs.alpha?.wrappedValue &&
            lhs.contentMode?.wrappedValue == rhs.contentMode?.wrappedValue &&
            lhs.backgroundColor?.wrappedValue == rhs.backgroundColor?.wrappedValue &&
            lhs.clipsToBounds?.wrappedValue == rhs.clipsToBounds?.wrappedValue &&
            lhs.isHidden?.wrappedValue == rhs.isHidden?.wrappedValue &&
            lhs.gestureRecognizers?.wrappedValue == rhs.gestureRecognizers?.wrappedValue
        }
    }
}

/// Defines predefined values for `SharedAppearance.Priority` struct to be used in UI components.
extension SharedAppearance.Priority {
    /// A priority that allows the component to have a low hugging and compression resistance
    public static let shrinkAll = SharedAppearance.Priority(
        verticalHuggingPriority: .required,
        verticalCompressPriority: .init(249),
        horizontalHuggingPriority: .required,
        horizontalCompressPriority: .init(249)
    )
    
    /// A priority that allows the component to fill its content in the vertical axis.
    public static let fillVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .init(249),
        verticalCompressPriority: .required
    )

    /// A priority that allows the component to shrink its content in the vertical axis.
    public static let shrinkVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .required,
        verticalCompressPriority: .init(249)
    )

    /// A priority that allows the component to fill its content in the horizontal axis.
    public static let fillHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .init(249),
        horizontalCompressPriority: .required
    )

    /// A priority that allows the component to shrink its content in the horizontal axis.
    public static let shrinkHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .required,
        horizontalCompressPriority: .init(249)
    )
}

extension UIView {
    /// Updates the constraint priority of the view with the given priority.
    ///
    /// - Parameters:
    ///     - priority: The priority to set for the constraint.
    public func updateConstraintPriority(with priority: SharedAppearance.Priority) {
        if let verticalHuggingPriority = priority.verticalHuggingPriority {
            setContentHuggingPriority(verticalHuggingPriority, for: .vertical)
        }
        if let verticalCompressPriority = priority.verticalCompressPriority {
            setContentCompressionResistancePriority(verticalCompressPriority, for: .vertical)
        }
        if let horizontalHuggingPriority = priority.horizontalHuggingPriority {
            setContentHuggingPriority(horizontalHuggingPriority, for: .horizontal)
        }
        if let horizontalCompressPriority = priority.horizontalCompressPriority {
            setContentCompressionResistancePriority(horizontalCompressPriority, for: .horizontal)
        }
    }
    
    /// Updates the constraint priority of the view with the given priority.
    ///
    /// - Parameters:
    ///     - priority: The priority to set for the constraint.
    public func updateConstraintPriority(
        with priority: MBinding<SharedAppearance.Priority>,
        cancellables: inout Set<AnyCancellable>
    ) {
        priority.publisher
            .sink { [weak self] priority in
                if let verticalHuggingPriority = priority.verticalHuggingPriority {
                    self?.setContentHuggingPriority(verticalHuggingPriority, for: .vertical)
                }
                if let verticalCompressPriority = priority.verticalCompressPriority {
                    self?.setContentCompressionResistancePriority(verticalCompressPriority, for: .vertical)
                }
                if let horizontalHuggingPriority = priority.horizontalHuggingPriority {
                    self?.setContentHuggingPriority(horizontalHuggingPriority, for: .horizontal)
                }
                if let horizontalCompressPriority = priority.horizontalCompressPriority {
                    self?.setContentCompressionResistancePriority(horizontalCompressPriority, for: .horizontal)
                }
            }
            .store(in: &cancellables)
    }

    /// Updates the layer of the view with the given layer
    ///
    /// - Parameters:
    ///     - layer: The `SharedAppearance.Layer` to be applied to the view's layer.
    public func updateLayer(with layer: SharedAppearance.Layer, cancellables: inout Set<AnyCancellable>) {
        CancellableStorage(in: &cancellables) {
            layer.borderWidth?.publisher
                .weakAssign(to: \.layer.borderWidth, on: self)
            layer.masksToBounds?.publisher
                .weakAssign(to: \.layer.masksToBounds, on: self)
            layer.cornerRadius?.publisher
                .sink { [weak self] cornerRadius in
                    self?.roundCorners(
                        radius: cornerRadius,
                        corners: layer.cornersToRound?.wrappedValue ?? [.allCorners]
                    )
                }
            layer.cornersToRound?.publisher
                .sink { [weak self] cornersToRound in
                    self?.roundCorners(radius: layer.cornerRadius?.wrappedValue ?? .zero, corners: cornersToRound)
                }
            layer.borderColor?.publisher
                .sink {  [weak self] borderColor in
                    self?.layer.borderColor = borderColor.cgColor
                }
            layer.shadow?.publisher
                .sink { [weak self] shadow in
                    self?.layer.shadowRadius = shadow.radius
                    self?.layer.shadowColor = shadow.color.cgColor
                    self?.layer.shadowOpacity = shadow.opacity
                    self?.layer.shadowOffset = CGSize(width: shadow.offsetX, height: shadow.offsetY)
                }
        }
    }

    /// Updates the appearance of the current object with the provided common appearance object.
    ///
    /// - Parameters:
    ///     - common: The common appearance object to be applied to the current object.
    public func updateCommon(with common: SharedAppearance.Common, cancellables: inout Set<AnyCancellable>) {
        CancellableStorage(in: &cancellables) {
            common.isUserInteractionEnabled?.publisher
                .weakAssign(to: \.isUserInteractionEnabled, on: self)
            common.alpha?.publisher
                .weakAssign(to: \.alpha, on: self)
            common.contentMode?.publisher
                .weakAssign(to: \.contentMode, on: self)
            common.backgroundColor?.publisher
                .weakAssign(to: \.backgroundColor, on: self)
            common.clipsToBounds?.publisher
                .weakAssign(to: \.clipsToBounds, on: self)
            common.isHidden?.publisher
                .weakAssign(to: \.isHidden, on: self)
            common.gestureRecognizers?.publisher
                .weakAssign(to: \.gestureRecognizers, on: self)
        }
    }
}
