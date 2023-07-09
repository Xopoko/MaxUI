import UIKit
import Combine

/// The `Container` is the basic unit of MaxUI. The main task of the `Container` is to position the
/// view on the layout.
///
/// At the same time, the `Container` can NOT control ITS positioning.
/// Also, only the `Container` has the ability to manage the `common`
/// appearance (`backgroundColor`, `isUserInteractionEnabled`, etc.)
/// and `layer` appearance (`shadow`, `borderColor`, `cornerRadius`, etc.)
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
public struct Container: Componentable, Containerable, Withable {
    public typealias ViewType = ContainerView

    /// The model that provides the content for the scroll view.
    @MBinding
    public var model: MView?

    /// Appearance of container that required by Containerable protocol
    public var containerAppearance: ContainerView.Appearance? {
        get { appearance }
        nonmutating set { if let newValue { appearance = newValue } }
    }

    @MBinding
    fileprivate var appearance: ContainerView.Appearance
    
    fileprivate let view: UIView?
    
    /// Initialise the component view model with a binding that holds the `MView?` value.
    ///
    /// - Parameter model: The binding that holds the text value.
    public init(_ model: MBinding<MView?>) {
        self._model = model
        self.view = nil
        self._appearance = .dynamic(ContainerView.Appearance())
    }
    
    /// Initialise the component view model with a binding that holds the `MView?` value.
    ///
    /// - Parameter model: The binding that holds the text value.
    public init(_ model: MBinding<MView>) {
        self._model = MBinding(model)
        self.view = nil
        self._appearance = .dynamic(ContainerView.Appearance())
    }

    /// Initialise the component with a closure that returns a `MView`.
    ///
    /// - Parameter model: The closure that returns a `MView`.
    public init(_ model: () -> MView) {
        self._model = .dynamic(model())
        self.view = nil
        self._appearance = .dynamic(ContainerView.Appearance())
    }

    /// Initialise the component with a `MView` and Appearance.
    ///
    /// - Parameters:
    ///     - model: Model representing the view that this container contains.
    ///     - appearance: Appearance that contains the container's appearance properties
    public init(
        model: MView?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .dynamic(model)
        self.view = nil
        self._appearance = .dynamic(appearance)
    }

    /// Initialise the component with a `UIView` and Appearance.
    ///
    /// - Parameters:
    ///     - view: parameter of type `UIView`to be set as a content for the container
    ///     - appearance: Appearance that contains the container's appearance properties
    public init(
        view: UIView?,
        appearance: ContainerView.Appearance = ContainerView.Appearance()
    ) {
        self._model = .constant(nil)
        self.view = view
        self._appearance = .dynamic(appearance)
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
            updateLayer(with: appearance.layer, cancellables: &cancellables)
        }
    }
}

extension ContainerView: ReusableView {
    public func configure(with data: Container) {
        data.$model.publisher
            .sink { [weak self] model in
                guard let self, let model else { return }
                
                if [model].isPossibleToReuse(with: self.subviews) {
                    [model].reuse(with: self.subviews)
                } else {
                    self.subviews.forEach { $0.removeFromSuperview() }
                    let contentView = model.createAssociatedViewInstance()
                    self.contentView = contentView
                    self.addSubview(contentView)
                    contentView.fill(with: data.containerAppearance?.layout ?? .init())
                }
            }
            .store(in: &cancellables)

        if let view = data.view {
            self.subviews.forEach { $0.removeFromSuperview() }
            self.contentView = view
            self.addSubview(view)
            view.fill(with: data.containerAppearance?.layout ?? .init())
        }

        data.$appearance.publisher
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
        updateLayer(with: appearance.layer, cancellables: &cancellables)
        updateCommon(with: appearance.common, cancellables: &cancellables)
        
        if let contentMode = appearance.common.contentMode {
            contentView?.contentMode = contentMode.wrappedValue
        }
        contentView?.updateConstraintPriority(with: appearance.priority, cancellables: &cancellables)

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
        public var priority: MBinding<SharedAppearance.Priority> = .constant(.init())
        public var common = SharedAppearance.Common()

        public init(
            layout: SharedAppearance.Layout = SharedAppearance.Layout(),
            layer: SharedAppearance.Layer = SharedAppearance.Layer(),
            priority: MBinding<SharedAppearance.Priority> = .constant(.init()),
            common: SharedAppearance.Common = SharedAppearance.Common()
        ) {
            self.layout = layout
            self.layer = layer
            self.priority = priority
            self.common = common
        }
        
        public static func == (lhs: ContainerView.Appearance, rhs: ContainerView.Appearance) -> Bool {
            lhs.layout == rhs.layout &&
            lhs.layer == rhs.layer &&
            lhs.priority.wrappedValue == rhs.priority.wrappedValue &&
            lhs.common == rhs.common
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
        self.appearance = appearance
        return self
    }
    
    public func appearance(_ appearance: MBinding<ContainerView.Appearance>) -> Self {
        with(\._appearance, setTo: appearance)
    }
}
