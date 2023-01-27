import Foundation
import Combine

@propertyWrapper @dynamicMemberLookup
public struct Binding<Value> {
    public var wrappedValue: Value {
        get { self.get() }
        nonmutating set { self.set(newValue) }
    }

    public var projectedValue: Binding<Value> {
        return self
    }

    public let publisher: AnyPublisher<Value, Never>
    
    private let get: () -> Value
    private let set: (Value) -> Void

    public init(
        get: @escaping () -> Value,
        set: @escaping (Value) -> Void,
        publisher: AnyPublisher<Value, Never>
    ) {
        self.get = get
        self.set = set
        self.publisher = publisher
    }

    public init(projectedValue: Binding<Value>) {
        self = projectedValue
    }
    
    public static func dynamic(_ value: Value) -> Binding<Value> {
        Self.init(dynamicValue: value)
    }

    public static func constant(_ value: Value) -> Binding<Value> {
        Self.init(
            get: { value },
            set: { _ in },
            publisher: Just<Value>(value).eraseToAnyPublisher()
        )
    }
    
    public subscript<Subject>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> Binding<Subject> {
        Binding<Subject>.init(
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
        using @State as 'parent'.
     '''
        let text = Text("Name")
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
    
    public init(wrappedValue value: Value) {
        self.init(dynamicValue: value)
    }
}

extension Binding {
    public init<V>(_ base: Binding<V>) where Value == V? {
        self.init(
            get: { base.get() },
            set: { newValue in newValue.flatMap { base.set($0) } },
            publisher: base.publisher
                .map { Optional($0) }
                .eraseToAnyPublisher()
        )
    }
    
    public init?(_ base: Binding<Value?>) {
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
