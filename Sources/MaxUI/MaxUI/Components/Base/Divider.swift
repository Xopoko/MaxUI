import UIKit

public struct Divider: ComponentViewModelProtocol {
    public typealias ViewType = DividerView
    
    public var appearance: DividerView.Appearance
    
    public init(appearance: DividerView.Appearance = DividerView.Appearance()) {
        self.appearance = appearance
    }
}

public final class DividerView: UIView {
    private let view = UIView()
    private var heightConstraint: NSLayoutConstraint?
    
    public init() {
        super.init(frame: .zero)
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DividerView: ReusableView {
    public func configure(with data: Divider) {
        updateAppearance(appearance: data.appearance)
    }
    
    public func prepareForReuse() {
        
    }
}

// MARK: - Private methods
private extension DividerView {
    func setupLayout() {
        view.fill(in: self)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: .zero)
        heightConstraint?.isActive = true
    }
    
    func updateAppearance(appearance: Appearance) {
        view.layer.cornerRadius = appearance.cornerRadius
        view.backgroundColor = appearance.color
        heightConstraint?.constant = appearance.height
    }
}

extension DividerView {
    public struct Appearance: Equatable {
        public var cornerRadius: CGFloat
        public var color: UIColor
        public var height: CGFloat
        
        public init(
            cornerRadius: CGFloat = .zero,
            color: UIColor = .lightGray,
            height: CGFloat = 1 / UIScreen.main.scale
        ) {
            self.cornerRadius = cornerRadius
            self.color = color
            self.height = height
        }
    }
}

#if DEBUG
import SwiftUI
struct Divider_Previews: PreviewProvider {
    static var previews: some View {
        ComponentPreview(distribution: .center) {
            Divider()
        }
    }
}
#endif
