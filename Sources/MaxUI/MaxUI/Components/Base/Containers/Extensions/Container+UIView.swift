
import UIKit

extension UIView {
    public func asComponent() -> Container {
        Container(view: self)
    }
}
