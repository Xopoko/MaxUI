import UIKit

public protocol CollectionCellProtocol: AnyValueConfigurable {}

public protocol TableCellProtocol: AnyValueConfigurable {}

/*
 * The base protocol for view subclass that can be filled with it's Model
 */
public protocol DataConfigurable: AnyObject {
    // Type of ViewModel
    associatedtype ViewData
    
    func configure(with data: ViewData)
    
    func willBeShown(with data: ViewData)
    
    func wasHidden(with data: ViewData)
}

extension DataConfigurable {
    
    public func willBeShown(with data: ViewData) {}
    
    public func wasHidden(with data: ViewData) {}
}

/*
 * Helper protocol to provide abstract interface to configure component with any data
 */
public protocol AnyValueConfigurable {
    
    func configureWithValue(_ value: Any)
    
    func willDisplay(_ value: Any)
    
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
