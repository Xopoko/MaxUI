import UIKit

public extension ViewableViewModelProtocol {
    func toContainer() -> Container {
        Container { self }
    }
    
    func toCenter(axis: NSLayoutConstraint.Axis = .vertical) -> StackView.Model {
        StackView.Model(models: [self], appearance: .init(axis: axis, alignment: .center))
    }
    
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
    
    func toTapableContainer(
        _ appearance: TapableContainerView.Appearance,
        _ action: (() -> Void)?
    ) -> TapableContainer {
        TapableContainer(model: self, appearance: appearance, action)
    }
}

extension ViewableViewModelProtocol {
    private func toContainerIfNeeded() -> DeclaratableContainerViewAppearance {
        return (self as? DeclaratableContainerViewAppearance) ?? Container { self }
    }
    
    private func updateContainer<T>(
        _ property: WritableKeyPath<ContainerView.Appearance, T>,
        setTo value: T
    ) -> ViewableViewModelProtocol {
        let declarativeContainer = toContainerIfNeeded()
        declarativeContainer.containerAppearance?[keyPath: property] = value
        return declarativeContainer
    }
    
    @discardableResult
    public func insets(_ insets: UIEdgeInsets) -> ViewableViewModelProtocol {
        updateContainer(\.layout.insets, setTo: insets)
    }
    
    @discardableResult
    public func insets(
        left: CGFloat = .zero,
        right: CGFloat = .zero,
        top: CGFloat = .zero,
        bottom: CGFloat = .zero
    ) -> ViewableViewModelProtocol {
        updateContainer(
            \.layout.insets,
             setTo: .init(top: top, left: left, bottom: bottom, right: right)
        )
    }
    
    @discardableResult
    public func insets(_ all: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layout.insets, setTo: .init(top: all, left: all, bottom: all, right: all))
    }
    
    @discardableResult
    public func insets(
        horizontal: CGFloat = .zero,
        vertical: CGFloat = .zero
    ) -> ViewableViewModelProtocol {
        updateContainer(
            \.layout.insets,
             setTo: .init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        )
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layout.width, setTo: width)
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layout.height, setTo: height)
    }
    
    @discardableResult
    public func size(height: CGFloat, width: CGFloat) -> ViewableViewModelProtocol {
        let update = updateContainer(\.layout.height, setTo: height)
        return update.updateContainer(\.layout.width, setTo: width)
    }
    
    @discardableResult
    public func size(_ size: CGSize) -> ViewableViewModelProtocol {
        let update = updateContainer(\.layout.height, setTo: size.height)
        return update.updateContainer(\.layout.width, setTo: size.width)
    }
    
    @discardableResult
    public func size(squared: CGFloat) -> ViewableViewModelProtocol {
        let update = updateContainer(\.layout.height, setTo: squared)
        return update.updateContainer(\.layout.width, setTo: squared)
    }
    
    @discardableResult
    public func centerY(_ centerY: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layout.centerY, setTo: centerY)
    }
    
    @discardableResult
    public func centerX(_ centerX: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layout.centerX, setTo: centerX)
    }
    
    @discardableResult
    public func priority(_ priority: SharedAppearance.Priority) -> ViewableViewModelProtocol {
        updateContainer(\.priority, setTo: priority)
    }
    
    @discardableResult
    public func verticalHuggingPriority(_ priority: UILayoutPriority) -> ViewableViewModelProtocol {
        updateContainer(\.priority.verticalHuggingPriority, setTo: priority)
    }
    
    @discardableResult
    public func verticalCompressPriority(
        _ priority: UILayoutPriority
    ) -> ViewableViewModelProtocol {
        updateContainer(\.priority.verticalCompressPriority, setTo: priority)
    }
    
    @discardableResult
    public func horizontalHuggingPriority(
        _ priority: UILayoutPriority
    ) -> ViewableViewModelProtocol {
        updateContainer(\.priority.horizontalHuggingPriority, setTo: priority)
    }
    
    @discardableResult
    public func horizontalCompressPriority(
        _ priority: UILayoutPriority
    ) -> ViewableViewModelProtocol {
        updateContainer(\.priority.horizontalCompressPriority, setTo: priority)
    }
    
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layer.cornerRadius, setTo: cornerRadius)
    }
    
    @discardableResult
    public func cornersToRound(_ cornersToRound: [UIRectCorner]) -> ViewableViewModelProtocol {
        updateContainer(\.layer.cornersToRound, setTo: cornersToRound)
    }
    
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.layer.borderWidth, setTo: borderWidth)
    }
    
    @discardableResult
    public func borderColor(_ borderColor: UIColor) -> ViewableViewModelProtocol {
        updateContainer(\.layer.borderColor, setTo: borderColor)
    }
    
    @discardableResult
    public func masksToBounds(_ masksToBounds: Bool) -> ViewableViewModelProtocol {
        updateContainer(\.layer.masksToBounds, setTo: masksToBounds)
    }
    
    @discardableResult
    public func shadow(
        offsetX: CGFloat? = nil,
        offsetY: CGFloat? = nil,
        color: UIColor? = nil,
        opacity: Float? = nil,
        radius: CGFloat? = nil
    ) -> ViewableViewModelProtocol {
        let shadowApperance = SharedAppearance.Layer.Shadow(
            offsetX: offsetX,
            offsetY: offsetY,
            color: color,
            opacity: opacity,
            radius: radius
        )
        return updateContainer(\.layer.shadow, setTo: shadowApperance)
    }
    
    @discardableResult
    public func isUserInteractionEnabled(
        _ isUserInteractionEnabled: Bool
    ) -> ViewableViewModelProtocol {
        updateContainer(\.common.isUserInteractionEnabled, setTo: isUserInteractionEnabled)
    }
    
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> ViewableViewModelProtocol {
        updateContainer(\.common.alpha, setTo: alpha)
    }
    
    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> ViewableViewModelProtocol {
        updateContainer(\.common.contentMode, setTo: contentMode)
    }
    
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor) -> ViewableViewModelProtocol {
        updateContainer(\.common.backgroundColor, setTo: backgroundColor)
    }
    
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: Bool) -> ViewableViewModelProtocol {
        updateContainer(\.common.clipsToBounds, setTo: clipsToBounds)
    }
    
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> ViewableViewModelProtocol {
        updateContainer(\.common.isHidden, setTo: isHidden)
    }
}

extension ViewableViewModelProtocol {
    @discardableResult
    public func onSelect(
        animation: TapableView.HighlightBehavior = .scale,
        _ didSelect: (() -> Void)?
    ) -> ViewableViewModelProtocol {
        toTapableContainer(.init(highlightBehavior: animation), didSelect)
    }
}
