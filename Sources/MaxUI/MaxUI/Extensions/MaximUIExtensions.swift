import UIKit

extension ViewableViewModelProtocol {
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
