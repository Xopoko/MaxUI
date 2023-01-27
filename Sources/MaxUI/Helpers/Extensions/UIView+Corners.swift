import UIKit

public extension UIView {
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
