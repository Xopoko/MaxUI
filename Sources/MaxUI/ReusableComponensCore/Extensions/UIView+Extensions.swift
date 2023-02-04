import UIKit

extension UIView {

    /// Add self as subivew to superview and apply constraints or custom layout
    /// - Parameters::
    ///     - in: container from Self (superview)
    ///     - insets: Custom insets from superview. Default: UIEdgeInsets.zero
    ///     - priority: Custom priority to subview. Default: .init(999)
    ///     - toSafeArea: Indicates that have to fill to safeAreaLayoutGuide. Default: false
    ///     - customLayout: This structure contains layout closure that calls when
    ///     need to make constraints. Default: nil
    public func fill(
        in superview: UIView,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .init(999),
        toSafeArea: Bool = false
    ) {
        superview.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            topAnchor.constraint(
                equalTo: toSafeArea
                ? superview.safeAreaLayoutGuide.topAnchor
                : superview.topAnchor,
                constant: insets.top
            ),
            bottomAnchor.constraint(
                equalTo: toSafeArea
                ? superview.safeAreaLayoutGuide.bottomAnchor
                : superview.bottomAnchor,
                constant: -insets.bottom
            ),
            leftAnchor.constraint(
                equalTo: toSafeArea
                ? superview.safeAreaLayoutGuide.leftAnchor
                : superview.leftAnchor,
                constant: insets.left
            ),
            rightAnchor.constraint(
                equalTo: toSafeArea
                ? superview.safeAreaLayoutGuide.rightAnchor
                : superview.rightAnchor,
                constant: -insets.right
            )
        ]

        constraints.forEach { $0.priority = priority }

        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult
    public func configure(
        withViewModel viewModel: ViewModelProtocol,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .init(999),
        toSafeArea: Bool = false
    ) -> UIView {
        if
            let subview = subviews.first,
            type(of: subview) == viewModel.view,
            let configurable = subview as? AnyValueConfigurable
        {
            (subview as? PrepareReusable)?.prepareForReuse()
            configurable.configureWithValue(viewModel)
            return subview
        } else {
            subviews.forEach { $0.removeFromSuperview() }

            let view = viewModel.createAssociatedViewInstance()
            view.fill(
                in: self,
                insets: insets,
                priority: priority,
                toSafeArea: toSafeArea
            )

            return view
        }
    }

    @discardableResult
    public func configure(
        withViewModel viewModel: ViewModelProtocol,
        layout: SharedAppearance.Layout
    ) -> UIView {
        if let subview = subviews.first,
           type(of: subview) == viewModel.view,
           let configurable = subview as? AnyValueConfigurable {
            (subview as? PrepareReusable)?.prepareForReuse()
            configurable.configureWithValue(viewModel)
            return subview
        } else {
            subviews.forEach { $0.removeFromSuperview() }

            let view = viewModel.createAssociatedViewInstance()
            addSubview(view)
            view.fill(with: layout, on: self)

            return view
        }
    }
}
