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
