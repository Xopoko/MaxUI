public protocol Stylable {
    associatedtype Appearance
    
    @discardableResult
    func style(_ appearance: Appearance) -> Self
}
