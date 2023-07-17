/// This protocol describes the ability to set custom styles using the component's appearance.
public protocol Stylable {
    associatedtype Appearance

    /// Completely replaces the appearance of a component
    ///
    /// - Parameter appearance: appearance of a component
    /// - Returns: the same object but with new appearance
    @discardableResult
    func style(_ appearance: Appearance) -> Self
}
