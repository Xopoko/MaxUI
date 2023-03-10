import Foundation
import Combine

/// A `MBinding` is a property wrapper that represents a read-write value and its publisher.
///
/// - `Value` is the type of value that the binding wraps.
/// - `get` is the closure that retrieves the current value.
/// - `set` is the closure that sets the new value.
/// - `publisher` is the publisher that publishes the value changes.
///
/// A `MBinding` can be used with `Publisher` to implement data binding in SwiftUI or any other reactive frameworks.
@propertyWrapper @dynamicMemberLookup
public struct MBinding<Value> {

    /// The wrapped value, read and write access to this property is available via `get` and `set` closures.
    public var wrappedValue: Value {
        get { self.get() }
        nonmutating set { self.set(newValue) }
    }

    /// The projected value of the binding.
    public var projectedValue: MBinding<Value> {
        return self
    }

    /// The publisher that publishes the value changes.
    public let publisher: AnyPublisher<Value, Never>

    /// The closure that retrieves the current value.
    private let get: () -> Value
    /// The closure that sets the new value.
    private let set: (Value) -> Void

    /// Initializes a `MBinding` with `get`, `set` and `publisher` closures.
    ///
    /// - Parameters:
    ///   - get: The closure that retrieves the current value.
    ///   - set: The closure that sets the new value.
    ///   - publisher: The publisher that publishes the value changes.
    public init(
        get: @escaping () -> Value,
        set: @escaping (Value) -> Void,
        publisher: AnyPublisher<Value, Never>
    ) {
        self.get = get
        self.set = set
        self.publisher = publisher
    }

    /// Initializes a `MBinding` with another `MBinding`.
    ///
    /// - Parameters:
    ///   - projectedValue: Another `MBinding` to initialize with.
    public init(projectedValue: MBinding<Value>) {
        self = projectedValue
    }

    /// Creates a dynamic `MBinding` with a specified value.
    ///
    /// - Parameters:
    ///   - value: The value to wrap.
    public static func dynamic(_ value: Value) -> MBinding<Value> {
        Self.init(dynamicValue: value)
    }

    /// Creates a constant `MBinding` with a specified value.
    ///
    /// - Parameters:
    ///   - value: The value to wrap.
    public static func constant(_ value: Value) -> MBinding<Value> {
        Self.init(
            get: { value },
            set: { _ in },
            publisher: Just<Value>(value).eraseToAnyPublisher()
        )
    }

    /// Accesses the value of a `KeyPath` in the wrapped value.
    ///
    /// - Parameters:
    ///   - keyPath: The `KeyPath` to access the value.
    public subscript<Subject>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> MBinding<Subject> {
        MBinding<Subject>.init(
            get: { self.get()[keyPath: keyPath] },
            set: { newValue in
                var new = self.get()
                new[keyPath: keyPath] = newValue
                self.set(new)
            },
            publisher: self.publisher
                .map { $0[keyPath: keyPath] }
                .eraseToAnyPublisher()
        )
    }

    /*
        Backward compatibility initializer, it allows to change @Bidding value without
        using @MState as 'parent'.
     '''
        let text = MText("Name")
        text.text = "New name"
     '''
        Not a SwiftUI paradigm
    */
    public init(dynamicValue value: Value) {
        let subject: CurrentValueSubject<Value, Never> = .init(value)

        self.get = { subject.value }
        self.set = { newValue in subject.send(newValue) }
        self.publisher = subject.eraseToAnyPublisher()
    }

    /// Initializes a new instance of `MBinding` with the specified wrapped value.
    ///
    /// - Parameters:
    ///     - wrappedValue: The value that the binding wraps.
    public init(wrappedValue value: Value) {
        self.init(dynamicValue: value)
    }
}

extension MBinding {
    /// Initializes a new instance of the `MBinding` struct, wrapping the base binding.
    ///
    /// This initializer creates a new `MBinding` that wraps the given `base` binding,
    /// transforming its value from type `V` to `V?`.
    ///
    /// - Parameters:
    ///   - base: The binding to wrap.
    public init<V>(_ base: MBinding<V>) where Value == V? {
        self.init(
            get: { base.get() },
            set: { newValue in newValue.flatMap { base.set($0) } },
            publisher: base.publisher
                .map { Optional($0) }
                .eraseToAnyPublisher()
        )
    }

    /// Initializes a new instance of the `MBinding` struct, wrapping the base binding.
    ///
    /// This initializer creates a new `MBinding` that wraps the given `base` binding,
    /// transforming its value from type `V?` to `V`.
    ///
    /// - Parameters:
    ///   - base: The binding to wrap.
    public init?(_ base: MBinding<Value?>) {
        guard let initialValue = base.get() else {
            return nil
        }

        self.init(
            get: { base.get() ?? initialValue },
            set: { newValue in base.set(newValue) },
            publisher: base.publisher
                .compactMap { $0 }
                .eraseToAnyPublisher()
        )
    }
}
