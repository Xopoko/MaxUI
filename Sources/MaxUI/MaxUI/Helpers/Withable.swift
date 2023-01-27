public protocol Withable {}

extension Withable {
    @discardableResult
    public func with<T>(_ property: WritableKeyPath<Self, T>, setTo value: T) -> Self {
        var new = self
        new[keyPath: property] = value
        return new
    }
}
