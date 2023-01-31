
import UIKit

extension UIView {
    /// Wraps `UIView` into a new `Container`
    public func asComponent() -> Container {
        Container(view: self)
    }
}
