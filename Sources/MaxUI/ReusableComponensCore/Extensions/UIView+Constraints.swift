import UIKit

extension UIView {
    
    func fill(with layout: SharedAppearance.Layout = .init(), on superview: UIView? = nil) {
        guard let superview = superview ?? self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        MaximUISides.allCases.forEach {
            fill(side: $0, with: layout, on: superview)
        }
    }
    
    private enum MaximUISides: String, CaseIterable {
        case top, bottom, left, right, width, height
        
        var identifier: String {
            return "maximUI_\(self.rawValue)Constraint"
        }
    }
    
    // swiftlint: disable cyclomatic_complexity
    private func fill(
        side: MaximUISides,
        with layout: SharedAppearance.Layout,
        on superview: UIView
    ) {
        switch side {
        case .top:
            if let topConstraint = self.constraints.first(where: {
                $0.identifier == side.identifier
            }), topConstraint.firstAnchor == topAnchor,
               topConstraint.secondAnchor == superview.topAnchor {
                topConstraint.constant = layout.insets.top
                topConstraint.isActive = true
            } else {
                let topConstraint = topAnchor.constraint(
                    equalTo: superview.topAnchor,
                    constant: layout.insets.top
                )
                topConstraint.identifier = side.identifier
                topConstraint.isActive = true
            }
        case .bottom:
            if let bottomConstraint = self.constraints.first(where: {
                $0.identifier == side.identifier
            }), bottomConstraint.firstAnchor == bottomAnchor,
               bottomConstraint.secondAnchor == superview.bottomAnchor {
                bottomConstraint.constant = -layout.insets.bottom
                bottomConstraint.isActive = true
            } else {
                let bottomConstraint = bottomAnchor.constraint(
                    equalTo: superview.bottomAnchor,
                    constant: -layout.insets.bottom
                )
                bottomConstraint.identifier = side.identifier
                bottomConstraint.isActive = true
            }
        case .left:
            if let leftConstraint = self.constraints.first(where: {
                $0.identifier == side.identifier
            }), leftConstraint.firstAnchor == rightAnchor,
               leftConstraint.secondAnchor == superview.leftAnchor {
                leftConstraint.constant = layout.insets.left
                leftConstraint.isActive = true
            } else {
                let leftConstraint = leftAnchor.constraint(
                    equalTo: superview.leftAnchor,
                    constant: layout.insets.left
                )
                leftConstraint.identifier = side.identifier
                leftConstraint.isActive = true
            }
        case .right:
            if let rightConstraint = self.constraints.first(where: {
                $0.identifier == side.identifier
            }), rightConstraint.firstAnchor == rightAnchor,
               rightConstraint.secondAnchor == superview.rightAnchor {
                rightConstraint.constant = -layout.insets.right
                rightConstraint.isActive = true
            } else {
                let rightConstraint = rightAnchor.constraint(
                    equalTo: superview.rightAnchor,
                    constant: -layout.insets.right
                )
                rightConstraint.identifier = side.identifier
                rightConstraint.isActive = true
            }
        case .width:
            if let width = layout.width {
                let widthConstraint = widthAnchor.constraint(equalToConstant: width)
                widthConstraint.identifier = side.identifier
                widthConstraint.isActive = true
            } else {
                self.constraints
                    .filter { $0.identifier == side.identifier }
                    .forEach { $0.isActive = false }
            }
        case .height:
            if let height = layout.height {
                let heightConstraint = heightAnchor.constraint(equalToConstant: height)
                heightConstraint.identifier = side.identifier
                heightConstraint.isActive = true
            } else {
                self.constraints
                    .filter { $0.identifier == side.identifier }
                    .forEach { $0.isActive = false }
            }
        }
        
    }
}
