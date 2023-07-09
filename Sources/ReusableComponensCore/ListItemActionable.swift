import Foundation

/*
 * ViewModel have to adopt this protocol for cases when you need handle item selection from list (like didSelectRow(:))
 */
public protocol ListItemActionable {

    var didSelect: (() -> Void)? { get }
}
