import UIKit
import Combine

public struct Gradient: ComponentViewModelProtocol {
    public typealias ViewType = GradientView
    
    public var model: ViewableViewModelProtocol? {
        get { _model.value }
        nonmutating set { _model.send(newValue) }
    }
    
    public var appearance: GradientView.Appearance? {
        get { _appearance.value }
        nonmutating set { if let newValue { _appearance.send(newValue) } }
    }
    
    fileprivate let _appearance: CurrentValueSubject<GradientView.Appearance, Never>
    fileprivate let _model: CurrentValueSubject<ViewableViewModelProtocol?, Never>
     
    public init(_ model: () -> ViewableViewModelProtocol) {
        self._model = .init(model())
        self._appearance = .init(GradientView.Appearance())
     }
    
    public init(
        model: ViewableViewModelProtocol?,
        appearance: GradientView.Appearance = GradientView.Appearance()
    ) {
        self._model = .init(model)
        self._appearance = .init(appearance)
     }
}

public final class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        super.init(frame: .zero)

        setupLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}

extension GradientView: ReusableView {
    
    public func configure(with data: Gradient) {
        data._model
            .sink { [weak self] model in
                guard let self, let model else { return }
                
                self.subviews.forEach { $0.removeFromSuperview() }
                let contentView = model.createAssociatedViewInstance()
                self.addSubview(contentView)
                contentView.fill()
            }
            .store(in: &cancellables)
        
        data._appearance
            .removeDuplicates()
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
            }
            .store(in: &cancellables)
    }
    
    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
private extension GradientView {
    private func setupLayout() {
        layer.addSublayer(gradientLayer)
    }
    
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        gradientLayer.colors = appearance.colors.map { $0.cgColor }
        gradientLayer.locations = appearance.locations
        gradientLayer.startPoint = appearance.startPoint
        gradientLayer.endPoint = appearance.endPoint
        gradientLayer.type = appearance.type
        
        updateLayer(with: appearance.layer)
        
        self.appearance = appearance
    }
}

public extension GradientView {
    struct Appearance: Equatable, Withable {
        public var layer: SharedAppearance.Layer
        public var colors: [UIColor]
        public var locations: [NSNumber]
        public var startPoint: CGPoint
        public var endPoint: CGPoint
        public var type: CAGradientLayerType
        
        public init(
            layer: SharedAppearance.Layer = SharedAppearance.Layer(),
            colors: [UIColor] = [],
            locations: [NSNumber] = [0, 1],
            startPoint: CGPoint = CGPoint(x: 0, y: 0),
            endPoint: CGPoint = CGPoint(x: 1, y: 1),
            type: CAGradientLayerType = .axial
        ) {
            self.layer = layer
            self.colors = colors
            self.locations = locations
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.type = type
        }
    }
}

extension Gradient: Stylable {
    public func style(_ appearance: GradientView.Appearance) -> Gradient {
        self.appearance = appearance
        return self
    }
}
