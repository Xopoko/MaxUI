import UIKit

extension UIStackView {
    /// Configures the UIStackView with the given models
    ///
    /// - Parameter models: The MView models to be added to the stack view.
    public func configure(models: [MView]) {
        let models = applyDidSelectActionIfNeeded(for: models)

        if models.isPossibleToReuse(with: arrangedSubviews) {
            models.reuse(with: arrangedSubviews)
        } else {
            removeArrangedSubviews()
            
            for model in models {
                let view = model.createAssociatedViewInstance()
                addArrangedSubview(view)
            }
            bindEquidistantSpacingAdaptables(arrangedSubviews)
        }
    }

    /// Adds the given `data` as an arranged subview of the UIStackView.
    ///
    /// - Parameter data: The `ViewModelProtocol` to be added as an arranged subview.
    /// - Returns: The `UIView` instance created from the `data`.
    @discardableResult
    public func addArranged(with data: ViewModelProtocol) -> UIView {
        let view = data.createAssociatedViewInstance()
        addArrangedSubview(view)
        return view
    }

    /// Removes all the arranged subviews from the UIStackView.
    public func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

extension UIStackView {
    private func applyDidSelectActionIfNeeded(for models: [MView]) -> [MView] {
        models.map {
            if let didSelect = ($0 as? ListItemActionable)?.didSelect {
                return $0.onSelect(animation: .alpha, didSelect)
            } else {
                return $0
            }
        }
    }
    
    private func bindEquidistantSpacingAdaptables(_ views: [UIView]) {
        let spacingAdaptables = views.compactMap { view -> EquidistantSpacingAdaptable? in
            guard let adaptable = view as? EquidistantSpacingAdaptable, adaptable.isReadyForEquidistantSpacing else {
                return nil
            }
            return adaptable
        }
        
        guard spacingAdaptables.count > 1, let firstAdaptable = spacingAdaptables.first else { return }
        
        for adaptable in spacingAdaptables.dropFirst() {
            let constraint = axis == .horizontal
            ? adaptable.widthAnchor.constraint(equalTo: firstAdaptable.widthAnchor)
            : adaptable.heightAnchor.constraint(equalTo: firstAdaptable.heightAnchor)
            constraint.isActive = true
        }
    }
}
