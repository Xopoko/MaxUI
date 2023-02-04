import UIKit

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

        /// Initializes layout attributes with the specified width, height and insets.
        ///
        /// - Parameters:
        ///     - insets: The edge insets of the view.
        ///     - width: The width of the view.
        ///     - height: The height of the view.
        public init(
            insets: UIEdgeInsets = .zero,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self.insets = insets
            self.width = width
            self.height = height
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
            /// The offset on the x-axis of the shadow from the layer.
            public let offsetX: CGFloat?
            /// The offset on the y-axis of the shadow from the layer.
            public let offsetY: CGFloat?
            /// The color of the shadow.
            public let color: UIColor?
            /// The opacity of the shadow.
            public let opacity: Float?
            /// The radius of the shadow.
            public let radius: CGFloat?

            /// Initializes a shadow with specified parameters.
            ///
            /// - Parameters:
            ///   - offsetX: The offset on the x-axis of the shadow from the layer.
            ///   - offsetY: The offset on the y-axis of the shadow from the layer.
            ///   - color: The color of the shadow.
            ///   - opacity: The opacity of the shadow.
            ///   - radius: The radius of the shadow.
            public init(
                offsetX: CGFloat? = nil,
                offsetY: CGFloat? = nil,
                color: UIColor? = nil,
                opacity: Float? = nil,
                radius: CGFloat? = nil
            ) {
                self.offsetX = offsetX
                self.offsetY = offsetY
                self.color = color
                self.opacity = opacity
                self.radius = radius
            }
        }

        /// The radius of the rounded corners of the layer.
        public var cornerRadius: CGFloat?
        /// An array of corners to round.
        public var cornersToRound: [UIRectCorner]?
        /// The width of the border of the layer.
        public var borderWidth: CGFloat?
        /// The color of the border of the layer.
        public var borderColor: UIColor?
        /// The shadow for the layer.
        public var shadow: Shadow?
        /// A Boolean value indicating whether the layer's content should be clipped to the bounds.
        public var masksToBounds: Bool?

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
            cornerRadius: CGFloat? = nil,
            cornersToRound: [UIRectCorner]? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: UIColor? = nil,
            shadow: Shadow? = nil,
            masksToBounds: Bool? = nil
        ) {
            self.cornerRadius = cornerRadius
            self.cornersToRound = cornersToRound
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.shadow = shadow
            self.masksToBounds = masksToBounds
        }
    }

    /// A structure that contains common properties of a `UIView`.
    ///
    /// Common contains a set of optional properties that can be used to configure the appearance of a `UIView`.
    public struct Common: Equatable, Withable {
        /// A Boolean value indicating whether user interactions are enabled for the view.
        public var isUserInteractionEnabled: Bool?
        /// The opacity of the view.
        public var alpha: CGFloat?
        /// The way the view's content should be scaled and positioned.
        public var contentMode: UIView.ContentMode?
        /// The background color of the view.
        public var backgroundColor: UIColor?
        /// A Boolean value indicating whether the view should be clipped to its bounds.
        public var clipsToBounds: Bool?
        /// A Boolean value indicating whether the view is hidden.
        public var isHidden: Bool?

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
            isUserInteractionEnabled: Bool? = nil,
            alpha: CGFloat? = nil,
            contentMode: UIView.ContentMode? = nil,
            backgroundColor: UIColor? = nil,
            clipsToBounds: Bool? = nil,
            isHidden: Bool? = nil
        ) {
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.alpha = alpha
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
            self.clipsToBounds = clipsToBounds
            self.isHidden = isHidden
        }
    }

}

/// Defines predefined values for `SharedAppearance.Priority` struct to be used in UI components.
extension SharedAppearance.Priority {
    /// A priority that allows the component to have a low hugging and compression resistance
    /// in the vertical axis.
    public static let flexibleVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .defaultLow,
        verticalCompressPriority: .defaultLow
    )

    /// A priority that allows the component to have a low hugging and compression resistance
    /// in the horizontal axis.
    public static let flexibleHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .defaultLow,
        horizontalCompressPriority: .defaultLow
    )

    /// A priority that allows the component to have a low hugging and compression resistance
    /// in the vertical axis.
    public static let rigidVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .defaultLow,
        verticalCompressPriority: .defaultLow
    )

    /// A priority that allows the component to have a low hugging and compression resistance
    /// in the horizontal axis.
    public static let rigidHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .defaultLow,
        horizontalCompressPriority: .defaultLow
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

    /// Updates the layer of the view with the given layer
    ///
    /// - Parameters:
    ///     - layer: The `SharedAppearance.Layer` to be applied to the view's layer.
    public func updateLayer(with layer: SharedAppearance.Layer) {
        if let cornerRadius = layer.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let cornersToRound = layer.cornersToRound,
           let cornerRadius = layer.cornerRadius {
            roundCorners(radius: cornerRadius, corners: cornersToRound)
        }
        if let borderColor = layer.borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = layer.borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let masksToBounds = layer.masksToBounds {
            self.layer.masksToBounds = masksToBounds
        }

        if let radius = layer.shadow?.radius {
            self.layer.shadowRadius = radius
        }
        if let color = layer.shadow?.color?.cgColor {
            self.layer.shadowColor = color
        }
        if let opacity = layer.shadow?.opacity {
            self.layer.shadowOpacity = opacity
        }
        if layer.shadow?.offsetX != nil || layer.shadow?.offsetY != nil {
            self.layer.shadowOffset = CGSize(
                width: layer.shadow?.offsetX ?? .zero,
                height: layer.shadow?.offsetY ?? .zero
            )
        }
    }

    /// Updates the appearance of the current object with the provided common appearance object.
    ///
    /// - Parameters:
    ///     - common: The common appearance object to be applied to the current object.
    public func updateCommon(with common: SharedAppearance.Common) {
        if let isUserInteractionEnabled = common.isUserInteractionEnabled {
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
        if let alpha = common.alpha {
            self.alpha = alpha
        }
        if let contentMode = common.contentMode {
            self.contentMode = contentMode
        }
        if let backgroundColor = common.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let clipToBounds = common.clipsToBounds {
            self.clipsToBounds = clipToBounds
        }
        if let isHidden = common.isHidden {
            self.isHidden = isHidden
        }
    }
}
