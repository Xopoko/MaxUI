import UIKit
import Combine

/// `MHStack` is a struct that implements the `Componentable` protocol.
/// It represents a `horizontal` stack view that can be used in a SwiftUI-style for
/// building user interfaces.
/// - Examples:
///
/// `Most common use`:
///
///     MHStack {
///         Text("some text")
///         Button("some button") {
///             print("tap")
///         }
///     }
///     .spacing(24)
///     .configure(in: self)
///
public struct MHStack: Componentable {
    public typealias ViewType = MHStackView

    /// Models representing the arranged subviews that this stack view contains.
    public var models: [MView] {
        get { _models.value }
        nonmutating set { _models.send(newValue) }
    }

    fileprivate let _appearance: CurrentValueSubject<MStackView.Appearance, Never>
    fileprivate let _models: CurrentValueSubject<[MView], Never>

    /// Initializes the `MHStack` with a `MView` builder (`MViewBuilder`).
    ///
    /// - Parameter builder: The `MView` builder.
    public init(@MViewBuilder _ builder: () -> [MView]) {
        self._models = .init(builder())
        self._appearance = .init(MStackView.Appearance())
    }

    /// Initializes the `MHStack` with a `MView` array.
    ///
    /// - Parameter builder: The `MView` array.
    public init(models: [MView]) {
        self._models = .init(models)
        self._appearance = .init(MStackView.Appearance())
    }
}

public final class MHStackView: UIStackView {
    private var appearance: MStackView.Appearance?
    private var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(frame: .zero)
        setupLayout()
    }
}

extension MHStackView: ReusableView {
    public func configure(with data: MHStack) {
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
extension MHStackView {
    private func updateAppearance(appearance: MStackView.Appearance) {
        guard appearance != self.appearance else { return }

        alignment = appearance.alignment
        spacing = appearance.spacing
        distribution = appearance.distribution

        updateCommon(with: appearance.common)

        self.appearance = appearance
    }
    
    private func setupLayout() {
        axis = .horizontal
    }
}

extension MHStack: Stackable {
    public var stackAppearance: MStackView.Appearance {
        get { _appearance.value }
        nonmutating set { _appearance.send(newValue) }
    }
}

extension MHStack: Stylable {
    public func style(_ appearance: MStackView.Appearance) -> Self {
        self.stackAppearance = appearance
        return self
    }
}
