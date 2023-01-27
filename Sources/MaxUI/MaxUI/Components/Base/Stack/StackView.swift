import UIKit
import Combine

extension StackView {
    public struct Model: ComponentViewModelProtocol, DeclaratableStackViewAppearance {
        public typealias ViewType = StackView
        
        public var models: [ViewableViewModelProtocol] {
            get { _models.value }
            nonmutating set { _models.send(newValue) }
        }
        public var stackAppearance: Appearance {
            get { _appearance.value }
            nonmutating set { _appearance.send(newValue) }
        }
        
        fileprivate let _appearance: CurrentValueSubject<Appearance, Never>
        fileprivate let _models: CurrentValueSubject<[ViewableViewModelProtocol], Never>
        
        public init(models: [ViewableViewModelProtocol], appearance: Appearance = Appearance()) {
            self._models = CurrentValueSubject<[ViewableViewModelProtocol], Never>(models)
            self._appearance = CurrentValueSubject<Appearance, Never>(appearance)
        }
    }
}

public class StackView: UIStackView {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension StackView: ReusableView {

    public func configure(with data: StackView.Model) {
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
private extension StackView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        axis = appearance.axis
        alignment = appearance.alignment
        spacing = appearance.spacing
        distribution = appearance.distribution
        
        updateCommon(with: appearance.common)
        
        self.appearance = appearance
    }
}

extension StackView {
    public struct Appearance: Equatable, Withable {
        public var axis: NSLayoutConstraint.Axis
        public var alignment: UIStackView.Alignment
        public var distribution: UIStackView.Distribution
        public var spacing: CGFloat
        public var common: SharedAppearance.Common
        
        public init(
            axis: NSLayoutConstraint.Axis = .vertical,
            alignment: UIStackView.Alignment = .fill,
            distribution: UIStackView.Distribution = .fill,
            spacing: CGFloat = .zero,
            common: SharedAppearance.Common = .init()
        ) {
            self.axis = axis
            self.alignment = alignment
            self.distribution = distribution
            self.spacing = spacing
            self.common = common
        }
    }
}

/// This protocol helps other components that want to use StackView's declarative behavior to implement Text apperance. To do this, you need to define the StackView appearance in your components.
public protocol DeclaratableStackViewAppearance {
    var stackAppearance: StackView.Appearance { get nonmutating set }
    
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self
    @discardableResult
    func common(_ common: SharedAppearance.Common) -> Self
}

extension DeclaratableStackViewAppearance {
    @discardableResult
    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        stackAppearance.alignment = alignment
        return self
    }
    
    @discardableResult
    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        stackAppearance.distribution = distribution
        return self
    }
    
    @discardableResult
    public func spacing(_ spacing: CGFloat) -> Self {
        stackAppearance.spacing = spacing
        return self
    }
    
    @discardableResult
    public func common(_ common: SharedAppearance.Common) -> Self {
        stackAppearance.common = common
        return self
    }
}
