import UIKit
import Combine

/// HStack is a struct that implements the ComponentViewModelProtocol protocol.
/// It represents a horizontal stack view that can be used in a SwiftUI-style framework for
/// building user interfaces.
public struct HStack: ComponentViewModelProtocol {
    public typealias ViewType = HStackView
    
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

public final class HStackView: UIStackView {
    private var appearance: StackView.Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension HStackView: ReusableView {

    public func configure(with data: HStack) {
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
private extension HStackView {
    private func updateAppearance(appearance: StackView.Appearance) {
        guard appearance != self.appearance else { return }
        
        axis = .horizontal
        alignment = appearance.alignment
        spacing = appearance.spacing
        distribution = appearance.distribution
        
        updateCommon(with: appearance.common)
        
        self.appearance = appearance
    }
}

extension HStack: DeclaratableStackViewAppearance {
    public var stackAppearance: StackView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
}

extension HStack: Stylable {
    public func style(_ appearance: StackView.Appearance) -> Self {
        self.stackAppearance = appearance
        return self
    }
}
