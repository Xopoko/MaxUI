import UIKit

public extension UIView {
    /// Rounds the specified corners of the `UIView` to the given radius.
    ///
    /// - Parameters:
    ///     - radius: The radius to round the corners to.
    ///     - corners: The `UIRectCorner`s to round. Defaults to all corners.
    func roundCorners(radius: CGFloat, corners: [UIRectCorner] = [.allCorners]) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        var arr: CACornerMask = []
        
        for corner in corners where corners.contains(corner) {
            switch corner {
            case .topLeft:
                arr.insert(.layerMinXMinYCorner)
            case .topRight:
                arr.insert(.layerMaxXMinYCorner)
            case .bottomLeft:
                arr.insert(.layerMinXMaxYCorner)
            case .bottomRight:
                arr.insert(.layerMaxXMaxYCorner)
            case .allCorners:
                arr.insert(.layerMinXMinYCorner)
                arr.insert(.layerMaxXMinYCorner)
                arr.insert(.layerMinXMaxYCorner)
                arr.insert(.layerMaxXMaxYCorner)
            default:
                break
            }
        }
        self.layer.maskedCorners = arr
    }
}
