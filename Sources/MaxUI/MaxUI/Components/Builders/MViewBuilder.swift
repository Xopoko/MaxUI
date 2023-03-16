@resultBuilder
public enum MViewBuilder {
    public typealias Component = [MView]
    public typealias Expression = MView

    /// Combines an array of partial results into a single partial result. A result builder must implement this method.
    public static func buildBlock(_ components: Component...) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from a partial result that can be nil. Implement this method to support if statements that don’t include an else clause.
    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(second:) to support switch statements and if statements that include an else clause.
    public static func buildEither(first component: Component) -> Component {
        component
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(first:) to support switch statements and if statements that include an else clause.
    public static func buildEither(second component: Component) -> Component {
        component
    }

    ///    Builds a partial result from an array of partial results. Implement this method to support for loops.
    public static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from an expression. You can implement this method to perform preprocessing—for example, converting expressions to an internal type—or to provide additional information for type inference at use sites.
    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    public static func buildExpression(_ expression: [Expression]) -> Component {
        expression
    }

    public static func buildFinalResult(_ component: Component) -> Component {
        component
    }

    public static func buildExpression(_ expression: Expression?) -> Component {
         [expression].compactMap { $0 }
     }
}

@resultBuilder
public enum StackZBuilder {
    public typealias Component = [MZStack.LayoutModel]
    public typealias Expression = MZStack.LayoutModel

    /// Combines an array of partial results into a single partial result. A result builder must implement this method.
    public static func buildBlock(_ components: Component...) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from a partial result that can be nil. Implement this method to support if statements that don’t include an else clause.
    public static func buildOptional(_ component: Component?) -> Component {
        component ?? []
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(second:) to support switch statements and if statements that include an else clause.
    public static func buildEither(first component: Component) -> Component {
        component
    }

    /// Builds a partial result whose value varies depending on some condition. Implement both this method and buildEither(first:) to support switch statements and if statements that include an else clause.
    public static func buildEither(second component: Component) -> Component {
        component
    }

    ///    Builds a partial result from an array of partial results. Implement this method to support for loops.
    public static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }

    /// Builds a partial result from an expression. You can implement this method to perform preprocessing—for example, converting expressions to an internal type—or to provide additional information for type inference at use sites.
    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    public static func buildExpression(_ expression: Expression?) -> Component {
        [expression].compactMap { $0 }
    }

    public static func buildExpression(_ expression: [Expression]) -> Component {
        expression
    }

    public static func buildFinalResult(_ component: Component) -> Component {
        component
    }
}
