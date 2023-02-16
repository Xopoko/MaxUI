import UIKit

extension UIStackView {

    public func configure(models: [MView]) {
        if models.isPossibleToReuse(with: arrangedSubviews) {
            models.reuse(with: arrangedSubviews)
        } else {
            removeArrangedSubviews()
            
            for model in models {
                let view = model.createAssociatedViewInstance()
                addArrangedSubview(view)
            }
            bindSpaceables(arrangedSubviews)
        }
    }

    @discardableResult
    public func addArranged(with data: ViewModelProtocol) -> UIView {
        let view = data.createAssociatedViewInstance()
        addArrangedSubview(view)
        return view
    }

    public func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIStackView {
    private func bindSpaceables(_ views: [UIView]) {
        guard views.count > 1 else { return }
        
        var spaceables: [Spaceable] = []
        for view in views {
            if let spaceable = view as? Spaceable {
                spaceables.append(spaceable)
            }
        }
        
        guard spaceables.count > 1 else { return }
        
        var firstSpaceable: Spaceable?
        
        for spaceable in spaceables where spaceable.isReadyToBeSpaceable {
            if firstSpaceable == nil {
                firstSpaceable = spaceable
            } else {
                guard let firstSpaceable else { continue }
                
                if axis == .horizontal {
                    spaceable.widthAnchor.constraint(
                        equalTo: firstSpaceable.widthAnchor
                    ).isActive = true
                } else {
                    spaceable.heightAnchor.constraint(
                        equalTo: firstSpaceable.heightAnchor
                    ).isActive = true
                }
            }
        }
    }
}
