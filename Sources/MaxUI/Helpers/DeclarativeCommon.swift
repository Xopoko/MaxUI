import UIKit
import Combine

protocol DeclarativeCommon: MView,
                            Withable,
                            DeclarativeIsUserInteractionEnabled,
                            DeclarativeAlpha,
                            DeclarativeContentMode,
                            DeclarativeBackgroundColor,
                            DeclarativeClipsToBounds,
                            DeclarativeIsHidden,
                            DeclarativePriority,
                            DeclarativeCornerRadius,
                            DeclarativeCornersToRound,
                            DeclarativeBorderWidth,
                            DeclarativeBorderColor,
                            DeclarativeShadow,
                            DeclarativeMasksToBounds {}

protocol DeclarativeIsUserInteractionEnabled: MView {
    var isUserInteractionEnabled: MBinding<Bool>? { get set }
    func isUserInteractionEnabled(_ isUserInteractionEnabled: MBinding<Bool>) -> Self
}

protocol DeclarativeAlpha: MView {
    var alpha: MBinding<CGFloat>? { get set }
    func alpha(_ alpha: MBinding<CGFloat>) -> Self
}

protocol DeclarativeContentMode: MView {
    var contentMode: MBinding<UIView.ContentMode>? { get set }
    func contentMode(_ contentMode: MBinding<UIView.ContentMode>) -> Self
}

protocol DeclarativeBackgroundColor: MView {
    var backgroundColor: MBinding<UIColor?>? { get set }
    func backgroundColor(_ backgroundColor: MBinding<UIColor?>) -> Self
}

protocol DeclarativeClipsToBounds: MView {
    var clipsToBounds: MBinding<Bool>? { get set }
    func clipsToBounds(_ clipsToBounds: MBinding<Bool>) -> Self
}

protocol DeclarativeIsHidden: MView {
    var isHidden: MBinding<Bool>? { get set }
    func isHidden(_ isHidden: MBinding<Bool>) -> Self
}

protocol DeclarativePriority: MView {
    var priority: MBinding<SharedAppearance.Priority>? { get set }
    func priority(_ priority: MBinding<SharedAppearance.Priority>) -> Self
}

protocol DeclarativeCornerRadius: MView {
    var cornerRadius: MBinding<CGFloat>? { get set }
    func cornerRadius(_ cornerRadius: MBinding<CGFloat>) -> Self
}

protocol DeclarativeCornersToRound: MView {
    var cornersToRound: MBinding<[UIRectCorner]>? { get set }
    func cornersToRound(_ cornersToRound: MBinding<[UIRectCorner]>) -> Self
}

protocol DeclarativeBorderWidth: MView {
    var borderWidth: MBinding<CGFloat>? { get set }
    func borderWidth(_ borderWidth: MBinding<CGFloat>) -> Self
}

protocol DeclarativeBorderColor: MView {
    var borderColor: MBinding<UIColor>? { get set }
    func borderColor(_ borderColor: MBinding<UIColor>) -> Self
}

protocol DeclarativeShadow: MView {
    var shadow: MBinding<SharedAppearance.Layer.Shadow>? { get set }
    // periphery:ignore
    func shadow(_ shadow: MBinding<SharedAppearance.Layer.Shadow>) -> Self
}

protocol DeclarativeMasksToBounds: MView {
    var masksToBounds: MBinding<Bool>? { get set }
    func masksToBounds(_ masksToBounds: MBinding<Bool>) -> Self
}

extension UIView {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func applyDeclarativeCommon(model: MView, to view: UIView, cancellables: inout Set<AnyCancellable>) {
        weak var view = view
        if let isUserInteractionEnabled = (model as? DeclarativeIsUserInteractionEnabled)?.isUserInteractionEnabled {
            isUserInteractionEnabled.publisher
                .sink { isUserInteractionEnabled in
                    view?.isUserInteractionEnabled = isUserInteractionEnabled
                }
                .store(in: &cancellables)
        }
        
        if let alpha = (model as? DeclarativeAlpha)?.alpha {
            alpha.publisher
                .sink { alpha in
                    view?.alpha = alpha
                }
                .store(in: &cancellables)
        }
        
        if let contentMode = (model as? DeclarativeContentMode)?.contentMode {
            contentMode.publisher
                .sink { contentMode in
                    view?.contentMode = contentMode
                }
                .store(in: &cancellables)
        }
        
        if let backgroundColor = (model as? DeclarativeBackgroundColor)?.backgroundColor {
            backgroundColor.publisher
                .sink { backgroundColor in
                    view?.backgroundColor = backgroundColor
                }
                .store(in: &cancellables)
        }
        
        if let clipsToBounds = (model as? DeclarativeClipsToBounds)?.clipsToBounds {
            clipsToBounds.publisher
                .sink { clipsToBounds in
                    view?.clipsToBounds = clipsToBounds
                }
                .store(in: &cancellables)
        }
        
        if let isHidden = (model as? DeclarativeIsHidden)?.isHidden {
            isHidden.publisher
                .sink { isHidden in
                    view?.isHidden = isHidden
                }
                .store(in: &cancellables)
        }
        
        if let priority = (model as? DeclarativePriority)?.priority {
            view?.updateConstraintPriority(with: priority, cancellables: &cancellables)
        }
        
        if let cornerRadius = (model as? DeclarativeCornerRadius)?.cornerRadius {
            if let cornersToRound = (model as? DeclarativeCornersToRound)?.cornersToRound {
                MBinding<(CGFloat, [UIRectCorner])>
                    .combine(cornerRadius, cornersToRound)
                    .publisher
                    .sink { radius, corners in
                        view?.roundCorners(radius: radius, corners: corners)
                    }
                    .store(in: &cancellables)
            } else {
                cornerRadius.publisher
                    .sink { cornerRadius in
                        view?.layer.cornerRadius = cornerRadius
                    }
                    .store(in: &cancellables)
            }
        }
        
        if let cornersToRound = (model as? DeclarativeCornersToRound)?.cornersToRound {
            cornersToRound.publisher
                .sink { cornersToRound in
                    view?.roundCorners(
                        radius: (model as? DeclarativeCornerRadius)?.cornerRadius?.wrappedValue ?? .zero,
                        corners: cornersToRound
                    )
                }
                .store(in: &cancellables)
        }
        
        if let borderWidth = (model as? DeclarativeBorderWidth)?.borderWidth {
            borderWidth.publisher
                .sink { borderWidth in
                    view?.layer.borderWidth = borderWidth
                }
                .store(in: &cancellables)
        }
        
        if let borderColor = (model as? DeclarativeBorderColor)?.borderColor {
            borderColor.publisher
                .sink { borderColor in
                    view?.layer.borderColor = borderColor.cgColor
                }
                .store(in: &cancellables)
        }
        
        if let shadow = (model as? DeclarativeShadow)?.shadow {
            shadow.publisher
                .sink { shadow in
                    view?.layer.shadowRadius = shadow.radius
                    view?.layer.shadowColor = shadow.color.cgColor
                    view?.layer.shadowOpacity = shadow.opacity
                    view?.layer.shadowOffset = CGSize(width: shadow.offsetX, height: shadow.offsetY )
                }
                .store(in: &cancellables)
        }
        
        if let masksToBounds = (model as? DeclarativeMasksToBounds)?.masksToBounds {
            masksToBounds.publisher
                .sink { masksToBounds in
                    view?.layer.masksToBounds = masksToBounds
                }
                .store(in: &cancellables)
        }
        
    }
}

extension MView where Self: DeclarativeCommon {
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: MBinding<Bool>) -> Self {
        with(\.isUserInteractionEnabled, setTo: isUserInteractionEnabled)
    }
    
    @discardableResult
    func alpha(_ alpha: MBinding<CGFloat>) -> Self {
        with(\.alpha, setTo: alpha)
    }
    
    @discardableResult
    func contentMode(_ contentMode: MBinding<UIView.ContentMode>) -> Self {
        with(\.contentMode, setTo: contentMode)
    }
    
    @discardableResult
    func backgroundColor(_ backgroundColor: MBinding<UIColor?>) -> Self {
        with(\.backgroundColor, setTo: backgroundColor)
    }
    
    @discardableResult
    func clipsToBounds(_ clipsToBounds: MBinding<Bool>) -> Self {
        with(\.clipsToBounds, setTo: clipsToBounds)
    }
    
    @discardableResult
    func isHidden(_ isHidden: MBinding<Bool>) -> Self {
        with(\.isHidden, setTo: isHidden)
    }
    
    @discardableResult
    func priority(_ priority: MBinding<SharedAppearance.Priority>) -> Self {
        with(\.priority, setTo: priority)
    }
    
    @discardableResult
    func cornerRadius(_ cornerRadius: MBinding<CGFloat>) -> Self {
        with(\.cornerRadius, setTo: cornerRadius)
    }
    
    @discardableResult
    func cornersToRound(_ cornersToRound: MBinding<[UIRectCorner]>) -> Self {
        with(\.cornersToRound, setTo: cornersToRound)
    }
    
    @discardableResult
    func borderWidth(_ borderWidth: MBinding<CGFloat>) -> Self {
        with(\.borderWidth, setTo: borderWidth)
    }
    
    @discardableResult
    func borderColor(_ borderColor: MBinding<UIColor>) -> Self {
        with(\.borderColor, setTo: borderColor)
    }
    
    // periphery:ignore
    @discardableResult
    func shadow(_ shadow: MBinding<SharedAppearance.Layer.Shadow>) -> Self {
        with(\.shadow, setTo: shadow)
    }
    
    @discardableResult
    func masksToBounds(_ masksToBounds: MBinding<Bool>) -> Self {
        with(\.masksToBounds, setTo: masksToBounds)
    }
}
