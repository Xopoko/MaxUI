import UIKit

/// This protocol determines whether a component can use the spacer behavior.
protocol EquidistantSpacingAdaptable: UIView {
    /// Helps to understand if the spacer can currently be used as a centering component
    var isReadyForEquidistantSpacing: Bool { get }
}
