import UIKit

/// The base protocol for view subclass that can be filled with it's Model
public protocol DataConfigurable: AnyObject {
    // Type of ViewModel
    associatedtype ViewData

    /// This function will be called every time the view is configured as content
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    func configure(with data: ViewData)

    /// This function will be called every time BEFORE the view is configured as content
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    func willBeShown(with data: ViewData)

    /// This function will be called every time the view is disposed from its container
    ///
    /// - Parameter data: this is an object that implements the Componentable protocol and contains
    ///   the ViewType of the view in which this function is called
    func wasHidden(with data: ViewData)
}

extension DataConfigurable {

    public func willBeShown(with data: ViewData) {}

    public func wasHidden(with data: ViewData) {}
}

/// Helper protocol to provide abstract interface to configure component with any data
public protocol AnyValueConfigurable {

    // This function will be called every time the view is configured as content
    func configureWithValue(_ value: Any)

    // The same as `willDisplay` in Collection and Table delegates
    func willDisplay(_ value: Any)

    // The same as `didEndDisplaying` in Collection and Table delegates
    func didEndDisplay(_ value: Any)
}

extension AnyValueConfigurable where Self: DataConfigurable {

    public func configureWithValue(_ value: Any) {
        if let viewData = value as? ViewData {
            configure(with: viewData)
        }
    }

    public func willDisplay(_ value: Any) {
         if let viewData = value as? ViewData {
            willBeShown(with: viewData)
        }
    }

    public func didEndDisplay(_ value: Any) {
        if let viewData = value as? ViewData {
           wasHidden(with: viewData)
       }
    }
}
