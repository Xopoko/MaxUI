import UIKit
import Combine

/// `MVStack` is a struct that implements the `Componentable` protocol.
/// It represents a `vertical` stack view that can be used in a SwiftUI-style for
/// building user interfaces.
/// - Examples:
///
/// `Most common use`:
///
///     MVStack {
///         Text("some text")
///         Button("some button") {
///             print("tap")
///         }
///     }
///     .spacing(24)
///     .configure(in: self)
///
public struct MVStack: Componentable {
    public typealias ViewType = VStackView

    /// Models representing the arranged subviews that this stack view contains.
    public var models: [MView] {
        get { _models.value }
        nonmutating set { _models.send(newValue) }
    }

    fileprivate let _appearance: CurrentValueSubject<MStackView.Appearance, Never>
    fileprivate let _models: CurrentValueSubject<[MView], Never>

    /// Initializes the `MVStack` with a `MView` builder (`StackViewBuilder`).
    ///
    /// - Parameter builder: The `MView` builder.
    public init(@StackViewBuilder _ builder: () -> [MView]) {
        self._models = .init(builder())
        self._appearance = .init(MStackView.Appearance())
    }

    /// Initializes the `MVStack` with a `MView` array.
    ///
    /// - Parameter builder: The `MView` array.
    public init(models: [MView]) {
        self._models = .init(models)
        self._appearance = .init(MStackView.Appearance())
    }
}

public final class VStackView: UIStackView {
    private var appearance: MStackView.Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension VStackView: ReusableView {
    public func configure(with data: MVStack) {
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
extension VStackView {
    private func updateAppearance(appearance: MStackView.Appearance) {
        guard appearance != self.appearance else { return }

        axis = .vertical
        alignment = appearance.alignment
        spacing = appearance.spacing
        distribution = appearance.distribution

        updateCommon(with: appearance.common)

        self.appearance = appearance
    }
}

extension MVStack: Stackable {
    public var stackAppearance: MStackView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
}

extension MVStack: Stylable {
    public func style(_ appearance: MStackView.Appearance) -> Self {
        self.stackAppearance = appearance
        return self
    }
}
