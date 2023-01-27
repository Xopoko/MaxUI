import UIKit
import Combine

public struct ZStack: ComponentViewModelProtocol {
    public typealias CustomLayout = ((_ superview: UIView, _ subview: UIView) -> Void)
    public typealias ViewType = StackZView
    
    public struct LayoutModel {
        public var viewModel: ViewableViewModelProtocol
        public var customLayout: CustomLayout?
        
        public init(
            _ viewModel: () -> ViewableViewModelProtocol,
            customLayout: CustomLayout? = nil
        ) {
            self.viewModel = viewModel()
            self.customLayout = customLayout
        }
    }
    
    public var models: [LayoutModel] {
        get { _models.value }
        nonmutating set { _models.send(newValue) }
    }
    
    fileprivate let _models: CurrentValueSubject<[LayoutModel], Never>
    
    public init(@StackZBuilder _ builder: () -> [LayoutModel]) {
        self._models = .init(builder())
    }
    
    public init(@StackViewBuilder _ builder: () -> [ViewableViewModelProtocol]) {
        let models = builder().map { view in LayoutModel({ view }, customLayout: nil) }
        self._models = .init(models)
    }
}

public final class StackZView: UIView {}

extension StackZView: ReusableView {
    
    public func configure(with data: ZStack) {
        var canReuse = subviews.count == data.models.count
        if canReuse {
            for (index, viewModel) in data.models.enumerated() {
                guard
                    let view = subviews[safe: index],
                    type(of: view) == viewModel.viewModel.view
                else {
                    canReuse = false
                    break
                }
            }
        }
        
        if canReuse {
            for (index, viewModel) in data.models.enumerated() {
                guard let view = subviews[safe: index] as? AnyValueConfigurable else {
                    continue
                }
                (view as? PrepareReusable)?.prepareForReuse()
                view.configureWithValue(viewModel.viewModel)
            }
        } else {
            subviews.forEach { $0.removeFromSuperview() }
            
            data.models.forEach { model in
                let view = model.viewModel.createAssociatedViewInstance()
                addSubview(view)
                if let customLayout = model.customLayout {
                    customLayout(self, view)
                } else {
                    view.fill()
                }
            }
        }
    }
    
    public func prepareForReuse() {}
}
