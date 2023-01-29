import Foundation

@resultBuilder
public enum TextAttibutedBuilder {
    public typealias Component = NSAttributedString
    public typealias Expression = Any

    /// Combines an array of partial results into a single partial result. A result builder must implement this method.
    public static func buildBlock(_ components: Component...) -> Component {
        let attributedString = NSMutableAttributedString()
        components.forEach { attributedString.append($0) }
        return attributedString
    }

    /// Builds a partial result from a partial result that can be nil. Implement this method to support if statements that don’t include an else clause.
    public static func buildOptional(_ component: Component?) -> Component {
        component ?? NSAttributedString()
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
        let attributedString = NSMutableAttributedString()
        components.forEach { attributedString.append($0) }
        return attributedString
    }

    /// Builds a partial result from an expression. You can implement this method to perform preprocessing—for example, converting expressions to an internal type—or to provide additional information for type inference at use sites.
    public static func buildExpression(_ expression: Expression) -> Component {
        if let string = expression as? String {
            return NSAttributedString(string: string)
        } else if let attributedString = expression as? NSAttributedString {
            return attributedString
        }
        return NSAttributedString()
    }

    public static func buildExpression(_ expression: [Expression]) -> Component {
        let mutableAttributedString = NSMutableAttributedString()
        expression.forEach {
            if let string = $0 as? String {
                mutableAttributedString.append(NSAttributedString(string: string))
            } else if let attributedString = $0 as? NSAttributedString {
                mutableAttributedString.append(attributedString)
            }
        }
        return mutableAttributedString
    }

    public static func buildFinalResult(_ component: Component) -> Component {
        component
    }

    public static func buildExpression(_ expression: Expression?) -> Component {
        if let string = expression as? String {
            return NSAttributedString(string: string)
        } else if let attributedString = expression as? NSAttributedString {
            return attributedString
        }
        return NSAttributedString()
    }
}
