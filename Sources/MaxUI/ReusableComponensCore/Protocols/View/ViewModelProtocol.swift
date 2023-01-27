import UIKit

public protocol AnyViewClass: UIView {}

public protocol ViewModelProtocol {
    
    var view: AnyViewClass.Type { get }
}

extension ViewModelProtocol {
    
    /*
     * Load UIView instance and fill it with ViewModel
     */
    func createAssociatedViewInstance() -> UIView {
        let view: UIView = view.init()

        if let presenting = view as? AnyValueConfigurable {
            presenting.configureWithValue(self)
        }

        return view
    }
}
