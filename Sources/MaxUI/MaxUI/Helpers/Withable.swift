public protocol Withable {}

/// Extends the Withable protocol to add the with method for convenient
/// property assignment.
///
/// This method allows you to change a property of an object in a fluent, chainable way.
///
/// Example:
///
/// struct Person {
///     var name: String
///     var age: Int
/// }
///
/// extension Person: Withable {}
///
/// let p = Person(name: "John", age: 30)
///             .with(\Person.name, setTo: "Jane")
///             .with(\Person.age, setTo: 32)
/// Adds the with method to any type conforming to the Withable protocol.
extension Withable {
    /// Returns a new instance of the conforming type with the specified property set to the given value.
    ///
    /// - Parameters:
    /// - property: The key path for the property to be set.
    /// - value: The value to set the property to.
    /// - Returns: A new instance with the specified property set to the given value.
    @discardableResult
    public func with<T>(_ property: WritableKeyPath<Self, T>, setTo value: T) -> Self {
        var new = self
        new[keyPath: property] = value
        return new
    }
}
