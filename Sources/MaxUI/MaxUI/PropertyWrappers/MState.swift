import Foundation
import Combine

/// The `MState` property wrapper adds state management to a MaxUI view. It holds a single value and
/// provides a binding that can be used to read and update the value from within the view. The value is
/// updated by sending new values to the `wrappedValue` property.
///
/// Example:
///
/// ```
/// @MState var name: String = ""
///
/// func configure(data: Model) {
///     MText($name)
///         .configure(in: self)
/// }
/// ```
@propertyWrapper
public struct MState<Value> {
    /// The wrapped value of this state property.
    ///
    /// Use this property to read or update the current value of this state property.
    public var wrappedValue: Value {
        get { subject.value }
        nonmutating set { subject.send(newValue) }
    }

    /// A binding to the wrapped value of this state property.
    ///
    /// Use this property to read or update the current value of this state property from within a view.
    public var projectedValue: MBinding<Value> {
        return MBinding<Value>.init(
            get: { [subject] in subject.value },
            set: { [subject] value in subject.send(value) },
            publisher: subject.eraseToAnyPublisher()
        )
    }

    private let subject: CurrentValueSubject<Value, Never>

    /// Creates a new instance of the state property with the given initial value.
    ///
    /// - Parameter wrappedValue: The initial value for the state property.
    public init(wrappedValue value: Value) {
        subject = .init(value)
    }

    /// Creates a new instance of the state property with the given initial value.
    ///
    /// - Parameter initialValue: The initial value for the state property.
    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }
}
