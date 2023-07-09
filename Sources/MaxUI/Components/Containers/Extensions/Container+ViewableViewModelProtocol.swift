import UIKit
// swiftlint:disable file_length
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
    
    /// Sets the maximum height of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter height: The new maximum height to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func heightLessOrEqual(_ height: CGFloat) -> MView {
        updateContainer(\.layout.heightLessOrEqual, setTo: height)
    }

    /// Sets the maximum width of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter width: The new maximum width to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func widthLessOrEqual(_ width: CGFloat) -> MView {
        updateContainer(\.layout.widthLessOrEqual, setTo: width)
    }

    /// Sets the minimum height of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter height: The new minimum height to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func heightGreaterOrEqual(_ height: CGFloat) -> MView {
        updateContainer(\.layout.heightGreaterOrEqual, setTo: height)
    }

    /// Sets the minimum width of the `Container` layout.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter width: The new minimum width to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func widthGreaterOrEqual(_ width: CGFloat) -> MView {
        updateContainer(\.layout.widthGreaterOrEqual, setTo: width)
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
    public func priority(_ priority: MBinding<SharedAppearance.Priority>) -> MView {
        if let declarative = self as? DeclarativePriority {
            return declarative.priority(priority)
        } else {
            return updateContainer(\.priority, setTo: priority)
        }
    }

    /// Sets the priority for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter priority: The priority of the appearance.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func priority(_ priority: SharedAppearance.Priority) -> MView {
        self.priority(.constant(priority))
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
    public func cornerRadius(
        _ cornerRadius: MBinding<CGFloat>,
        masksToBounds: MBinding<Bool> = .constant(true)
    ) -> MView {
        if let declarative = self as? DeclarativeCornerRadius & DeclarativeMasksToBounds {
            return declarative
                .cornerRadius(cornerRadius)
                .masksToBounds(masksToBounds)
        } else {
            return updateContainer(\.layer.cornerRadius, setTo: cornerRadius)
                .updateContainer(\.layer.masksToBounds, setTo: masksToBounds)
        }
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
        self.cornerRadius(.constant(cornerRadius), masksToBounds: .constant(masksToBounds))
    }
    
    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func cornersToRound(_ cornersToRound: MBinding<[UIRectCorner]>) -> MView {
        if let declarative = self as? DeclarativeCornersToRound {
            return declarative.cornersToRound(cornersToRound)
        } else {
            return updateContainer(\.layer.cornersToRound, setTo: cornersToRound)
        }
    }

    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func cornersToRound(_ cornersToRound: [UIRectCorner]) -> MView {
        self.cornersToRound(.constant(cornersToRound))
    }
    
    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderWidth(_ borderWidth: MBinding<CGFloat>) -> MView {
        if let declarative = self as? DeclarativeBorderWidth {
            return declarative.borderWidth(borderWidth)
        } else {
            return updateContainer(\.layer.borderWidth, setTo: borderWidth)
        }
    }

    /// Sets the corners to round for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter cornersToRound: The corners to round, specified as an array of `UIRectCorner`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> MView {
        self.borderWidth(.constant(borderWidth))
    }
    
    /// Sets the border color for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter borderColor: The border color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderColor(_ borderColor: MBinding<UIColor>) -> MView {
        if let declarative = self as? DeclarativeBorderColor {
            return declarative.borderColor(borderColor)
        } else {
            return updateContainer(\.layer.borderColor, setTo: borderColor)
        }
    }

    /// Sets the border color for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter borderColor: The border color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func borderColor(_ borderColor: UIColor) -> MView {
        self.borderColor(.constant(borderColor))
    }
    
    /// Sets the `masksToBounds` property for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter masksToBounds: The value to set for the `masksToBounds` property.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func masksToBounds(_ masksToBounds: MBinding<Bool>) -> MView {
        if let declarative = self as? DeclarativeMasksToBounds {
            return declarative.masksToBounds(masksToBounds)
        } else {
            return updateContainer(\.layer.masksToBounds, setTo: masksToBounds)
        }
    }

    /// Sets the `masksToBounds` property for a `MView`.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter masksToBounds: The value to set for the `masksToBounds` property.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func masksToBounds(_ masksToBounds: Bool) -> MView {
        self.masksToBounds(.constant(masksToBounds))
    }
    
    /// Sets the `shadow` of the `Container` layer to the given shadow value.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter shadow: The new shadow to set.
    /// - Returns: The updated MView
    @discardableResult
    public func shadow(_ shadow: MBinding<SharedAppearance.Layer.Shadow>) -> MView {
        if let declarative = self as? DeclarativeShadow {
            return declarative.shadow(shadow)
        } else {
            return updateContainer(\.layer.shadow, setTo: shadow)
        }
    }

    /// Sets the `shadow` of the `Container` layer to the given shadow value.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter shadow: The new shadow to set.
    /// - Returns: The updated MView
    @discardableResult
    public func shadow(_ shadow: SharedAppearance.Layer.Shadow) -> MView {
        self.shadow(.constant(shadow))
    }

    /// Sets the shadow of the `Container` layer to the given parameters.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameters:
    ///     - offsetX: The shadow's x offset. Default is `0`.
    ///     - offsetY: The shadow's y offset. Default is `-3`.
    ///     - color: The shadow's color. Default is `UIColor.black`.
    ///     - opacity: The shadow's opacity. Default is `0`.
    ///     - radius: The shadow's radius. Default is `3`.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func shadow(
        offsetX: CGFloat = .zero,
        offsetY: CGFloat = -3,
        color: UIColor = .black,
        opacity: Float = 0,
        radius: CGFloat = 3
    ) -> MView {
        let shadowApperance = SharedAppearance.Layer.Shadow(
            offsetX: offsetX,
            offsetY: offsetY,
            color: color,
            opacity: opacity,
            radius: radius
        )
        return self.shadow(.constant(shadowApperance))
    }

    /// Enables or disables user interaction on the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isUserInteractionEnabled: Boolean value indicating whether user interaction is enabled.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isUserInteractionEnabled(_ isUserInteractionEnabled: MBinding<Bool>) -> MView {
        if let declarative = self as? DeclarativeIsUserInteractionEnabled {
            return declarative.isUserInteractionEnabled(isUserInteractionEnabled)
        } else {
            return updateContainer(\.common.isUserInteractionEnabled, setTo: isUserInteractionEnabled)
        }
    }
    
    /// Enables or disables user interaction on the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isUserInteractionEnabled: Boolean value indicating whether user interaction is enabled.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> MView {
        self.isUserInteractionEnabled(.constant(isUserInteractionEnabled))
    }

    /// Sets the alpha of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter alpha: The new alpha to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func alpha(_ alpha: MBinding<CGFloat>) -> MView {
        if let declarative = self as? DeclarativeAlpha {
            return declarative.alpha(alpha)
        } else {
            return updateContainer(\.common.alpha, setTo: alpha)
        }
    }
    
    /// Sets the alpha of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter alpha: The new alpha to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> MView {
        self.alpha(.constant(alpha))
    }

    /// Sets the content mode of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter contentMode: The new content mode to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func contentMode(_ contentMode: MBinding<UIView.ContentMode>) -> MView {
        if let declarative = self as? DeclarativeContentMode {
            return declarative.contentMode(contentMode)
        } else {
            return updateContainer(\.common.contentMode, setTo: contentMode)
        }
    }
    
    /// Sets the content mode of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter contentMode: The new content mode to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> MView {
        self.contentMode(.constant(contentMode))
    }

    /// Sets the background color of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter backgroundColor: The new background color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func backgroundColor(_ backgroundColor: MBinding<UIColor?>) -> MView {
        if let declarative = self as? DeclarativeBackgroundColor {
            return declarative.backgroundColor(backgroundColor)
        } else {
            return updateContainer(\.common.backgroundColor, setTo: backgroundColor)
        }
    }
    
    /// Sets the background color of the `Container` layer.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter backgroundColor: The new background color to set.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor?) -> MView {
        self.backgroundColor(.constant(backgroundColor))
    }

    /// Controls whether the `Container` clips its content to its bounds.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter clipsToBounds: Boolean value indicating whether to clip the content to bounds.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: MBinding<Bool>) -> MView {
        if let declarative = self as? DeclarativeClipsToBounds {
            return declarative.clipsToBounds(clipsToBounds)
        } else {
            return updateContainer(\.common.clipsToBounds, setTo: clipsToBounds)
        }
    }
    
    /// Controls whether the `Container` clips its content to its bounds.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter clipsToBounds: Boolean value indicating whether to clip the content to bounds.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: Bool) -> MView {
        self.clipsToBounds(.constant(clipsToBounds))
    }

    /// Makes the `Container` layer hidden or visible.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isHidden: Boolean value indicating whether the layer is hidden.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isHidden(_ isHidden: MBinding<Bool>) -> MView {
        if let declarative = self as? DeclarativeIsHidden {
            return declarative.isHidden(isHidden)
        } else {
            return updateContainer(\.common.isHidden, setTo: isHidden)
        }
    }
    
    /// Makes the `Container` layer hidden or visible.
    /// Wraps a `MView` in a new `Container` or changes an existing one.
    ///
    /// - Parameter isHidden: Boolean value indicating whether the layer is hidden.
    /// - Returns: The updated `MView` instance.
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> MView {
        self.isHidden(.constant(isHidden))
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
        animation: TapableView.HighlightBehavior = .alpha,
        _ didSelect: (() -> Void)?
    ) -> TapableContainer {
        toTapableContainer(.init(highlightBehavior: animation), didSelect)
    }
}

// swiftlint:enable file_length
