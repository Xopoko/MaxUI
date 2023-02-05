import UIKit

extension MView {
    /// Configures a view with the given view model information.
    ///
    /// - Parameters:
    /// - superview: The superview in which the view will be added.
    /// - priority: The layout priority of the view. Default is 999.
    /// - safeArea: A boolean indicating if the view should be constrained to the safe area. Default is false.
    ///
    /// - Returns: The configured view.
    @discardableResult
    public func configure(
        in superview: UIView,
        priority: UILayoutPriority = .init(999),
        safeArea: Bool = false
    ) -> UIView {
        superview.configure(
            withViewModel: self,
            priority: priority,
            toSafeArea: safeArea
        )
    }
}

extension Array where Element == any MView {
    /// Determines whether it is possible to reuse the given subviews with the view models in the array.
    ///
    /// - Parameter subviews: The subviews to check for reuse.
    /// - Returns: A Boolean indicating whether it is possible to reuse the subviews.
    public func isPossibleToReuse(with subviews: [UIView]) -> Bool {
        var canReuse = subviews.count == self.count
        if canReuse {
            for (index, viewModel) in self.enumerated() {
                guard
                    let view = subviews[safe: index],
                    type(of: view) == viewModel.view
                else {
                    canReuse = false
                    break
                }
            }
        }
        return canReuse
    }
    
    /// Reuses the given subviews with the array of `MView`.
    ///
    /// - Parameter subviews: The subviews to reuse.
    public func reuse(with subviews: [UIView]) {
        for (index, viewModel) in self.enumerated() {
            guard let view = subviews[safe: index] as? AnyValueConfigurable else {
                continue
            }
            (view as? PrepareReusable)?.prepareForReuse()
            view.configureWithValue(viewModel)
        }
    }
}
