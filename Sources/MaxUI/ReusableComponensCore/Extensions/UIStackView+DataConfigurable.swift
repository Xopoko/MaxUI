import UIKit

extension UIStackView {

    public func configure(models: [ViewModelProtocol]) {
        let arrangedSubviews = arrangedSubviews

        var canReuse = arrangedSubviews.count == models.count
        if canReuse {
            for (index, viewModel) in models.enumerated() {
                guard
                    let view = arrangedSubviews[safe: index],
                    type(of: view) == viewModel.view
                else {
                    canReuse = false
                    break
                }
            }
        }

        if canReuse {
            for (index, viewModel) in models.enumerated() {
                guard let view = arrangedSubviews[safe: index] as? AnyValueConfigurable else {
                    continue
                }
                (view as? PrepareReusable)?.prepareForReuse()
                view.configureWithValue(viewModel)
            }
        } else {
            removeArrangedSubviews()

            let views = models.map {
                $0.createAssociatedViewInstance()
            }

            views.forEach {
                addArrangedSubview($0)
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
