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
