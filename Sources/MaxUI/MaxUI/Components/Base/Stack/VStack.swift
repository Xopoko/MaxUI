import UIKit
import Combine

public struct VStack: ComponentViewModelProtocol {
    public typealias ViewType = VStackView
    
    public var models: [ViewableViewModelProtocol] {
        get { _models.value }
        nonmutating set { _models.send(newValue) }
    }
    
    fileprivate let _appearance: CurrentValueSubject<StackView.Appearance, Never>
    fileprivate let _models: CurrentValueSubject<[ViewableViewModelProtocol], Never>
    
    public init(@StackViewBuilder _ builder: () -> [ViewableViewModelProtocol]) {
        self._models = .init(builder())
        self._appearance = .init(StackView.Appearance())
    }
    
    public init(models: [ViewableViewModelProtocol]) {
        self._models = .init(models)
        self._appearance = .init(StackView.Appearance())
    }
}

public final class VStackView: UIStackView {
    private var appearance: StackView.Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension VStackView: ReusableView {

    public func configure(with data: VStack) {
        data._models
            .sink { [weak self] models in
                self?.configure(models: models)
            }
            .store(in: &cancellables)
        
        data._appearance
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
private extension VStackView {
    private func updateAppearance(appearance: StackView.Appearance) {
        guard appearance != self.appearance else { return }
        
        axis = .vertical
        alignment = appearance.alignment
        spacing = appearance.spacing
        distribution = appearance.distribution
        
        updateCommon(with: appearance.common)
        
        self.appearance = appearance
    }
}

extension VStack: DeclaratableStackViewAppearance {
    public var stackAppearance: StackView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
}

extension VStack: Stylable {
    public func style(_ appearance: StackView.Appearance) -> Self {
        self.stackAppearance = appearance
        return self
    }
}