import UIKit
import Combine

public struct TapableContainer: ComponentViewModelProtocol {
    public typealias ViewType = TapableContainerView
        
    public var model: ViewableViewModelProtocol? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }
    
    public var appearance: TapableContainerView.Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }
    
    public var action: (() -> Void)? {
        get { _action.value }
        nonmutating set { _action.send(newValue) }
    }
    
    fileprivate let _model: CurrentValueSubject<ViewableViewModelProtocol?, Never>
    fileprivate let _appearance: CurrentValueSubject<TapableContainerView.Appearance, Never>
    fileprivate let _action: CurrentValueSubject<(() -> Void)?, Never>

    public init(_ action: (() -> Void)?, model: () -> ViewableViewModelProtocol) {
        self._model = .init(model())
        self._appearance = .init(TapableContainerView.Appearance())
        self._action = .init(action)
     }
    
    public init(
        model: ViewableViewModelProtocol?,
        appearance: TapableContainerView.Appearance = TapableContainerView.Appearance(),
        _ action: (() -> Void)?
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
        self._action = .init(action)
     }
}

public final class TapableContainerView: TapableView {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension TapableContainerView: ReusableView {

    public func configure(with data: TapableContainer) {
        data._model
            .sink { [weak self] model in
                guard let self, let model else { return }
                
                self.subviews.forEach { $0.removeFromSuperview() }
                let contentView = model.createAssociatedViewInstance()
                contentView.isUserInteractionEnabled = false
                self.addSubview(contentView)
                contentView.fill()
            }
            .store(in: &cancellables)
        
        data._appearance
            .removeDuplicates()
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
        
        data._action
            .assign(to: \.didSelect, on: self)
            .store(in: &cancellables)
    }
    
    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

extension TapableContainerView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        self.highlightBehavior = appearance.highlightBehavior
        
        self.appearance = appearance
    }
}

extension TapableContainerView {
    public struct Appearance: Equatable, Withable {
        public var highlightBehavior: TapableView.HighlightBehavior
        
        public init(highlightBehavior: TapableView.HighlightBehavior = .scale) {
            self.highlightBehavior = highlightBehavior
        }
    }
}

extension TapableContainer: Stylable {
    public func style(_ appearance: TapableContainerView.Appearance) -> TapableContainer {
        self.appearance = appearance
        return self
    }
    
    public func onSelect(_ action: @escaping () -> Void) -> TapableContainer {
        self.action = action
        return self
    }
}
