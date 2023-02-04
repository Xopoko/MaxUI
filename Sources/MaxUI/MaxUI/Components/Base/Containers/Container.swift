import UIKit
import Combine

/// The `Container` is the basic unit of MaxUI. The main task of the `Container` is to position the
/// view on the layout.
///
/// At the same time, the `Container` can NOT control ITS positioning.
/// Also, only the `Container` has the ability to manage the `common`
/// apperance (`backgroundColor`, `isUserInteractionEnabled`, etc.)
/// and `layer` apperance (`shadow`, `borderColor`, `cornerRadius`, etc.)
/// - Examples:
///
/// `Most common use`:
///
///     Text("some text")
///         .insets(top: 24)
///         .configure(in: self)
///
/// `Using .toContainer()`:
///
///      Text("some text")
///         .toContainer()
///         .insets(top: 24)
///         .configure(in: self)
///
/// `Wrapping UIView`:
///      UIView()
///         .asComponent()
///         .insets(top: 24)
///         .configure(in: self)
///
///  `OR`:
///
///     let yourView = UIView()
///     Container(view: yourView)
///         .insets(top: 24)
///         .configure(in: self)
///
/// `Direct creation (not preferred)`:
///
///     Container {
///         Text("some text")
///     }
///     .insets(top: 24)
///     .configure(in: self)
///
public struct Container: Componentable, Containerable {
    public typealias ViewType = ContainerView

    /// The model that provides the content for the scroll view.
    public var model: MView? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }

    /// Appearance of container that required by Containerable protocol
    public var containerAppearance: ContainerView.Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }

    fileprivate let _appearance: CurrentValueSubject<ContainerView.Appearance, Never>
    fileprivate let _model: CurrentValueSubject<MView?, Never>
    fileprivate let _view: CurrentValueSubject<UIView?, Never>

    /// Initializes the component with a closure that returns a `MView`.
    ///
    /// - Parameter model: The closure that returns a `MView`.
    public init(_ model: () -> MView) {
        self._model = .init(model())
        self._view = .init(nil)
        self._appearance = .init(ContainerView.Appearance())
    }

    /// Initializes the component with a `MView` and Appearance.
    ///
    /// - Parameters:
    ///     - model: Model representing the view that this container contains.
    ///     - appearance: Appearance that contains the container's appearance properties
    public init(
        model: MView?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .init(model)
        self._view = .init(nil)
        self._appearance = .init(appearance)
    }

    /// Initializes the component with a `UIView` and Appearance.
    ///
    /// - Parameters:
    ///     - view: parameter of type `UIView`to be set as a content for the container
    ///     - apperance: Appearance that contains the container's appearance properties
    public init(
        view: UIView?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .init(nil)
        self._view = .init(view)
        self._appearance = .init(appearance)
    }
}

// View which will be created from the Container. Usually you don't have to use it directly.
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

/// This protocol helps other components that want to use Container declarative behavior
/// To do this, you need to define the Container appearance in your components.
public protocol Containerable: MView {
    var containerAppearance: ContainerView.Appearance? { get nonmutating set }
}

extension Container: Stylable {
    @discardableResult
    public func style(_ appearance: ContainerView.Appearance) -> Self {
        self.containerAppearance = appearance
        return self
    }
}
