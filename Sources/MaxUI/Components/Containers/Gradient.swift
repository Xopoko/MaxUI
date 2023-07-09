import UIKit
import Combine

/// A container that represents a gradient component in a UI.
/// - Examples:
///
/// `Most common use`:
///
///     Text("some text")
///         .insets(top: 24)
///         .gradient(.somePrePreparedAppearance)
///         .configure(in: self)
///
/// `Direct creation (not preferred)`:
///
///     Gradient {
///         Text("some text")
///     }
///     .colors([.red, .blue])
///     .locations([0.25, 0.75])
///     .insets(top: 24)
///     .configure(in: self)
///
public struct Gradient: Componentable {
    public typealias ViewType = GradientView

    /// The model that provides the content for the scroll view.
    public var model: MView? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }

    /// The appearance for this gradient component.
    public var appearance: GradientView.Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }

    fileprivate let _appearance: CurrentValueSubject<GradientView.Appearance, Never>
    fileprivate let _model: CurrentValueSubject<MView?, Never>

    /// Initialise the component with a closure that returns a `MView`.
    ///
    /// - Parameter model: The closure that returns a `MView`.
    public init(_ model: () -> MView) {
        self._model = .init(model())
        self._appearance = .init(GradientView.Appearance())
     }

    /// Initialise the component with a `MView` and Appearance.
    ///
    /// - Parameters:
    ///     - model: Model representing the view that this gradient container contains.
    ///     - appearance: Appearance that contains the gradient container's appearance properties
    public init(
        model: MView?,
        appearance: GradientView.Appearance = GradientView.Appearance()
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
     }
}

// View which will be created from the Gradient. Usually you don't have to use it directly.
public final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()

    public init() {
        super.init(frame: .zero)
        setupLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

extension GradientView: ReusableView {
    public func configure(with data: Gradient) {
        data._model
            .sink { [weak self] model in
                guard let self, let model else { return }

                self.subviews.forEach { $0.removeFromSuperview() }
                let contentView = model.createAssociatedViewInstance()
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
    }

    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
extension GradientView {
    private func setupLayout() {
        layer.addSublayer(gradientLayer)
    }

    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }

        gradientLayer.colors = appearance.colors.map { $0.cgColor }
        gradientLayer.locations = appearance.locations
        gradientLayer.startPoint = appearance.startPoint
        gradientLayer.endPoint = appearance.endPoint
        gradientLayer.type = appearance.type

        updateLayer(with: appearance.layer, cancellables: &cancellables)

        self.appearance = appearance
    }
}

public extension GradientView {
    struct Appearance: Equatable, Withable {
        public var layer: SharedAppearance.Layer
        public var colors: [UIColor]
        public var locations: [NSNumber]
        public var startPoint: CGPoint
        public var endPoint: CGPoint
        public var type: CAGradientLayerType

        public init(
            layer: SharedAppearance.Layer = SharedAppearance.Layer(),
            colors: [UIColor] = [],
            locations: [NSNumber] = [0, 1],
            startPoint: CGPoint = CGPoint(x: 0, y: 0),
            endPoint: CGPoint = CGPoint(x: 1, y: 1),
            type: CAGradientLayerType = .axial
        ) {
            self.layer = layer
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.type = type
        }
    }
}

extension Gradient: Stylable {
    public func style(_ appearance: GradientView.Appearance) -> Gradient {
        self.appearance = appearance
        return self
    }
}

extension Gradient {

    /// Sets the layer for the gradient's appearance.
    ///
    /// - Parameter layer: The layer to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func layer(_ layer: SharedAppearance.Layer) -> Self {
        appearance?.layer = layer
        return self
    }

    /// Sets the colors for the gradient's appearance.
    ///
    /// - Parameter colors: An array of colors to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func colors(_ colors: [UIColor]) -> Self {
        appearance?.colors = colors
        return self
    }

    /// Sets the locations for the gradient's appearance.
    ///
    /// - Parameter locations: An array of locations to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func locations(_ locations: [NSNumber]) -> Self {
        appearance?.locations = locations
        return self
    }

    /// Sets the start point for the gradient's appearance.
    ///
    /// - Parameter startPoint: The start point to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func startPoint(_ startPoint: CGPoint) -> Self {
        appearance?.startPoint = startPoint
        return self
    }

    /// Sets the end point for the gradient's appearance.
    ///
    /// - Parameter endPoint: The end point to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func endPoint(_ endPoint: CGPoint) -> Self {
        appearance?.endPoint = endPoint
        return self
    }

    /// Sets the type for the gradient's appearance.
    ///
    /// - Parameter type: The type to set.
    /// - Returns: The updated Gradient instance.
    @discardableResult
    public func type(_ type: CAGradientLayerType) -> Self {
        appearance?.type = type
        return self
    }
}
