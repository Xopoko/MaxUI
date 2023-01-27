import Foundation
import Combine

@propertyWrapper
public struct State<Value> {
    public var wrappedValue: Value {
        get { subject.value }
        nonmutating set { subject.send(newValue) }
    }

    public var projectedValue: Binding<Value> {
        return Binding<Value>.init(
            get: { [subject] in subject.value },
            set: { [subject] value in subject.send(value) },
            publisher: subject.eraseToAnyPublisher()
        )
    }
    
    private let subject: CurrentValueSubject<Value, Never>

    public init(wrappedValue value: Value) {
        subject = .init(value)
    }
    
    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }
}
