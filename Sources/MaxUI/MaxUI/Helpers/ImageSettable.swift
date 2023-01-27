import UIKit

public protocol ImageSettable {
    func setImage(for imageView: UIImageView)
}

extension UIImage: ImageSettable {
    public func setImage(for imageView: UIImageView) {
        imageView.image = self
    }
}
