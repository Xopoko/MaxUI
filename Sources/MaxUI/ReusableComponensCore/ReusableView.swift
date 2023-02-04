import UIKit

/*
 * The base protocol for view subclass that can be used as Component with view model
 */
public protocol ReusableView: AnyViewClass,
                              AnyValueConfigurable,
                              DataConfigurable,
                              PrepareReusable {}

public protocol PrepareReusable {
    /// This function will be called each time the component is reused before configure,
    /// allowing the release of reactive objects and preparing the component to be reused.
    func prepareForReuse()
}

public extension PrepareReusable {
    func prepareForReuse() {}
}
