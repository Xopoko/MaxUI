import UIKit

public protocol ImageSettable {
    /// Sets the image for an image view using the ImageSettable protocol.
    ///
    /// - Parameter imageView: The image view to set the image for.
    func setImage(for imageView: UIImageView)
}

extension UIImage: ImageSettable {
    public func setImage(for imageView: UIImageView) {
        imageView.image = self
    }
}
