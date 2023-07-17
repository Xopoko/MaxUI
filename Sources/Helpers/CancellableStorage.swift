import Combine

@resultBuilder
enum CancellableStorageBuilder {
    typealias Component = [AnyCancellable]
    typealias Expression = AnyCancellable

    /// Combines an array of partial results into a single partial result. A result builder must implement this method.
    static func buildBlock(_ components: Component...) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from a partial result that can be nil. Implement this method to support if statements that don’t include an else clause.
    static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(second:) to support switch statements and if statements that include an else clause.
    static func buildEither(first component: Component) -> Component {
        component
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(first:) to support switch statements and if statements that include an else clause.
    static func buildEither(second component: Component) -> Component {
        component
    }

    /// Builds a partial result from an array of partial results. Implement this method to support for loops.
    static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from an expression. You can implement this method to perform preprocessing—for example, converting expressions to an internal type—or to provide additional information for type inference at use sites.
    static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    static func buildExpression(_ expression: [Expression]) -> Component {
        expression
    }

    static func buildFinalResult(_ component: Component) -> Component {
        component
    }

    public static func buildExpression(_ expression: Expression?) -> Component {
         [expression].compactMap { $0 }
     }
}

struct CancellableStorage {
    @discardableResult
    init(
        in set: inout Set<AnyCancellable>,
        @CancellableStorageBuilder _ builder: () -> [AnyCancellable]
    ) {
        builder().forEach { $0.store(in: &set) }
    }
}
