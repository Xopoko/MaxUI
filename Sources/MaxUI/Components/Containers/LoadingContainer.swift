import Foundation
import UIKit

extension MView {
    public func isLoading(_ isLoading: MBinding<Bool>) -> MView {
        Container(isLoading.map {
            if $0 {
                let activityIndicator = UIActivityIndicatorView()
                activityIndicator.startAnimating()
                return activityIndicator.asComponent()
            } else {
                return self
            }
        })
    }
}
