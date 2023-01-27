import UIKit

/*
 * The base protocol for view subclass that can be used as Component with view model
 */
public protocol ReusableView: AnyViewClass,
                AnyValueConfigurable, DataConfigurable, PrepareReusable {}

public protocol PrepareReusable {
  func prepareForReuse()
}
