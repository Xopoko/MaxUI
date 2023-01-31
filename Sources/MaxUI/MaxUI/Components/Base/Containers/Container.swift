import UIKit
import Combine

/// The `Container` is the basic unit of MaxUI. The main task of the `Container` is to position the view on the layout.
/// At the same time, the `Container` can NOT control ITS positioning.
/// Also, only the `Container` has the ability to manage the `common` apperance (`backgroundColor`, `isUserInteractionEnabled`, etc.)
/// and `layer` apperance (`shadow`, `borderColor`, `cornerRadius`, etc.)
public struct Container: ComponentViewModelProtocol, DeclaratableContainerViewAppearance {
    public typealias ViewType = ContainerView
    
    public var model: ViewableViewModelProtocol? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }
    
    public var containerAppearance: ContainerView.Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }
    
    fileprivate let _appearance: CurrentValueSubject<ContainerView.Appearance, Never>
    fileprivate let _model: CurrentValueSubject<ViewableViewModelProtocol?, Never>
    fileprivate let _view: CurrentValueSubject<UIView?, Never>
    
    public init(_ model: () -> ViewableViewModelProtocol) {
        self._model = .init(model())
        self._view = .init(nil)
        self._appearance = .init(ContainerView.Appearance())
    }
    
    public init(
        model: ViewableViewModelProtocol?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .init(model)
        self._view = .init(nil)
        self._appearance = .init(appearance)
    }
    
    public init(
        view: UIView?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .init(nil)
        self._view = .init(view)
        self._appearance = .init(appearance)
    }
}

public final class ContainerView: UIView {
    private var contentView: UIView?
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if let appearance {
            updateLayer(with: appearance.layer)
        }
    }
}

extension ContainerView: ReusableView {
    
    public func configure(with data: Container) {
        data._model
            .sink { [weak self] model in
                guard let self, let model else { return }
                
                self.subviews.forEach { $0.removeFromSuperview() }
                let contentView = model.createAssociatedViewInstance()
                self.contentView = contentView
                self.addSubview(contentView)
                contentView.fill(with: data.containerAppearance?.layout ?? .init())
            }
            .store(in: &cancellables)
        
        data._view
            .sink { [weak self] view in
                guard let self, let view else { return }
                
                self.subviews.forEach { $0.removeFromSuperview() }
                self.contentView = view
                self.addSubview(view)
                view.fill(with: data.containerAppearance?.layout ?? .init())
            }
            .store(in: &cancellables)
        
        data._appearance
            .removeDuplicates()
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
    }
    
    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension ContainerView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        updateLayer(with: appearance.layer)
        updateCommon(with: appearance.common)
        if let contentMode = appearance.common.contentMode {
            contentView?.contentMode = contentMode
        }
        contentView?.updateConstraintPriority(with: appearance.priority)
        
        if let contentView = self.contentView, self.appearance?.layout != appearance.layout {
            contentView.fill(with: appearance.layout, on: self)
        }
        
        self.appearance = appearance
    }
}

extension ContainerView {
    public struct Appearance: Equatable, Withable {
        public var layout = SharedAppearance.Layout()
        public var layer = SharedAppearance.Layer()
        public var priority = SharedAppearance.Priority()
        public var common = SharedAppearance.Common()
        
        public init(
            layout: SharedAppearance.Layout = SharedAppearance.Layout(),
            layer: SharedAppearance.Layer = SharedAppearance.Layer(),
            priority: SharedAppearance.Priority = SharedAppearance.Priority(),
            common: SharedAppearance.Common = SharedAppearance.Common()
        ) {
            self.layout = layout
            self.layer = layer
            self.priority = priority
            self.common = common
        }
    }
}

/// This protocol helps other components that want to use ContainerView's declarative behavior to implement Text appearance.
/// To do this, you need to define the ContainerView appearance in your components.
public protocol DeclaratableContainerViewAppearance: ViewableViewModelProtocol {
    var containerAppearance: ContainerView.Appearance? { get nonmutating set }
    
    @discardableResult
    func insets(_ insets: UIEdgeInsets) -> ViewableViewModelProtocol
    @discardableResult
    func insets(
        left: CGFloat,
        right: CGFloat,
        top: CGFloat,
        bottom: CGFloat
    ) -> ViewableViewModelProtocol
    @discardableResult
    func insets(_ all: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func insets(horizontal: CGFloat, vertical: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func width(_ width: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func height(_ height: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func centerY(_ centerY: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func centerX(_ centerX: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func priority(_ priority: SharedAppearance.Priority) -> ViewableViewModelProtocol
    @discardableResult
    func verticalHuggingPriority(_ priority: UILayoutPriority) -> ViewableViewModelProtocol
    @discardableResult
    func verticalCompressPriority(_ priority: UILayoutPriority) -> ViewableViewModelProtocol
    @discardableResult
    func horizontalHuggingPriority(_ priority: UILayoutPriority) -> ViewableViewModelProtocol
    @discardableResult
    func horizontalCompressPriority(_ priority: UILayoutPriority) -> ViewableViewModelProtocol
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func cornersToRound(_ cornersToRound: [UIRectCorner]) -> ViewableViewModelProtocol
    @discardableResult
    func borderWidth(_ borderWidth: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func borderColor(_ borderColor: UIColor) -> ViewableViewModelProtocol
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool) -> ViewableViewModelProtocol
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> ViewableViewModelProtocol
    @discardableResult
    func alpha(_ alpha: CGFloat) -> ViewableViewModelProtocol
    @discardableResult
    func contentMode(_ contentMode: UIView.ContentMode) -> ViewableViewModelProtocol
    @discardableResult
    func backgroundColor(_ backgroundColor: UIColor) -> ViewableViewModelProtocol
    @discardableResult
    func shadow(
        offsetX: CGFloat?,
        offsetY: CGFloat?,
        color: UIColor?,
        opacity: Float?,
        radius: CGFloat?
    ) -> ViewableViewModelProtocol
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> ViewableViewModelProtocol
    @discardableResult
    func isHidden(_ isHidden: Bool) -> ViewableViewModelProtocol
}

extension Container: Stylable {
    @discardableResult
    public func style(_ appearance: ContainerView.Appearance) -> Self {
        self.containerAppearance = appearance
        return self
    }
}
