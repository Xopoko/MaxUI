import UIKit
public extension MView {
    /// Wraps a `MView` instance to a `Container`
    ///
    /// - Returns: The `Container` representation of the `MView` instance
    func toContainer() -> Container {
        Container { self }
    }

    /// Wraps the `MView` in a new `Gradient` with appearance
    ///
    /// - Parameters:
    ///     - layer: The shared appearance of the `Gradient` layer. Default is new instance of SharedAppearance.Layer.
    ///     - colors: An array of `UIColor` instances that define the gradient.  Default is `[]`.
    ///     - locations: An array of `NSNumber` instances that represent the location of each color stop in the gradient.  Default is `[0, 1]`.
    ///     - startPoint: The start point of the gradient, defined as a `CGPoint` value.  Default is `CGPoint(x: 0, y: 0)`.
    ///     - endPoint: The end point of the gradient, defined as a `CGPoint` value.  Default is `CGPoint(x: 1, y: 1)`.
    ///     - type: The type of gradient to be applied, specified as a `CAGradientLayerType`.  Default is `.axial`.
    ///
    /// - Returns: The `Gradient` representation of the `MView` instance with gradient applied
    func gradient(
        layer: SharedAppearance.Layer = .init(),
        colors: [UIColor] = [],
        locations: [NSNumber] = [0, 1],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 1, y: 1),
        type: CAGradientLayerType = .axial
    ) -> Gradient {
        let appearance = Gradient.Appearance(
            layer: layer,
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint,
            type: type
        )
        return Gradient { self }.style(appearance)
    }

    /// Wraps the `MView` in a new `Gradient` with appearance
    ///
    /// - Parameter appearance: The appearance of the `Gradient`.
    /// - Returns: The `Gradient` representation of the `MView` instance with gradient applied
    func gradient(_ appearance: Gradient.Appearance) -> Gradient {
        return Gradient { self }.style(appearance)
    }

    /// Converts a `MView` instance to a `TapableContainer`
    ///
    /// - Parameters:
    ///     - appearance: The appearance of the tapable `Container`.
    ///     - action: The closure to be executed upon tapping the container.
    ///
    /// - Returns: The `TapableContainer` representation of the `MView` instance
    func toTapableContainer(
        _ appearance: TapableContainerView.Appearance,
        _ action: (() -> Void)?
    ) -> TapableContainer {
        TapableContainer(model: self, appearance: appearance, action)
    }
}

extension MView {
    /// Converts the `MView` to a `Container` if it is not already one.
    ///
    /// - Returns: A `DeclaratableContainerView` instance.
    private func toContainerIfNeeded() -> Containerable {
        return (self as? Containerable) ?? Container { self }
    }

    /// Updates the specified property on the container view with the provided value.
    ///
    /// - Parameters:
    ///     - property: A writable key path to a property on the container view.
    ///     - value: The value to set the property to.
    ///
    /// - Returns: The view model instance, for chaining purposes.
    private func updateContainer<T>(
        _ property: WritableKeyPath<ContainerView.Appearance, T>,
        setTo value: T
    ) -> MView {
        let declarativeContainer = toContainerIfNeeded()
        declarativeContainer.containerAppearance?[keyPath: property] = value
        return declarativeContainer
    }

    /// Sets the insets for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter insets: The UIEdgeInsets for all four edges.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func insets(_ insets: UIEdgeInsets) -> MView {
        updateContainer(\.layout.insets, setTo: insets)
    }

    /// Sets the insets for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - left: The inset for the left edge.  Default is `.zero`.
    ///     - right: The inset for the right edge.  Default is `.zero`.
    ///     - top: The inset for the top edge.  Default is `.zero`.
    ///     - bottom: The inset for the bottom edge.  Default is `.zero`.
    ///
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func insets(
        left: CGFloat = .zero,
        right: CGFloat = .zero,
        top: CGFloat = .zero,
        bottom: CGFloat = .zero
    ) -> MView {
        updateContainer(
            \.layout.insets,
            setTo: .init(top: top, left: left, bottom: bottom, right: right)
        )
    }

    /// Sets the insets for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter all: The inset for all four edges.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func insets(_ all: CGFloat) -> MView {
        updateContainer(\.layout.insets, setTo: .init(top: all, left: all, bottom: all, right: all))
    }

    /// Sets the insets for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - horizontal: The inset for left and right edges.  Default is `.zero`.
    ///     - vertical: The inset for top and bottom edges.  Default is `.zero`.
    ///
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func insets(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) -> MView {
        updateContainer(
            \.layout.insets,
             setTo: .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        )
    }

    /// Sets the width of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter width: The new width to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func width(_ width: CGFloat) -> MView {
        updateContainer(\.layout.width, setTo: width)
    }

    /// Sets the height of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter height: The new height to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func height(_ height: CGFloat) -> MView {
        updateContainer(\.layout.height, setTo: height)
    }

    /// Sets both the height and width of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - height: The new height to set.
    ///     - width: The new width to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func size(height: CGFloat, width: CGFloat) -> MView {
        updateContainer(\.layout.height, setTo: height)
        .updateContainer(\.layout.width, setTo: width)
    }

    /// Sets both the height and width of the `Container` layout to
    /// match the given size.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter size: The new size to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func size(_ size: CGSize) -> MView {
        updateContainer(\.layout.height, setTo: size.height)
        .updateContainer(\.layout.width, setTo: size.width)
    }

    /// Sets both the height and width of the `Container` layout to
    /// the given value, making the layout a square.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter squared: The new value to set for both height and width.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func size(squared: CGFloat) -> MView {
        updateContainer(\.layout.height, setTo: squared)
        .updateContainer(\.layout.width, setTo: squared)
    }

    /// Sets the center Y position for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter centerY: The Y position of the center.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func centerY(_ centerY: CGFloat) -> MView {
        updateContainer(\.layout.centerY, setTo: centerY)
    }

    /// Sets the center X position for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter centerX: The X position of the center.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func centerX(_ centerX: CGFloat) -> MView {
        updateContainer(\.layout.centerX, setTo: centerX)
    }

    /// Sets the priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The priority of the appearance.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func priority(_ priority: SharedAppearance.Priority) -> MView {
        updateContainer(\.priority, setTo: priority)
    }

    /// Sets the vertical hugging priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The vertical hugging priority.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func verticalHuggingPriority(_ priority: UILayoutPriority) -> MView {
        updateContainer(\.priority.verticalHuggingPriority, setTo: priority)
    }

    /// Sets the vertical compression priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The vertical compression priority.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func verticalCompressPriority(_ priority: UILayoutPriority) -> MView {
        updateContainer(\.priority.verticalCompressPriority, setTo: priority)
    }

    /// Sets the horizontal hugging priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The horizontal hugging priority.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func horizontalHuggingPriority(_ priority: UILayoutPriority) -> MView {
        updateContainer(\.priority.horizontalHuggingPriority, setTo: priority)
    }

    /// Sets the horizontal compression priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The horizontal compression priority.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func horizontalCompressPriority(_ priority: UILayoutPriority) -> MView {
        updateContainer(\.priority.horizontalCompressPriority, setTo: priority)
    }

    /// Sets the corner radius for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - cornerRadius: The corner radius value to set.
    ///     - masksToBounds: The value to set for the `masksToBounds` property. Default is `true`.
    ///
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat, masksToBounds: Bool = true) -> MView {
        updateContainer(\.layer.cornerRadius, setTo: cornerRadius)
        .updateContainer(\.layer.masksToBounds, setTo: masksToBounds)
    }

    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func cornersToRound(_ cornersToRound: [UIRectCorner]) -> MView {
        updateContainer(\.layer.cornersToRound, setTo: cornersToRound)
    }

    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> MView {
        updateContainer(\.layer.borderWidth, setTo: borderWidth)
    }

    /// Sets the border color for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter borderColor: The border color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderColor(_ borderColor: UIColor) -> MView {
        updateContainer(\.layer.borderColor, setTo: borderColor)
    }

    /// Sets the `masksToBounds` property for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter masksToBounds: The value to set for the `masksToBounds` property.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func masksToBounds(_ masksToBounds: Bool) -> MView {
        updateContainer(\.layer.masksToBounds, setTo: masksToBounds)
    }

    /// Sets the `shadow` of the `Container` layer to the given shadow value.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter shadow: The new shadow to set.
    /// - Returns: The updated MView
    @discardableResult
    public func shadow(_ shadow: SharedAppearance.Layer.Shadow) -> MView {
        return updateContainer(\.layer.shadow, setTo: shadow)
    }

    /// Sets the shadow of the `Container` layer to the given parameters.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - offsetX: The shadow's x offset. Default is `nil`.
    ///     - offsetY: The shadow's y offset. Default is `nil`.
    ///     - color: The shadow's color. Default is `nil`.
    ///     - opacity: The shadow's opacity. Default is `nil`.
    ///     - radius: The shadow's radius. Default is `nil`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func shadow(
        offsetX: CGFloat? = nil,
        offsetY: CGFloat? = nil,
        color: UIColor? = nil,
        opacity: Float? = nil,
        radius: CGFloat? = nil
    ) -> MView {
        let shadowApperance = SharedAppearance.Layer.Shadow(
            offsetX: offsetX,
            offsetY: offsetY,
            color: color,
            opacity: opacity,
            radius: radius
        )
        return updateContainer(\.layer.shadow, setTo: shadowApperance)
    }

    /// Enables or disables user interaction on the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isUserInteractionEnabled: Boolean value indicating whether user interaction is enabled.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> MView {
        updateContainer(\.common.isUserInteractionEnabled, setTo: isUserInteractionEnabled)
    }

    /// Sets the alpha of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter alpha: The new alpha to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> MView {
        updateContainer(\.common.alpha, setTo: alpha)
    }

    /// Sets the content mode of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter contentMode: The new content mode to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> MView {
        updateContainer(\.common.contentMode, setTo: contentMode)
    }

    /// Sets the background color of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter backgroundColor: The new background color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor) -> MView {
        updateContainer(\.common.backgroundColor, setTo: backgroundColor)
    }

    /// Controls whether the `Container` clips its content to its bounds.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter clipsToBounds: Boolean value indicating whether to clip the content to bounds.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: Bool) -> MView {
        updateContainer(\.common.clipsToBounds, setTo: clipsToBounds)
    }

    /// Makes the `Container` layer hidden or visible.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isHidden: Boolean value indicating whether the layer is hidden.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> MView {
        updateContainer(\.common.isHidden, setTo: isHidden)
    }

    /// Wraps a `MView` in a new `TapableContainer`
    ///
    /// - Parameters:
    ///     - animation: The animation of the TapableContainer. Default is `.scale`.
    ///     - didSelect: The closure to be executed upon tapping the `MView`.
    ///
    /// - Returns: The `TapableContainer` representation of the `MView` instance
    @discardableResult
    public func onSelect(
        animation: TapableView.HighlightBehavior = .scale,
        _ didSelect: (() -> Void)?
    ) -> MView {
        toTapableContainer(.init(highlightBehavior: animation), didSelect)
    }
}
