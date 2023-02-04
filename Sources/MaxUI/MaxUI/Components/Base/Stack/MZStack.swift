import UIKit
import Combine

/// `MZStack` is a struct that implements the `Componentable` protocol.
/// It represents a `z-axis` stack view that can be used in a SwiftUI-style for
/// building user interfaces.
/// - Examples:
///
/// `Most common use`:
///
///     MZStack {
///         MImage(Asset.image)
///         Button("some button") {
///             print("tap")
///         }
///     }
///     .configure(in: self)
///
/// `Layout based using`:
///
///     MZStack {
///         MZStack.LayoutModel {
///             Image(Asset.image)
///         } customLayout: { superview, subview in
///             heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
///             widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
///             // or snapKit or whatever else...
///         }
///         MZStack.LayoutModel {
///             Button("some button") {
///                 print("tap")
///             }
///         }
///     }
///     .configure(in: self)
///
public struct MZStack: Componentable {
    /// Typealias for a closure that will be called when a view is added to the `MZStack`
    /// This closure allows customization of the layout of the subview in the `MZStack` component.
    public typealias CustomLayout = ((_ superview: UIView, _ subview: UIView) -> Void)
    public typealias ViewType = MStackZView

    /// A `LayoutModel` struct that contains information about the view model and custom layout
    /// for the `MZStack` component.
        public struct LayoutModel {
            /// The view model that provides the information for rendering the `MZStack` component.
            public var viewModel: MView

            /// A closure that defines the custom layout for the subview in the `MZStack` component.
            public var customLayout: CustomLayout?

            /// Initializes a `LayoutModel` struct with a view model and an optional
            /// custom layout closure.
            ///
            /// - Parameters:
            ///     - viewModel: A closure that returns the `MView` instance that provides
            ///     information for rendering the `MZStack` component.
            ///     - customLayout: A closure that defines the custom layout for the subview
            ///     in the `MZStack` component. Default is `nil`.
            public init(
                _ viewModel: () -> MView,
                customLayout: CustomLayout? = nil
            ) {
                self.viewModel = viewModel()
                self.customLayout = customLayout
            }
        }

    /// Models representing the layout models that this stack view contains.
    public var models: [LayoutModel] {
        get { _models.value }
        nonmutating set { _models.send(newValue) }
    }

    fileprivate let _models: CurrentValueSubject<[LayoutModel], Never>

    /// Initializes the `MZStack` with a `MView` builder (`StackZBuilder`).
    ///
    /// - Parameter builder: The `LayoutModel` builder.
    public init(@StackZBuilder _ builder: () -> [LayoutModel]) {
        self._models = .init(builder())
    }

    /// Initializes the `MZStack` with a `MView` builder (`StackViewBuilder`).
    ///
    /// - Parameter builder: The `MView` builder.
    public init(@StackViewBuilder _ builder: () -> [MView]) {
        let models = builder().map { view in LayoutModel({ view }, customLayout: nil) }
        self._models = .init(models)
    }
}

public final class MStackZView: UIView {}

extension MStackZView: ReusableView {
    public func configure(with data: MZStack) {
        var canReuse = subviews.count == data.models.count
        if canReuse {
            for (index, viewModel) in data.models.enumerated() {
                guard
                    let view = subviews[safe: index],
                    type(of: view) == viewModel.viewModel.view
                else {
                    canReuse = false
                    break
                }
            }
        }

        if canReuse {
            for (index, viewModel) in data.models.enumerated() {
                guard let view = subviews[safe: index] as? AnyValueConfigurable else {
                    continue
                }
                (view as? PrepareReusable)?.prepareForReuse()
                view.configureWithValue(viewModel.viewModel)
            }
        } else {
            subviews.forEach { $0.removeFromSuperview() }

            data.models.forEach { model in
                let view = model.viewModel.createAssociatedViewInstance()
                addSubview(view)
                if let customLayout = model.customLayout {
                    customLayout(self, view)
                } else {
                    view.fill()
                }
            }
        }
    }
}
